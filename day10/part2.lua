-- basically a big pile of hacks

-- draw a # or .
function display(cycle, value)
	local pos = math.fmod(cycle, 40)
	if pos == 0 then
		io.write("\n")
	end
	if pos >= value - 1 and pos <= value + 1 then
		io.write("#")
	else
		io.write(".")
	end
end

-- prepare variables and file
local file = io.open("input.txt", "r")
local value = 1 
local cycle = 0
local instruction = 0

-- display 0th character
display(cycle, value)
-- processing loop
while true do
	::continue::
	cycle = cycle + 1
	display(cycle, value)
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

	value = value + instruction

	cycle = cycle + 1
	display(cycle, value)
end
