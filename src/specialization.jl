Base.issorted(x::Ring) = issorted(buf(x))
Base.issorted(x::Ring, xs...) = issorted(buf(x), xs...)

for OP in (:(==), :(!=), :(<), :(<=), :(>), :(>=))
    @eval begin
        (Base.$OP)(x::Ring{T,B}, y::Ring{T,B}) where {T,B} =
            length(x) === length(y) && $OP(buf(x), buf(y))
    end
end


#= comparisons

function Base.:(==)(x::Ring{T, Full}, y::Ring{T, Full}) where {T, Full}
    length(x) === length(y) || return false
    (n = length(x)) == 0 && return true
    result = true
    for i in 1:n
        getindex(x, i) !== getindex(y, 1) && (result = false; break)
    end
    result
end

=#
