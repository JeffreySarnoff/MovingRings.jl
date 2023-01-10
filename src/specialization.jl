Base.issorted(x::Ring) = issorted(buf(x))
Base.issorted(x::Ring, xs...) = issorted(buf(x), xs...)

for OP in (:(==), :(!=), :(<), :(<=), :(>), :(>=))
    @eval begin
        (Base.$OP)(x::Ring{T,B}, y::Ring{T,B}) where {T,B} =
            length(x) === length(y) && $OP(buf(x), buf(y))
    end
end

