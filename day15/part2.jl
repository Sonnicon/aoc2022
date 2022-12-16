# I just spent 15 minutes bruteforcing this one, algorithm is enough to not go into trillions of iterations.

file = open("input.txt")
const bound = 4000000
# List of values, where [sensor1x, sensor1y, beacon1x, beacon1y, sensor2x, sensor2y, beacon2x, ...
coordinates = zeros(0)
# List of manhattan distances between each sensor and beacon
distances = zeros(0)

while !eof(file)
    line = readline(file)
    # Pull out values
    values = map(eachmatch(r"-?\d+", line)) do match
        parse(Int64, match.match)
    end
    # Append to the lists
    append!(coordinates, values)
    distance = abs(values[1] - values[3]) + abs(values[2] - values[4])
    append!(distances, distance)
end

i = 0
# Iterate across all of the tiles from left to right
while (i <= bound * bound)
    # Scope is still funky
    global i
    # Which sensor we are comparing
    j = 0
    # Most known tiles we can skip and be safe
    maxvalid = 0
    # Most unknown tiles we can skip and be safe
    minvalid = nothing
    
    while j < length(distances)
        # Distance from current to tangent point
        mdist = abs(coordinates[j * 4 + 1] - (i%bound))
        # Distance from center to tangent point
        ydist = abs(coordinates[j * 4 + 2] - div(i, bound))
        # Distance from center to current
        dist = mdist + ydist
        # Distance between edge and current
        cdist = dist - distances[j + 1]

        if coordinates[j * 4 + 1] > i
            # We are inside known, to the left of the center
            if (mdist + distances[j + 1] - ydist > maxvalid) && (cdist <= 0)
                # Skip to the far right of the known area
                maxvalid = mdist + distances[j + 1] - ydist
            end
        else
            # We are inside known, to the right of the center
            if (distances[j + 1] - dist > maxvalid) && (cdist <= 0)
                # Skip to the far right of the known are
                maxvalid = distances[j + 1] - dist
            end
        end
   
        # We are in the unknown area
        if (minvalid == nothing) || (cdist < minvalid)
            minvalid = cdist
        end
        j += 1
    end
    if ((minvalid == nothing) || (minvalid <= 0))
        # We are inside known area
        if maxvalid == 0
            i += 1
        else
            i += maxvalid
        end
    else
        # We are inside unknown area
        println((i%bound)*bound+div(i, bound))
        i += bound * bound
    end
end
