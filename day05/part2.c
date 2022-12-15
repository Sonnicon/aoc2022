#include <stdio.h>
#include <stdlib.h>

// How many stacks there are
#define NUM_STACKS 9

// Linked list for the blocks
typedef struct Block Block;
struct Block {
	Block* next = 0;
	char value;
};


int main(int argc, char** argv) {
	FILE *file = fopen("input.txt", "r");	
	// Array of pointers to starts of block linked list
	Block** stacks = (Block**)calloc(NUM_STACKS, sizeof(void*));

	// Storage for move commands (0-indexed)
	char moveCount = 0, moveFrom, moveTo;
	// Skip over this many characters safely (reset at newline)
	char skip = 0;
	// What we are currently processing
	//   0 = general
	//   1 = block contents
	//   2 = instructions 1
	//   3 = instructions 2
	//   4 = instructions 3
	char stage = 0;
	// What we just read in
	char read;
	// Column of the character we are reading
	char column = 0;
	// Read each character while incrementing column
	while (++column && (read = getc(file)) != EOF) {
		// On newlines, reset skip and column to 0, and continue. Also, skip and decrement if > 0
		if ((read == '\n' && !(skip = 0) && !(column = 0)) || (skip && skip--)) {
			continue;
		}
		switch (stage) {
			// Decide what the line contains
			case 0: {
				switch (read) {
					case '[': {
						stage = 1;
						continue;
					}
					case 'm': {
						stage = 2;
						// Skip to first number
						skip = 4;
						continue;
					}
				}
			   break;
			}
			case 1: {
				// Create new linked list node
				Block* block = (Block*)malloc(sizeof(Block));
				block->next = 0;
				block->value = read;
				// Decide which stack we're adding it to
				char index = (column-2)>>2;
				if (stacks[index]) {
					// Find end of stack and add to it
					Block* scan = stacks[index];
					while (scan->next) {
						scan = scan->next;
					}
					scan->next = block;	
				} else {
					// Begin a new stack
					stacks[index] = block;
				}
				// Skip to where next block could be
				// skip is zeroed on newline, so this is safe
				skip = 2;
				stage = 0;
				break;
			}
			case 2: {
				if (read == ' ') {
					// If we read the whole number already, skip to second number
					stage = 3;
					skip = 5;
					continue;
				}
				// Parse base10 number from characters
				moveCount = moveCount * 10 + read - 48;
				break;
			}
			case 3: {
				// Read and skip to third number
				stage = 4;
				skip = 4;
				// The -1 makes it not 1-indexed
				moveFrom = read - 48 - 1;
				break;
			}
			case 4: {
				// Read first number and reset state
				stage = 0;
				moveTo = read - 48 - 1;
				// Front and back of nodes we are moving 
				Block* targetStart = stacks[moveFrom];
				Block* targetEnd = targetStart;
				// Find end node
				for (moveCount--; moveCount > 0; moveCount--) {
					if (targetEnd->next) {
						targetEnd = targetEnd->next;
					} else {
						moveCount = 0;
						break;
					}
				}
				// Move entire segment to start of target
				stacks[moveFrom] = targetEnd->next;
				targetEnd->next = stacks[moveTo];
				stacks[moveTo] = targetStart;
				break;
			}
		}
	}
	// Output
	for (char i = 0; i < NUM_STACKS; i++) {
		putchar(stacks[i]->value);
	}
	putchar('\n');
	
	return 0;
}
