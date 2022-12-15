library(readr)
# New and improved regex that doesn't grow polynomially! (excluding length of numbers)
unlist(gregexpr("(\\w)(?!\\w{0,12}\\1)(\\w)(?!\\w{0,11}\\2)(\\w)(?!\\w{0,10}\\3)(\\w)(?!\\w{0,9}\\4)(\\w)(?!\\w{0,8}\\5)(\\w)(?!\\w{0,7}\\6)(\\w)(?!\\w{0,6}\\7)(\\w)(?!\\w{0,5}\\8)(\\w)(?!\\w{0,4}\\9)(\\w)(?!\\w{0,3}\\10)(\\w)(?!\\w{0,2}\\11)(\\w)(?!\\w?\\12)(\\w)(?!\\13)", read_file("input.txt"), perl=TRUE))[1] + 13
