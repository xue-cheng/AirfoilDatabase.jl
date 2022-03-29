# AirfoilDatabase.jl
Easy-to-use airfoil database from [UIUC](https://m-selig.ae.illinois.edu/ads/coord_database.html).

[![ci](https://github.com/xue-cheng/AirfoilDatabase.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/xue-cheng/AirfoilDatabase.jl/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/xue-cheng/AirfoilDatabase.jl/badge.svg?branch=master)](https://coveralls.io/github/xue-cheng/AirfoilDatabase.jl?branch=master)

## Usage
```julia
# import the package
using AirfoilDatabase
# query from database
result = query_airfoil("RAE 2822")
@assert length(result) == 1
airfoil = result[1]
@show airfoil.name
@show airfoil.desc
@show airfoil.x # x-coordinates
@show airfoil.y # y-coordinates

#4-digit NACA airfoil
np = 65 # num of points on each side, including the leading edge point
airfoil = NACA("0012", np) # optinal kwarg: sharpTE=true for zero-thick trailing edge
# specify the chordwise distribution
x = LinRange(0, 1, 33)
airfoil = NACA("2412", x; sharpTE=true) 
```
