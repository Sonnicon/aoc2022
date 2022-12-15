local file = io.open("input.txt", "r")

local value = 1 
local cycle = 0
local instruction = 0
local result = 0

while true do
	::continue::
	cycle = cycle + 1
	if math.fmod(cycle,  40) == 20 then
		result = result + value * cycle
	end

	local text = file.read(file)
	if text == nil or text == "" then
		break
	end
	local size = 0
	for item in text:gmatch("[^ ]+") do
		size = size + 1
		if size == 2 then
			instruction = tonumber(item)
		end
	end
	if size == 1 then
		goto continue
	end

	cycle = cycle + 1
	if math.fmod(cycle,  40) == 20 then
		result = result + value * cycle
	end
	value = value + instruction
end

print(result)
