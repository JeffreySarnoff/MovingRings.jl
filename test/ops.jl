@testset "peek: _, first, ith" begin
    v4 = collect(1:4)
    r4 = Ring(v4)

    @test peek(r4) == 4
    @test peekfirst(r4) == 1
    @test peekith(r4, 2) == 2
    @test peekith(r4, 3) == 3
end

@testset "push!" begin
    v7 = collect(1:7)
    r7 = Ring(v7)
    push!(r7, 8)
    @test vec(r7) == [8, 2, 3, 4, 5, 6, 7]
    @test allvalues(r7) == [2, 3, 4, 5, 6, 7, 8]

    push!(r7, 9, 10)
    @test vec(r7) == [8, 9, 10, 4, 5, 6, 7]
    @test allvalues(r7) == [4, 5, 6, 7, 8, 9, 10]
end

@testset "pushfirst!" begin
    v7 = collect(1:7)
    r7 = Ring(v7)
    pushfirst!(r7, 8)
    @test vec(r7) == [1, 2, 3, 4, 5, 6, 8]
    @test allvalues(r7) == [8, 1, 2, 3, 4, 5, 6]

    pushfirst!(r7, 9, 10)
    @test vec(r7) == [8, 9, 10, 4, 5, 6, 7]
    @test allvalues(r7) == [4, 5, 6, 7, 8, 9, 10]
end

@testset "appendfirst!" begin
    v7 = collect(1:7)
    r7 = Ring(v7)
    appendfirst!(r7, [8])
    @test vec(r7) == [1, 2, 3, 4, 5, 6, 8]
    @test allvalues(r7) == [8, 1, 2, 3, 4, 5, 6]

    appendfirst!(r7, (9, 10))
    @test vec(r7) == [8, 9, 10, 4, 5, 6, 7]
    @test allvalues(r7) == [4, 5, 6, 7, 8, 9, 10]
end
