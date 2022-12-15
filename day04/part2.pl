# Prepare
my $value = 0;
my $filename = "input.txt";
# Read file line-by-line
open(handle, '<', $filename) or die $!;
while(<handle>){
	# Split into array of each digit
	my @elements = split('[-,]', $_);
	# First elf value 1 between 2nd elf values OR First elf value 2 between 2nd elf values OR 2nd elf values both between first elf
	# I need to atone for this
	if(($elements[0]>=$elements[2] and $elements[0]<=$elements[3]) or ($elements[1]>=$elements[2] and $elements[1]<=$elements[3]) or ($elements[0]<=$elements[2] and $elements[1]>=$elements[3])){
		# Increment matching pairs
		$value+=1;
	}
}
# Output
print($value);
close(handle);
