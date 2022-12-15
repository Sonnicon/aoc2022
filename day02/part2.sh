score=0
while read line; do
	IFS=\  read input_their input_our <<< "$(echo -n $line | tr -d ' ' | od -An -tuC)"
	# This line is the only difference from part 1
	# It does some magic ASCII offset formulae to map the opponent input and desired outcome
	# to figure out what we should play.
	((input_our=(input_their+input_our-1)%3+88))
	((score+=input_our - 87))
	if [ $((input_their+23)) == $input_our ]; then
		((score+=3))
	elif [ $((input_our%3)) == $((input_their%3)) ]; then
		((score+=6))
	fi
done < "input.txt"
echo "$score"
