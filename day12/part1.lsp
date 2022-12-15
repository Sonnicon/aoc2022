; Essentially Dijkstra's algorithm but without weighting on edges, so we can process in order and get the best solutions first.

(defconstant width 172)
(defconstant height 41)

; A list of every character in the map
(defvar inputs (with-open-file (file "input.txt")
	(loop for c = (read-char file nil) 
		while c
		if (char/= c #\Newline)
		collect c
	)
))

; Position of the end tile
(defvar endpos (list
	(mod (position #\E inputs) width)
	(floor (position #\E inputs) width)
))

; Queue of tiles to consider
(defvar consider (list 
	(list
		(mod (position #\S inputs) width)
		(floor (position #\S inputs) width)
	)
))
; List of locations we have already visited and won't consider again
(defvar visited (copy-list consider))

; Turns (x, y) into a single index
(defun getindex (pos)
  	(+
		(* (nth 1 pos) width)
		(nth 0 pos)
	)
)

; Distance to each location
(defvar distances (make-array (* width height)))
; Start with 0 at start location
(setf (aref distances (getindex (nth 0 consider))) 0)

; Get the distance to a position
(defun getdistance (pos)
  	;(write (getindex pos))
	(aref distances (getindex pos))	
)

; Add a new tile to the queue
(defun enqueue (pos distance)
  	;(write 'enqueueing)
  	; consider could be empty
	(setq consider (append consider (list pos)))
	; but visited cannot
	(setq visited (append visited (list pos)))
	(setf (aref distances (getindex pos)) distance)
	;(write 'enqueued)
)

; Clamps a number between two others
(defun clamp (value minimum maximum)
	(min maximum (max minimum value))
)

; Checks if there is a suitable difference between two characters
(defun canmove (from to)
  	(let (
			(fromi (char-code (nth (getindex from) inputs))) 
  			(toi (char-code (nth (getindex to) inputs)))
  		)
  	  	; Map S and E to a and z	
  	  	(if (= fromi 83) (setq fromi 97))
  	  	(if (= toi 69) (setq toi 122))
		(>= fromi (- toi 1))
	)
)

; Take an element from the queue and consider it
(loop for pos = (pop consider)
	while pos
	do
		; End condition
		(if (EQUAL pos endpos) (write (getdistance pos)))
		(loop for i from 0 to 3
		do
			(
			; Don't go out of bounds
			if (not (or 
			 (and (= i 0) (= (nth 1 pos) 0))
			 (and (= i 1) (= (nth 0 pos) 0))
			 (and (= i 2) (= (nth 1 pos) (- height 1)))
			 (and (= i 3) (= (nth 0 pos) (- width 1)))))
			(
			 	; Target position
				let 
				((target (list
					(+ (nth 0 pos) (if (oddp i) (- i 2) 0))
					(+ (nth 1 pos) (if (evenp i) (- i 1) 0))
				)))
				; Haven't processet yet, and can move there
				(if (and (not (find target visited :test #'EQUAL))
						 (canmove pos target))
					(enqueue target (+ (getdistance pos) 1))
					
				)
			)
		)
	)		
)
