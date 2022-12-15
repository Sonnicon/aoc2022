class Monkey {
	List<Integer> items
	String operation
	int divtest
	int destinationTrue
	int destinationFalse

	int inspections = 0
	static List<Monkey> monkeys = []

	Monkey(String rawMonkey) {
		def trimmedMonkey = rawMonkey.split("\\n").collect {it.trim()}
		items = trimmedMonkey[1].findAll("[0-9]+").collect({it.toInteger()})
		operation = trimmedMonkey[2].substring(trimmedMonkey[2].indexOf("= ") + 2).replaceAll("old", "x")
		divtest = trimmedMonkey[3].find("[0-9]+").toInteger()
		destinationTrue = trimmedMonkey[4].find("[0-9]+").toInteger()
		destinationFalse = trimmedMonkey[5].find("[0-9]+").toInteger()
		monkeys.add(this)
	}

	def process() {
		int item = items.pop()
		item = Eval.x(item, operation) as int
		item /= 3
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
for (def i = 0; i < 20; i++) {
	Monkey.round()
}
def inspections = Monkey.monkeys.collect {it.inspections}.sort()
print(inspections.removeLast() * inspections.last())
