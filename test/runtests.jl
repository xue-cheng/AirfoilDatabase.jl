using AirfoilDatabase
using Test
@testset "query" begin
    sd7003 = query_airfoil("7003")
    @test length(sd7003) == 1
    @test sd7003[1].name == "SD7003"
    sc2 = query_airfoil("NASA SC2")
    @test length(sc2) > 1
end

@testset "NACA" begin 
    n0012 = query_airfoil("N0012")
    @test length(n0012) == 1
    x = n0012[1].x
    ile = argmin(x)
    xc = x[ile:-1:1]
    af = NACA("0012", xc)
    @test af.x[ile] == af.y[ile] == 0 
    @test all(isapprox.(af.y, n0012[1].y, atol=1e-5))
    af = NACA("4412")
    @test length(af.x) == 65
    @test (af.x[end] + af.x[1])/2 == 1
    @test af.x[33] == af.y[33] == 0
    @test af.y[end] < af.y[1]
    af = NACA("4412", sharpTE=true)
    @test af.x[end] == af.x[1] == 1
    @test isapprox(af.y[end], af.y[1], atol=1e-6)
end