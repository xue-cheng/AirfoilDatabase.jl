# AirfoilDatabase.jl
Easy-to-use airfoil database from [UIUC](https://m-selig.ae.illinois.edu/ads/coord_database.html).

[![ci](https://github.com/xue-cheng/AirfoilDatabase.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/xue-cheng/AirfoilDatabase.jl/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/xue-cheng/AirfoilDatabase.jl/badge.svg?branch=master)](https://coveralls.io/github/xue-cheng/AirfoilDatabase.jl?branch=master)

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
