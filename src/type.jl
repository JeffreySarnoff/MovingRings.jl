
#=
    Ring{T, Full}

T is the element type of the RingBuffer

`Full`` is true for buffers that are fully occupied,
and false for buffers that have any open slots.

The parameter `Full` is for internal use *ONLY*.
- To reach into the Ring paramters is unwise.
=#

mutable struct Ring{T,Full} <: AbstractVector{T}
    const ring::Vector{T}
    ilast::Int
end

# field and pseudofield retreival
buf(x::Ring) = x.ring
lastidx(x::Ring) = x.ilast

Base.lastindex(x::Ring) = lastidx(x)

Base.firstindex(x::Ring{T,false}) where {T} = 1
Base.firstindex(x::Ring{T,true}) where {T} =
    lastidx(x) === length(buf(x)) ? 1 : lastidx(x) + 1

# constructors

Ring(x::Ring) = x

"""
    Ring(::Type{T}, n; initial=zero(T))

Construct a new ring buffer
  - to buffer items of type `T`
  - to hold `n` or fewer current items
  - when full, and a new item is added, becoming

     - the newest, it overwrites the oldest
     - the oldest, it overwrites the newest

  > the buffer is initialized when constructed

  -  If `initial` is omitted, the buffer is zero-filled.
  - `Ring(T, n; initial=value)` pre-fills that value.
      
""" Ring

function Ring(::Type{T}, n; initial=zero(T)) where {T}
    if !iszero(initial)
        Ring{T,false}(fill(convert(T, initial), n), 0)
    else
        Ring{T,false}(zeros(T, n), 0)
    end
end

function Ring(v::Vector{T}) where {T}
    Ring{T,true}(v, length(v))
end

function Ring(v::Vector{T}, n; initial=zero(T)) where {T}
    if length(v) == n
        result = Ring(v)
    elseif length(v) > n
        result = Ring(v[1:n])
    else # length(v) < n
        result = Ring(T, n)
        result.ring[1:length(v)] .= v
        result.ring[length(v)+1:end] .= initial
        result.ilast = length(v)
    end
    result
end

function Ring(x::Ring{T,Full}, v::Vector{T}) where {T,Full}
    length(x) === length(v) || error("buffer and vector must be the same length")
    x.ring .= v
    x.ilast = length(v)
    x
end

function Ring(x::Ring{T1,Full}, v::Vector{T2}) where {T1,T2,Full}
    ring_checkvec(buf(x), v)
    for i in 1:length(x)
        vv = convert(T1, v[i])
        x.ring[i] = vv
    end
    x
end

function ring_checkvec(x::Vector{T1}, y::Vector{T2}) where {T1,T2}
    T1 == promote_type(T1, T2) && return
    # y2x = map(T1, view(y, :))
    # x2y = map(T2, view(y2x, :))
    # y == x2y && return
    ArgumentError("x::Ring{T1=$(T1)}, y::Vector{T2=$(T2)} and T1 !== promote_type(T1,T2)")
end

Ring(x::Ring{T1,Full1}, y::Ring{T2,Full2}) where {T1,T2,Full1,Full2} =
    error("Ring(::$(typeof(x)), ::$(typeof(y))) is not well-formed.")

Base.similar(x::Ring{T,Full}) where {T,Full} =
    Ring{T,Full}(Vector{T}(undef, length(x)), 0) 
   

Base.isempty(x::Ring) = iszero(lastindex(x))

isfull(x::Ring{T,false}) where {T} = false
isfull(x::Ring{T,true}) where {T} = true

function empty!(x::Ring{T,false}) where {T}
    x.ring .= zero(T)
    x.ilast = 0
    x
end

function empty!(x::Ring{T,true}) where {T}
    x.ring .= zero(T)
    x.ilast = length(x)
    x
end

# minimal requisites from Base

@inline Base.length(x::Ring) = length(x.ring)
@inline Base.size(x::Ring) = (length(x.ring),)
@inline Base.vec(x::Ring) = buf(x)
@inline Base.eltype(x::Ring{T,Full}) where {T,Full} = T

function Base.show(io::IO, ::MIME"text/plain", x::Ring{T,Full}) where {T,Full}
    show(io, buf(x))
end

#=
Note: Julia's copy is shallow, so mutable collections
(arrays, fields of mutable structs, ...) are shared
rather than duplicated. To duplicate the information
in a mutable collection, use `deepcopy`.

copied = copy(x::Ring)
=#
Base.copy(x::Ring{T, Full}) where {T, Full} =
    Ring{T, Full}(x.ring, x.ilast)

Base.deepcopy(x::Ring{T,Full}) where {T,Full} =
    Ring{T, Full}(deepcopy(x.ring), x.ilast)

function Base.copy!(dst::Ring{T,Full}, src::Ring{T,Full}) where {T,Full}
    length(dst) > length(src) &&
    ArgumentError("!(length(tgt) >= length(src))")

    copyto!(dst.ring, src.ring)
    dst.last = src.last
    dst
end


# basic indexing

function unsafe_index(x::Ring{T,false}, i) where {T}
    i
end

function unsafe_index(x::Ring{T,true}, i) where {T}
    n = length(x)
    idx = lastindex(x) + i
    idx - ifelse(idx > n, n, 0)
end

unsafe_getindex(x::Ring, i) =
    getindex(buf(x), unsafe_index(x, i))

function Base.getindex(x::Ring, i)
    check_forwardindex(x, i)
    unsafe_getindex(x, i)
end

# ring capable indexing

function getfirst(x::Ring, n::Integer=1)
    indices = forward_indices(x, n)
    unsafe_getindices(x, indices)
end

function getlast(x::Ring, n::Integer=1)
    indices = reverse_indices(x, n)
    unsafe_getindices(x, indices)
end

function getindices(x::Ring, indices)
    minidx, maxidx = extrema(indices)
    check_reverseindex(x, minidx)
    check_forwardindex(x, maxidx)
    unsafe_getindices(x, indices)
end

@inline unsafe_getindices(x::Ring, indices) =
    getindex.(Ref(x.ring), indices)

function forward_indices(x::Ring{T,false}, n::Integer) where {T}
    check_fowardindex(x, n)
    1:n
end

function reverse_indices(x::Ring{T,false}, n::Integer) where {T}
    start = length(x) - n + 1
    check_reverseindex(x, start)
    start:length(x)
end

# index validation, returns iff ok

check_reverseindex(x::Ring, i) =
    0 < i ||
    error("index ($(i)) out of bounds")

check_forwardindex(x::Ring, i) =
    i <= length(x) ||
    error("index ($(i)) out of bounds (1:$(length(x)))")

check_index(x::Ring, i) =
    1 <= i <= length(x) ||
    error("index ($(i)) out of bounds (1:$(length(x)))")

# all the content in logical order

"""
    allindices(::Ring)

obtain indices in their logical order
which is likely to be nonmonotonic for full rings.
"""
function allindices(x::Ring{T,false}) where {T}
    n = length(x)
    v = Vector{T}(undef, n)
    v .= 1:n
end

function allindices(x::Ring{T,true}) where {T}
    n = length(x)
    v = Vector{T}(undef, n)
    idxfirst = firstindex(x)
    span = n - idxfirst + 1
    v[1:span] .= idxfirst:n
    if idxfirst !== 1
        v[span+1:end] .= 1:lastindex(x)
    end
    v
end

function allvalues(x::Ring)
    buf(x)[allindices(x)]
end

"""
    unmap_indices(::Ring)

converts logical indices to their physical offsets

- this is a noop for rings that are not full
"""
unmap_indices(x::Ring{T,false}) where {T} = allindices(x)

function unmap_indices(x::Ring{T,true}) where {T}
    n = length(x)
    v = Vector{T}(undef, n)

    idxfirst = firstindex(x)
    span = n - idxfirst + 1

    v[idxfirst:idxfirst+span] .= 1:span

    if idxfirst !== 1
        v[1:lastindex(x)] .= span+1:n
    end
    v
end

"""
    logical_indices(::Ring, ::Range)

provides the logical indices that correspond
to the physical indices spanned by range.
"""
function logical_indices(x::Ring{T,false}, range::AbstractRange) where {T}
    check_indices(x, range)
    range
end

function logical_indices(x::Ring{T,true}, range::AbstractRange) where {T}
    check_indices(x, range)

    n = length(range)
    v = Vector{T}(undef, n)
    span = n - 1
    idxfirst = firstindex(x)
    idxv = 1

    for i in range
        idx = idxfirst + i - 1
        idx = ifelse(idx > n, idx - n, idx)
        v[idxv] = idx
        idxv += 1
    end

    v
end

# any, all, find

function Base.all(predicate, x::Ring)
    indices = allindices(x)
    result = true
    for idx in indices
        predicate(getindex(buf(x), idx)) ||
            (result = false; break)
    end
    result
end

function Base.any(predicate, x::Ring)
    indices = allindices(x)
    result = false
    for idx in indices
        predicate(getindex(buf(x), idx)) &&
            (result = true; break)
    end
    result
end

function Base.findfirst(predicate, x::Ring)
    indices = unmap_indices(x)
    result = -1
    for idx in indices
        predicate(getindex(buf(x), idx)) &&
            (result = idx; break)
    end
    result < 0 ? nothing : result
end

function Base.findlast(predicate, x::Ring)
    indices = reverse(unmap_indices(x))
    result = -1
    for idx in indices
        predicate(getindex(buf(x), idx)) &&
            (result = idx; break)
    end
    result < 0 ? nothing : result
end
