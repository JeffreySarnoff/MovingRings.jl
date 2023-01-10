# operators

# peek

Base.peek(x::Ring) = buf(x)[lastindex(x)]
peekfirst(x::Ring) = buf(x)[firstindex(x)]
peekith(x::Ring, i) = buf(x)[ithindex(x, i)]

Base.peek(x::Ring{T, false}, n::Integer) where {T} =
   buf(x)[lastindex(x):(lastindex(x)-n+1)]

peekfirst(x::Ring{T,false}, n::Integer) where {T} =
    buf(x)[firstindex(x):firstindex(x)+n-1]

peekith(x::Ring{T,false}, i::Int, n::Integer) where {T} =
    buf(x)[ithindex(x, i):ithindex(x, i + n -1)]

function Base.peek(x::Ring{T,true}, n::Integer) where {T}
    indices = logical_indices(lastindex(x):lastindex(x)-n+1)
    buf(x)[indices]
end

function peekfirst(x::Ring{T,true}, n::Integer) where {T}
    indices = logical_indices(firstindex(x):firstindex(x)+n-1)
    buf(x)[indices]
end

function peekith(x::Ring{T,true}, i::Int, n::Integer) where {T}
    indices = logical_indices(i::(i + n - 1))
    buf(x)[indices]
end



# push

#=
    indexing first (oldest) and last (newest) entries

    # not full
    [first, last, 0...]
    [first .. last, 0...]
    # full
    [first .. last]
=#

function Base.push!(x::Ring{T, false}, @nospecialize value) where {T}
    x.ilast += 1
    buf(x)[lastindex(x)] = convert(T, value)
    if lastindex(x) >= length(x)
        x = Ring(buf(x))
    end
    x
end

function Base.pushfirst!(x::Ring{T, false}, @nospecialize value) where {T}
    buf(x)[2:lastindex(x)+1] .= buf(x)[1:lastindex(x)]
    buf(x)[1] = convert(T, value)
    x.ilast += 1
    if lastindex(x) >= length(x)
        x = Ring(buf(x))
    end
    x
end

#=
    indexing first (oldest) and last (newest) entries

    # full
    [first .. last]
    [last, first ..]
    [.., last, first ..]
    [.., last, first]
    [first .. last]
    ...
=#

function Base.push!(x::Ring{T, true}, @nospecialize value) where {T}
    buf(x)[firstindex(x)] = convert(T, value)
    x.ilast += ifelse(lastindex(x) == length(x), 1-x.ilast, 1)
    x
end

function Base.pushfirst!(x::Ring{T, true}, @nospecialize value) where {T}
    buf(x)[lastindex(x)] = convert(T, value)
    x.ilast = ifelse(lastidndex(1) === 1, length(x), -1 + x.last)
    x
end

function Base.push!(x::Ring{T, true}, @nospecialize vals...) where {T}
    for v in vals
        push!(x, v)
    end
    x
end

function Base.pushfirst!(x::Ring{T, true}, @nospecialize vals...) where {T}
    for v in vals
        pushfirst!(x, v)
    end
    x
end



# append

#=
    indexing first (oldest) and last (newest) entries

    # not full
    [first, last, 0...]
    [first .. last, 0...]
    # full
    [first .. last]
=#

function Base.append!(x::Ring{T, false}, items::VecTup) where {T}
    for v in items
        x = push!(x, v)
    end
    x
end

function appendfirst!(x::Ring{T, false}, items::VecTup) where {T}
    for v in items
        x = pushfirst!(x, v)
    end
    x
end

function Base.append!(x::Ring{T, true}, items::VecTup) where {T}
    for v in items
        push!(x, v)
    end
    x
end

function appendfirst!(x::Ring{T, true}, items::VecTup) where {T}
    for v in items
        pushfirst!(x, v)
    end
    x
end

#=
    indexing first (oldest) and last (newest) entries

    # full
    [first .. last]
    [last, first ..]
    [.., last, first ..]
    [.., last, first]
    [first .. last]
    ...
=#

# pop

function Base.pop!(x::Ring{T, false}) where {T}
    lastindex(x) == 0 && error("cannot pop an empty buffer")

    value = peeklast(x)
    buf(x)[lastindex(x)] = typemin(T)
    x.ilast -= 1
    (value, x)
end

function Base.popfirst!(x::Ring{T, false}) where {T}
    lastindex(x) == 0 && error("cannot pop an empty buffer")

    value = peekfirst(x)
    x.ring[1:lastindex(x)-1] .= x.ring[2:lastindex(x)]
    x.ring[lastindex(x)] = typemin(T)
    x.ilast -= 1
    (value, x)
end

function Base.pop!(x::Ring{T, true}) where {T}
    value = peeklast(x)
    r = Ring(buf(x)[1:end-1], length(x))
    (value, r)
end

function Base.popfirst!(x::Ring{T, true}) where {T}
    value = peekfirst(x)
    r = Ring(buf(x)[2:end], length(x))
    (value, r)
end
