<?php
$file = fopen("input.txt", "r");
// Coordinates of head and tail
$head_x = 0;
$head_y = 0;
$tail_x = 0;
$tail_y = 0;
$tail_visited = array("0,0" => true);
while(!feof($file)) {
	// Parse input
	$input = explode(" ", fgets($file));
	if (count($input) < 2) {
		break;
	}
	// Repeated move
	for ($i = 0; $i < $input[1]; $i++) {
		switch ($input[0]) {
		case "L":
			// Move both left, align tail
			if ($tail_x > $head_x) {
				$tail_x--;
				$tail_y = $head_y;
			}
			$head_x--;
			break;
		case "R":
			// Move both right, align tail
			if ($tail_x < $head_x) {
				$tail_x++;
				$tail_y = $head_y;
			}
			$head_x++;
			break;
		case "U":
			// Move both up, align tail
			if ($tail_y < $head_y) {
				$tail_y++;
				$tail_x = $head_x;
			}
			$head_y++;
			break;
		case "D":
			// Move both down, align tail
			if ($tail_y > $head_y) {
					$tail_y--;
				$tail_x = $head_x;
			}
			$head_y--;
			break;
		}
		// Store location of tail
		$tail_visited[$tail_x . ',' . $tail_y] = true;
	}
}

echo count($tail_visited);
fclose($file);
echo "\n";
?>
