@testset "ithindex" begin
    @test firstindex(r4) == 1
    @test firstindex(r4pushed) == 2

    @test lastindex(r4) == 4
    @test lastindex(r4pushed) == 1

    @test ithindex(r4, 2) == 2
    @test ithindex(r4pushed, 2) == 3
end

@testset "allindices" begin
    @test allindices(r4) == [1, 2, 3, 4]
    @test allindices(r4pushed) == [2, 3, 4, 1]
end

@testset "forward" begin
    @test forward_indices(r4, 1, 3) == [1, 2, 3]
    @test forward_indices(r4, 2:4) == [2, 3, 4]
end

@testset "reverse" begin
    @test reverse_indices(r4, 1, 3) == [4, 3, 2]
    @test reverse_indices(r4, 2:4) == [3, 2, 1]
end

@testset "ring forward" begin
    @test r4[forward_indices(r4, 2, 4)] == [2, 3, 4]
    @test r4[forward_indices(r4, 1:3)] == [1, 2, 3]
end

@testset "ring reverse" begin
    @test r4[reverse_indices(r4, 2, 4)] == [3, 2, 1]
    @test r4[reverse_indices(r4, 1:3)] == [4, 3, 2]
end
