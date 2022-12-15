<?php
$file = fopen("input.txt", "r");
// Lists of x and y of nodes
$nodes_x = array_fill(0, 10, 0);
$nodes_y = array_fill(0, 10, 0);
$tail_visited = array("0,0" => true);
while(!feof($file)) {
	// Parse input
	$input = explode(" ", fgets($file));
	if (count($input) < 2) {
		break;
	}
	// Loop for repeated move
	for ($i = 0; $i < $input[1]; $i++) {
		// Move head node
		switch ($input[0]) {
		case "L":
			$nodes_x[0]--;
			break;
		case "R":
			$nodes_x[0]++;
			break;
		case "U":
			$nodes_y[0]++;
			break;
		case "D":
			$nodes_y[0]--;
			break;
		}
		// Loop all child nodes
		for ($j = 1; $j < 10; $j++) {
			$pull_shift = false;
			// Gap between nodes -> move into gap
			if ($nodes_x[$j-1]-1 > $nodes_x[$j]) {
				$nodes_x[$j]++;
				$pull_shift = true;
			} else if ($nodes_x[$j-1]+1 < $nodes_x[$j]) {
				$nodes_x[$j]--;
				$pull_shift = true;
			}
			// Shift diagonal if perpendicular difference when moved into gap
			if ($pull_shift) {
				if ($nodes_y[$j-1] > $nodes_y[$j]) {
					$nodes_y[$j]++;
				} else if ($nodes_y[$j-1] < $nodes_y[$j]) {
					$nodes_y[$j]--;
				}
			}

			// Same again for the other axis
			$pull_shift = false;
			if ($nodes_y[$j-1]-1 > $nodes_y[$j]) {
				$nodes_y[$j]++;
				$pull_shift = true;
			} else if ($nodes_y[$j-1]+1 < $nodes_y[$j]) {
				$nodes_y[$j]--;
				$pull_shift = true;
			}

			if ($pull_shift) {
				if ($nodes_x[$j-1] > $nodes_x[$j]) {
					$nodes_x[$j]++;
				} else if ($nodes_x[$j-1] < $nodes_x[$j]) {
					$nodes_x[$j]--;
				}
		
			}
		}
		// Add tail node location to visited map
		$tail_visited[$nodes_x[9] . ',' . $nodes_y[9]] = true;
	}
}

echo count($tail_visited);
fclose($file);
echo "\n";
?>
