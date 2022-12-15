# Prepare
my $value = 0;
my $filename = "input.txt";
# Read file line-by-line
open(handle, '<', $filename) or die $!;
while(<handle>){
	# Split into array of each digit
	my @elements = split('[-,]', $_);
	# 2nd in 1st OR 1st in 2nd
	if(($elements[0]>=$elements[2] and $elements[1]<=$elements[3]) or ($elements[0]<=$elements[2] and $elements[1]>=$elements[3])){
		# Increment matching pairs
		$value+=1;
	}
}
# Output
print($value);
close(handle);
