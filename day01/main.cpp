#include <iostream>
#include <fstream>

int main(int argc, char *argv[]) {
	std::ifstream stream("input.txt");
	// Highest to lowest sums
	uint max[3] = {0,0,0};
	// Current sum
	uint running = 0;
	std::string line;
	while (1) {
		std::getline(stream, line);
		if (line.empty()) {
			// Store result if needed
			char mode = -1;
			
			// Decide where (if even) to insert value
			for (char i = 0; i < 3; i++) {
				if (running > max[i]) {
					mode = i;
					break;
				}
			}

			// Shift array and insert value
			switch (mode) {
				case (1):
					max[2] = max[1];
				case (0):
					max[1] = max[0];
				case (2):
					max[mode] = running;
			}

			// We finished
			if (stream.eof()) {
				break;
			}
			running = 0;
		} else {
			// We are still totalling
			running += std::stoi(line);
		}
	}
	stream.close();
	std::cout << max[0] << std::endl << (max[0] + max[1] + max[2]) << std::endl;
	return 0;
}
