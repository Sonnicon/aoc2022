package main

import (
	"fmt"
	"bufio"
	"os"
	"regexp"
)

func main() {
	file, _ := os.Open("input.txt")
	defer file.Close()
	scanner := bufio.NewScanner(file)
	
	score := 0
	// Iterate each line in file
	for scanner.Scan() {
		line := scanner.Text()
		length := len(line) >> 1
		// Build a regex of each char in the first half, and use it on the second
		matcher := regexp.MustCompile("[" + line[:length] + "]")
		matches := matcher.FindAllStringSubmatch(line[length:], -1)

		// Flatten the results into a boolean map
		duplicates := make(map[int]bool)
		for _, v := range matches {
			duplicates[int([]rune(v[0])[0])] = true
		}
		// Calculate scores from boolean map
		for num, _ := range duplicates {
			if num >= 97 {
				score += num - 96
			} else {
				score += num - 38
			}
		}
	}
	fmt.Println(score)
}
