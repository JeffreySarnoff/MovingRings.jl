using BenchmarkTools, Test

pth = s"D:\Financial\Software\Julia\github\MovingRings.jl" 
cd(pth)

include("/test/constants.jl")
cd("src")

include("type.jl")
include("indices.jl")
include("ops.jl")
include("specialization.jl")

