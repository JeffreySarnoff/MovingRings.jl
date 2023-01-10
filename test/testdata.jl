
v16int0s = Int16[0, 0, 0, 0]
v64int0s = Int64[0, 0, 0, 0]
v16int1s = Int16[1, 1, 1, 1]
v64int1s = Int64[1, 1, 1, 1]

v16flt0s = Float16[0, 0, 0, 0]
v64flt0s = Float64[0, 0, 0, 0]
v16flt1s = Float16[1, 1, 1, 1]
v64flt1s = Float64[1, 1, 1, 1]

testvecs = 
    (v16int0s, v64int0s, v16int1s, v64int1s,
     v16flt0s, v64flt0s, v16flt1s, v64flt1s)

r16int0s = Ring(v16int0s)
r64int0s = Ring(v64int0s)
r16flt0s = Ring(v16flt0s)
r64flt0s = Ring(v64flt0s)

r16int1s = Ring(v16int1s)
r64int1s = Ring(v64int1s)
r16flt1s = Ring(v16flt1s)
r64flt1s = Ring(v64flt1s)

testbufs = 
    (r16int0s, r64int0s, r16int1s, r64int1s,
     r16flt0s, r64flt0s, r16flt1s, r64flt1s)

testvecs, testbufs = reset_testdata(testvecs, testbufs)

function reset_testdata(testvecs, testbufs)

    v16int0s, v64int0s, v16int1s, v64int1s, v16flt0s, v64flt0s, v16flt1s, v64flt1s = testvecs
    r16int0s, r64int0s, r16int1s, r64int1s, r16flt0s, r64flt0s, r16flt1s, r64flt1s = testbufs

    v16int0s = Int16[0, 0, 0, 0]
    v64int0s = Int64[0, 0, 0, 0]
    v16int1s = Int16[1, 1, 1, 1]
    v64int1s = Int64[1, 1, 1, 1]

    v16flt0s = Float16[0, 0, 0, 0]
    v64flt0s = Float64[0, 0, 0, 0]
    v16flt1s = Float16[1, 1, 1, 1]
    v64flt1s = Float64[1, 1, 1, 1]

    r16int0s = Ring(v16int0s)
    r64int0s = Ring(v64int0s)
    r16flt0s = Ring(v16flt0s)
    r64flt0s = Ring(v64flt0s)

    r16int1s = Ring(v16int1s)
    r64int1s = Ring(v64int1s)
    r16flt1s = Ring(v16flt1s)
    r64flt1s = Ring(v64flt1s)

    testvecs = 
        (v16int0s, v64int0s, v16int1s, v64int1s,
         v16flt0s, v64flt0s, v16flt1s, v64flt1s,)

    testbufs = 
        (r16int0s, r64int0s, r16int1s, r64int1s,
         r16flt0s, r64flt0s, r16flt1s, r64flt1s,)

    (testvecs, testbufs)
end

testvecs, testbufs = reset_testdata(testvecs, testbufs);

