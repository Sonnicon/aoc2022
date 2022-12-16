file = open("input.txt")
const ylevel = 2000000 
# List of values, where [sensor1x, sensor1y, beacon1x, beacon1y, sensor2x, sensor2y, beacon2x, ...
coordinates = zeros(0)
# List of manhattan distances between each sensor and beacon
distances = zeros(0)

# x-coordinate of the furthest left and furthest right tile of a rectangle bounding all distances
leftmost = nothing
rightmost = nothing

while !eof(file)
    # Scope in this is funky
    global leftmost
    global rightmost
    line = readline(file)
    # Pull out values
    values = map(eachmatch(r"-?\d+", line)) do match
        parse(Int64, match.match)
    end
    # Append to the lists
    append!(coordinates, values)
    distance = abs(values[1] - values[3]) + abs(values[2] - values[4])
    append!(distances, distance)

    # Min and max x
    if (leftmost == nothing || values[1]-distance < leftmost)
        leftmost = values[1] - distance
    end
    if (rightmost == nothing || values[1] + distance > rightmost)
        rightmost = values[1] + distance
    end
end

result = 0
i = leftmost
# Iterate across all of the tiles from left to right
while (i <= rightmost)
    # Scope is still funky
    global i
    global result

    # Which sensor we are comparing
    j = 0
    # Most known tiles we can skip and be safe
    maxvalid = 0
    # Most unknown tiles we can skip and be safe
    minvalid = nothing
    
    while j < length(distances)
        # Distance from current to tangent point
        mdist = abs(coordinates[j * 4 + 1] - i)
        # Distance from center to tangent point
        ydist = abs(coordinates[j * 4 + 2] - ylevel)
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
            result += maxvalid
        end
    else
        # We are inside unknown area
        i += minvalid
    end
end
println(result)
