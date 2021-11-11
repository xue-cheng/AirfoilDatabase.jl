# AirfoilDatabase.jl
Easy-to-use airfoil database from [UIUC](https://m-selig.ae.illinois.edu/ads/coord_database.html).

## Usage
```julia
using AirfoilDatabase
result = query_airfoil("RAE 2822")
@assert length(result) == 1
airfoil = result[1]
@show airfoil.name
@show airfoil.desc
@show airfoil.x # x-coordinates
@show airfoil.y # y-coordinates
```