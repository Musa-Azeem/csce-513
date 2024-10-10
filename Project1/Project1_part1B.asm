.data
	A: .word -831,2018,-4072,865,1143,-15826,-7131,11646,10458,-15863,-1907,-14516,7171,5779,-2906,-12054,-11312,13758,-12172,-10519,2893,-1752,-9749,9876,-1059,-13787,-5421,8664,-14793,-4676,-3680,3169,-3120,12333,-1190,10077,-11418,3420,11393,8449,6043,-1118,8718,-13454,12426,-13282,8725,-2445,13058,10425
	B: .word 7414,11397,3479,1778,-6962,4967,-14155,1170,6169,-6978,-8959,5218,6964,3602,-15018,15598,-249,-5394,-9258,-13643,10677,12065,874,1608,-16,-11412,-4393,9320,-7103,-11819,-10642,-8424,14795,5937,6847,-7207,6942,-4870,4586,-14970,10202,-4550,6971,13898,5233,2852,-10646,-15237,3134,-7148
	length: .word 50
	
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
