using MovingRings, Test

include("testdata.jl")

@testset "type" begin
    include("type.jl")
end

@testset "indices" begin
    include("indices.jl")
end

@testset "ops" begin
    include("ops.jl")
end
