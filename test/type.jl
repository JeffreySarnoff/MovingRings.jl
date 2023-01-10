testvecs, testbufs = reset_consts(testvecs, testbufs)
v16int0s, v64int0s, v16int1s, v64int1s, v16flt0s, v64flt0s, v16flt1s, v64flt1s = testvecs
r16int0s, r64int0s, r16int1s, r64int1s, r16flt0s, r64flt0s, r16flt1s, r64flt1s = testbufs


@testset "constructors" begin

    ring = Ring(Int16, 4)
    @test ring == r16int0s
    @test buf(ring) == v16int0s
    @test lastindex(ring)  == 0
    @test firstindex(ring) == 1

    @test 
    Ring(ring, v64flt1s)
    @test buf(ring) == v16int1s
    @test ring == v16int1s

    Ring(ring, v16int0s)
    @test ring == v16int0s

    ring = Ring(Int16, 4)
    Ring(ring, v64int1s)
    @test buf(ring) == v16int1s


end



@testset "construct from vector, lengths equal, sizeof equal" begin

    @testset "shared type" begin
        Ring(r16int0s, v16int1s)
        @test peek(r16int0s) == v16int1s[end]
        Ring(r16int0s, v16int0s)                        # reset test dta
    end

    @testset "float buffer and int vector" begin
        Ring(r16flt0s, v16int1s)
        @test peek(r16int0s) == v16flt1s[end]
        Ring(r16int0s, v16int0s)                        # reset test dta
    end

    @testset "int buffer and float vector" begin
        Ring(r16int0s, v16flt1s)                        # reset test dta
        @test peek(r16int0s) == v16flt1s[end]
    end

end

@testset "construct from vector, lengths equal, sizeof not equal" begin

    @testset "shared type" begin
        Ring(r16int0s, v64int1s)
        @test peek(r16int0s) == Float16.(v64int1s[end])
        Ring(r16int0s, v16int0s)                        # reset test dta
    end

    @testset "float buffer and int vector" begin
        Ring(r16flt0s, v16int1s)
        @test peek(r16int0s) == Float16.(v64int1s[end])
        @test peek(r16int0s) == Float16.(v64int1s[end])
        Ring(r16int0s, v16int0s)                        # reset test dta
    end

    @testset "int buffer and float vector" begin
        Ring(r16int0s, v16flt1s)                        # reset test dta
        @test peek(r16int0s) == v16flt1s[end]
    end

end


testvecs, testbufs = reset_consts(testvecs, testbufs)
v16int0s, v64int0s, v16int1s, v64int1s, v16flt0s, v64flt0s, v16flt1s, v64flt1s = testvecs
r16int0s, r64int0s, r16int1s, r64int1s, r16flt0s, r64flt0s, r16flt1s, r64flt1s = testbufs
