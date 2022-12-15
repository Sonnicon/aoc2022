score=0
# Iterate each line
while read line; do
	# Turn each of the two characters into ASCII codes and store in input_their and input_our
	IFS=\  read input_their input_our <<< "$(echo -n $line | tr -d ' ' | od -An -tuC)"
	# Points for our move
	((score+=input_our - 87))
	# Magic ASCII offsets to determine victor, and give points
	if [ $((input_their+23)) == $input_our ]; then
		((score+=3))
	elif [ $((input_our%3)) == $((input_their%3)) ]; then
		((score+=6))
	fi
done < "input.txt"
echo "$score"
