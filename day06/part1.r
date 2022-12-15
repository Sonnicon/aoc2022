library(readr)
unlist(gregexpr("(\\w)(?!\\1\\w{2}|\\w\\1\\w|\\w{2}\\1)(\\w)(?!\\2\\w|\\w\\2)(\\w)(?!\\3)", read_file("input.txt"), perl=TRUE))[1] + 3 
