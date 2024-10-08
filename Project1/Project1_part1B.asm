.data
	A: .word 1,2,3,4,5,6,-7,8
	B: .word -9,-10,-11,12,13,14,15,16
	length: .word 8
	
.text
	# Load base address of the two vectors and their length
	la	$s1, A
	la 	$s2, B
	lw 	$s3, length
	
	# Store running dot product result in s0 - starts with value 0
	li 	$s0, 0
	
	# Loop "length" times, for each element of the vectors
	li	$s4, 0

dot_loop:	
	# Load next element of each vector
	lw	$t0, ($s1)
	lw	$t1, ($s2)
	
	# Multiply the elements and add the result to running dot product
	mul	$t0, $t0, $t1
	add	$s0, $s0, $t0
	
	# Add 4 to each base address to move it to next element
	addi	$s1, $s1, 4
	addi	$s2, $s2, 4
	# Branch logic
	addi	$s4, $s4, 1
	blt	$s4, $s3, dot_loop
	# End loop
	
	# Exit
	li 	$v0, 10
	syscall