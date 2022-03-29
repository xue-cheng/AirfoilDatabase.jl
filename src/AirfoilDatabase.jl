module AirfoilDatabase

using Printf
struct AirfoilData
    name::String
    desc::String
    x::Vector{Float64}
    y::Vector{Float64}
end

function Base.show(io::IO, airfoil::AirfoilData) 
    print(io, airfoil.name, ' ', '(', airfoil.desc, ')')
end

include("database.jl")

function query_airfoil(name::AbstractString)::Vector{AirfoilData}
    que = split(lowercase(name))
    result = Vector{AirfoilData}()
    for i in 1:db_size
        idx = index[i]
        if all(q->occursin(q, idx), que)
            push!(result, database[i])
        end
    end
    return result
end

include("NACA.jl")

export AirfoilData, query_airfoil, NACA

end # module
