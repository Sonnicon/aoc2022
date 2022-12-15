class Monkey {
	List<Long> items
	int divtest
	int destinationTrue
	int destinationFalse

	int inspections = 0
	static List<Monkey> monkeys = []
	int id
	static int nextid = 0

	Monkey(String rawMonkey) {
		def trimmedMonkey = rawMonkey.split("\\n").collect {it.trim()}
		items = trimmedMonkey[1].findAll("[0-9]+").collect({it.toInteger()})
		divtest = trimmedMonkey[3].find("[0-9]+").toInteger()
		destinationTrue = trimmedMonkey[4].find("[0-9]+").toInteger()
		destinationFalse = trimmedMonkey[5].find("[0-9]+").toInteger()
		monkeys.add(this)
		id = nextid++
	}

	def process() {
		long item = items.pop()
		// Hardcode the operations is faster
		switch(id){
			case 0:
				item *= 3
				break
			case 1:
				item += 3
				break
			case 2:
				item += 5
				break
			case 3:
				item *= 19
				break
			case 4:
				item += 1
				break
			case 5:
				item += 2
				break
			case 6:
				item *= item
				break
			case 7:
				item += 8
				break
		}
		// Stops values from overflowing
		// (is the product of the divisors (they are all prime))
		// (this works because the only result of this value goes through a modulus)
		item %= 9699690
		monkeys[item % divtest == 0 ? destinationTrue : destinationFalse].items.add(item)
		inspections++
	}

	def turn() {
		while (items) {
			process()
		}
	}

	static round() {
		monkeys.each {it.turn()}
	}
}

def monkeyStrings = new File("input.txt").text.split("\\n\\n")
monkeyStrings.each {
	new Monkey(it)
}
for (def i = 0; i < 10000; i++) {
	Monkey.round()
}
def inspections = Monkey.monkeys.collect {it.inspections}.sort()
// this is what I deserve for dynamic types
println(inspections.removeLast() as long * inspections.last() as long)
