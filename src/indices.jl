#=


    indexing first (oldest) and last (newest) entries

    ring = Ring(Int16, 4; initvalue=typemin(Int16))
    # constructed, unused

    [ initvalue      , initvalue...]
      lastindex  == 0  # these two values let push!
      firstindex == 1  # omit one conditional test

      function get(ring::Ring{T, false}, idx::Int, default::T) where {T}
           get(buf(ring), idx, default)
      end





    # constructed, single value present

    [ firstvalue     , initvalue... ]
      lastindex  == 1
      firstindex == 1

    # constructed, two values present
    # earlier, at time1, push!(ring, value1)
    # later,   at time2, push!(ring, value2)

    lastvalue(ring)  == value2  # most  recent, added at front
    firstvalue(ring) == value1  # least recent, added at back

    [ value1          , initvalue... ]
      lastindex  == 1
      firstindex == 1

    [ value2         , value1          , initvalue... ]
      lastindex == 1 , firstindex == 2



    # unfull, at least two unused slots
    [first .. last, initvalue, initvalue...]

    indexing first (oldest) and last (newest) entries

    # full
    [first .. last]
    [last, first ..]
    [.., last, first ..]
    [.., last, first]
    [first .. last]
    ...
=#

"""
    forward_index(::Ring, i)

the index corresponding to the ith value from 
the begining of the ring

- forward_index(::Ring, 1) == firstindex(::Ring)
- forward_index(::Ring, 2) == index the second value

- forward_index(::Ring, -index) ⤇ reverse_index(::Ring, index)
"""
forward_index

"""
    reverse_index(::Ring, i)

the index corresponding to the ith value from 
the end of the ring

- reverse_index(::Ring, 1) == lastindex(::Ring)
- reverse_index(::Ring, 2) == index the penultimate value

- reverse_index(::Ring, -index) ⤇ forward_index(::Ring, index)
"""
reverse_index

"""
    forward_indices(::Ring, idxlo, idxhi)

    forward_indices(::Ring, idxlo:idxhi)

Provides the indices corresponding to
the values that span the bounds given
taken from the begining of the ring.

# Examples
```julia-repl
julia> r = Ring([5, 6, 7, 8]);

julia> forward_indices(r, 1, 2) == [1, 2]
true

julia> r[forward_indices(r, 1, 2)] == [5, 6]
true
```

It is an _unchecked error_ to use negative indices.
"""
forward_indices

"""

    reverse_indices(::Ring, idxlo, idxhi)

    reverse_indices(::Ring, idxlo:idxhi)

Provides the indices corresponding to
the values that span the bounds given
taken from the end of the ring.

# Examples
```julia-repl
julia> ring = Ring([5, 6, 7, 8]);

julia> reverse_indices(ring, 1, 2) == [4, 3]

julia> r[reverse_indices(ring, 1:2)] == [8, 7]
```

It is an _unchecked error_ to use negative indices.
"""
reverse_indices
