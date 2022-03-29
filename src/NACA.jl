function NACA(number::AbstractString, x::AbstractVector; sharpTE::Bool=false)
    ndig = length(strip(number))
    ndig == 4 || error("invalid number=\"$number\": must be a 4-digit integer")
    xc = convert(Vector{Float64}, x)
    sort!(xc)
    if xc[1] != 0
        insert!(xc, 1, 0)
    end
    return NACA(Val(ndig), parse(Int, number), xc, sharpTE)
end

function NACA(number::AbstractString, np::Int; sharpTE::Bool=false)
    xc = collect(LinRange(0, π, np))
    return NACA(number, xc; sharpTE=sharpTE)
end

function NACA_T(xc::AbstractVector{Float64}, t::Float64, sharpTE::Bool)
    a0 = +0.2969
    a1 = -0.1260
    a2 = -0.3516
    a3 = +0.2843
    a4 = sharpTE ? -0.1036 : -0.1015
    yt = similar(xc)
    @. yt = 5t*(a0*sqrt(xc)+a1*xc+a2*xc^2+a3*xc^3+a4*xc^4)
    return yt
end

function NACA_Airfoil(
    name::AbstractString,
    desc::AbstractString,
    xc::AbstractVector{Float64},
    yt::AbstractVector{Float64},
    yc::AbstractVector{Float64},
    dyc::AbstractVector{Float64})

    np = length(xc)
    x = zeros(2np-1)
    y = zeros(2np-1)
    x[np] = y[np] = 0 # leading edge
    @inbounds for i in 2:np
        iu = np-i+1
        il = np+i-1
        θ = atan(dyc[i])
        x[iu] = xc[i] - yt[i]*sin(θ)
        x[il] = xc[i] + yt[i]*sin(θ)
        y[iu] = yc[i] + yt[i]*cos(θ)
        y[il] = yc[i] - yt[i]*cos(θ)
    end
    return AirfoilData(name, desc, x, y)
end

function NACA(::Val{4}, num::Int, xc::AbstractVector{Float64}, sharpTE::Bool)
    @assert num > 0 "number must be positive"
    m = (num ÷ 1000) * 0.01
    p = ((num ÷ 100) % 10) * 0.1
    t = (num % 100) * 0.01
    yt = NACA_T(xc, t, sharpTE)
    np = length(xc)
    yc = zeros(np)
    dyc = zeros(np)
    name = @sprintf "NACA %04d" num
    desc = @sprintf "Thickness=%d%%, Camber=%d%% AT %d%%" t*100 m*100 p*100
    if p > 0 
        @inbounds for i in eachindex(xc)
            xx = xc[i]
            if xx <= p
                yc[i] = m * p^-2 * (2p*xx-xx^2)
                dyc[i] = 2m * p^-2 * (p-xx)
            else
                yc[i] = m * (1-p)^-2 * ((1-2p) + 2p*xx - xx^2)
                dyc[i] = 2m * (1-p)^-2 * (p-xx)
            end
        end
    end
    return NACA_Airfoil(name, desc, xc, yt, yc, dyc)
end
