module MovingRings

export AbstractRing, Ring, 
        # internal fields and same-named getters, 
        # exposed while developing
        buf, ilast,
        # end internals
        isfull, # isempty from Base
    # operations
    # these are exported from Base, overridden
    peekfirst, peekith, # peek
    # push!, pushfirst!,
    appendfirst!, # append!,
    # pop!, popfirst!,
    # indexing
    ithindex, ithvalue,
    allindices, allvalues,
    forward_index, forward_value,
    forward_indices, forward_values,
    reverse_index, reverse_value,
    reverse_indices, reverse_values

const VecTup = Union{Vector{T},NTuple{N,T}} where {T,N}

include("type.jl")
include("indices.jl")
include("ops.jl")
include("specialization.jl")

if haskey(ENV, "Unsafe") && ENV["Unsafe"] == "true"
    MovingRings.ithindex(r::Ring, i) = MovingRings.unsafe_ithindex(r, i)
    Base.getindex(r::Ring, i) = MovingRings.unsafe_getindex(r, i)
    MovingRings.forwardindex = MovingRings.unsafe_forwardindex
    MovingRings.reverseindex = MovingRings.unsafe_reverseindex
end

end  # MovingRings

