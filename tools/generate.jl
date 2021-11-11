using Downloads
using ZipFile
url = "https://m-selig.ae.illinois.edu/ads/archives/coord_seligFmt.zip"
archive = joinpath(@__DIR__, "coord_seligFmt.zip")
reader = ZipFile.Reader(archive)
output = open(joinpath(@__DIR__, "../src/database.jl"), "w")
println(output, "#################### AUTO GENERATED! DO NOT MODIFY ####################")
println(output, "const database = AirfoilData[")
index = []
asciionly(s) =  join(map(m->getfield(m, :match), eachmatch(r"[0-9a-z ]", s)))

function formatpoints(points)
    x0, y0 = parse.(Float64, split(points[1]))
    iox = IOBuffer()
    ioy = IOBuffer()
    print(iox, '[')
    print(ioy, '[')
    if x0>2 && y0>2 # Lednicer's format
        np1 = round(Int, x0)
        np2 = round(Int, y0)
        @assert np1+np2 == length(points)-1
        for i in np1:-1:2
            x, y = split(points[i+1])
            print(iox, x, ',')
            print(ioy, y, ',')
        end
        for i in 1:np2
            x, y = split(points[i+1+np1])
            print(iox, x, ',')
            print(ioy, y, ',')
        end
    else # original format
        for l in points
            x, y = split(l)
            print(iox, x, ',')
            print(ioy, y, ',')
        end
    end
    print(iox, "],")
    write(iox, take!(ioy))
    print(iox, ']')
    String(take!(iox))
end

for f in reader.files
    dir, fname = splitdir(f.name)
    name, ext = splitext(fname)
    name = uppercase(name)
    lines = readlines(f)
    desc = strip(lines[1])
    points = filter(l->!isempty(l), strip.(@view lines[2:end]))
    @info "    $name: $desc"
    println(output, "    AirfoilData(\"", name, "\",\"", desc, "\",", formatpoints(points), "),")
    push!(index, lowercase(name) * " " * asciionly(lowercase(desc)))
end

println(output, "]")
println(output)
println(output, "const index = String[")
for l in index
    println(output, "    \"", l, "\",")
end
println(output, "]")
println(output)
println(output, "const db_size = $(length(index))")
close(output)