package main

import (
	"fmt"
	"bufio"
	"os"
)

func main() {
	file, _ := os.Open("input.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)
	
	score := 0
	// current line mod 3
	counter := 0
	// How many of the group members have a character
	countermap := make(map[rune]int)
	// Iterate each line
	for scanner.Scan() {
		line := scanner.Text()
		// Iterate characters in line
		for _, char := range line {
			if counter == 0 {
				// Create entries for new characters on the first in group
				countermap[char] = 1
			} else if countermap[char] == counter {
				// Increment entries if everyone in group so far has the char
				countermap[char]++
			}
			
		}
		// Increment which group member we will process
		counter++

		// Deal with group as a whole
		if counter == 3 {
			// Iterate each entry in the character count map
			for char, val := range countermap {
				// If every elf has the char
				if val == 3 {
					// Deal with scores
					if int(char) >= 97 {
						score += int(char) - 96
					} else {
						score += int(char) - 38
					}
				}
			}
			// Reset for next group
			counter = 0;
			countermap = make(map[rune]int)
		}
	}
	fmt.Println(score)
}
