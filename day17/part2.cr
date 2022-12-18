class Row
	# Rows are a linked list from top down
	def initialize(nextRow : Row)
		@nextRow = nextRow
		@prevRow = nil
		@y = (nextRow.y + 1).as(UInt64)
		@elements = 0_u8
		@empty = true
	end

	# Bottom row links to itself
	def initialize()
		@y = 0_u64
		@elements = 0_u8
		@empty = true
		@nextRow = self
	end

	# Blocks are stored as bits in a u8
	def setBlock(x : UInt8, block : Bool)
		if block
			@elements |= (1 << x)
		else
			@elements -= @elements & (1 << x)
		end
	end

	def getBlock(x : UInt8)
		(@elements & (1 << x)) > 0
	end

	def isEmpty()
		@elements == 0
	end

	def isFull()
		@elements == 127
	end

	def next()
		@nextRow
	end

	def prev()
		if @prevRow == nil
			@prevRow = Row.new self
		end
		@prevRow
	end

	def y()
		@y
	end

	def setY(val : UInt64)
		@y = val
	end

	def elements()
		@elements
	end	

	def setNext(n : Row)
		@nextRow = n
	end

	def setPrev(n : Row | Nil)
		@prevRow = n
	end
end

def createBlock(model : UInt64)
	blocks : Array(Array(UInt8)) = [] of Array(UInt8)
	case model % 5
	when 0
		# . . @ @ @ @ .
		blocks = [[2_u8,3_u8,4_u8,5_u8]]
	when 1
		# . . . @ . . .
		# . . @ @ @ . .
		# . . . @ . . .
		blocks = [[3_u8], [2_u8,3_u8,4_u8], [3_u8]]
	when 2
		# . . . . @ . .
		# . . . . @ . .
		# . . @ @ @ . .
		blocks = [[2_u8,3_u8,4_u8],[4_u8],[4_u8]]
	when 3
		# . . @ . . . .
		# . . @ . . . .
		# . . @ . . . .
		# . . @ . . . .
		blocks = [[2_u8],[2_u8],[2_u8],[2_u8]]
	when 4
		# . . @ @ . . .
		# . . @ @ . . .
		blocks = [[2_u8,3_u8],[2_u8,3_u8]]
	end
	return blocks
end

text = File.read("input.txt")
currentJet = 0
topRow = Row.new

def getBaseRow(topRow : Row)
	freeRows = 0
	r : Row = topRow
	# Find out how many free rows we already have
	while r.isEmpty()
		freeRows += 1
		# The bottom row links to itself
		if r == r.next()
			break
		end
		r = r.next()
	end

	r = topRow
	# Add more rows if we don't have enough
	while freeRows < 4
		r = r.prev().as(Row)
		freeRows += r.isEmpty() ? 1 : 0
	end
	# Trim rows if we have too many
	while freeRows > 4
		r = r.next()
		freeRows -= 1
	end
	return r
end

currentJet = 0_u64
dropNum = 0_u64
rowstore = topRow
while dropNum < 1000000000000
	# Manually clear some memory
	# (this is super arbitrary numbers, so it's not 100% guaranteed to work)
	if currentJet > 9999998
		currentJet %= text.size - 1
		rowstore.setNext(rowstore)
		rowstore = topRow
	end

	dropIter = 0
	baseRow = getBaseRow(topRow)
	topRow = baseRow
	blocks = createBlock(dropNum)
	while true
		jetRight = text[currentJet % (text.size - 1)] == '>'
		i = 0
		r = baseRow.as(Row)
		isBlocked = false
		while (i < blocks.size) && (!isBlocked)
			if (!jetRight && blocks[i].first() == 0) || (jetRight && blocks[i].last() == 6)
				isBlocked = true
				break
			end
			if dropIter > 3
				j = 0
				while j < blocks[i].size
					b = blocks[i][jetRight ? blocks[i].size - 1 - j : j]
					if r.getBlock(b + (jetRight ? 1 : -1))
						isBlocked = true
						break
					end
					j += 1
				end
			end
			i += 1
			r = r.prev().as(Row)
		end

		if !isBlocked
			i = 0
			while i < blocks.size
				j = 0
				while j < blocks[i].size
					blocks[i][j] += jetRight ? 1 : -1
					j += 1
				end
				i += 1
			end
		end

		currentJet += 1	
		dropIter += 1
		
		isBlocked = baseRow.y == 0
		i = 0
		r = baseRow
		while (i < blocks.size) && (!isBlocked)
			j = 0
			while j < blocks[i].size
				if r.next().getBlock(blocks[i][j])
					isBlocked = true
					break
				end
				j += 1
			end
			i += 1
			r = r.prev().as(Row)
		end
		if !isBlocked
			baseRow = baseRow.next()
		else
			i = 0
			r = baseRow
			while (i < blocks.size)
				j = 0
				while j < blocks[i].size
					r.setBlock(blocks[i][j], true)
					j += 1
				end
				i += 1
				r = r.prev().as(Row)
			end
			break
		end	
	end
	dropNum += 1
end
while topRow.isEmpty()
	topRow = topRow.next().as(Row)
end
puts topRow.y + 1
