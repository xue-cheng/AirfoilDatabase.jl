using AirfoilDatabase
using Test
@testset "query" begin
    sd7003 = query_airfoil("7003")
    @test length(sd7003) == 1
    @test sd7003[1].name == "SD7003"
    sc2 = query_airfoil("NASA SC2")
    @test length(sc2) > 1
end