.data
	A: .word 1,2,3,4,5,6,7,8
	B: .word 9,10,11,12,13,14,15,16
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
	add 	$a0, $t0, $zero
	add	$a1, $t1, $zero
	jal 	multiply
	add	$s0, $s0, $v0
	
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

multiply:
	# This procedure implements the multiplication algorithm presented in Module 5A
	# a0 is multiplicand and $a1 is multiplier
	
	# Make both operands positive and remember signs
	andi 	$t6, $a0, 0x80000000 	# Check sign bit of multiplier. t6=1 if its negative
	andi 	$t7, $s1, 0x80000000	# Check sign bit of multiplicand. t7=1 if its negative
	
	# If multiplier is negative, mplier = 0 - mplier
	beq 	$t6, $zero, mplier_pos
	sub	$a0, $zero, $a0

mplier_pos:
	# If multiplicand is negative, mcand = 0 - mcand
	beq	$t7, $zero, mcand_pos
	sub	$a1, $zero, $a1
	
mcand_pos:
	# Initialize product register
	add	$t0, $zero, $zero	# left side starts as 0
	add	$t1, $a1, $zero		# right side starts as multiplier
	
	# Iterate 32 times
	li 	$t2, 0
	li 	$t3, 32

loop_multiply:
	# If LSB bit of product is 1, add multiplicand to left side of product
	andi	$t4, $t1, 1			# Check if LSB is 1 or 0
	beq	$t4, $zero, shift_multiply 	# Skip next step if LSB is 0
	add	$t0, $t0, $a0			# Add multiplicand to left side of product

shift_multiply:
	# Shift product register right 1 bit
	srl	$t1, $t1, 1	# Shift right side
	andi 	$t4, $t0, 1	# Get rightmost bit of left side
	sll	$t4, $t4, 31	# Shift so that that bit becomes MSB
	add	$t1, $t1, $t4	# Add LSB of left side to MSB of right side (which is zero)
	srl	$t0, $t0, 1	# Shift right side
	
	# Loop logic
	addi	$t2, $t2, 1
	blt	$t2, $t3, loop_multiply
	# End loop
	
	# If initial operand signs differed, set result negative (prod = 0 - prod)
	xor	$t6, $t6, $t7
	beq	$t6, $zero, prod_pos
	sub	$t1, $zero, $t1
	
prod_pos:
	# Return right side of product register (lo 32 bits of product)
	add	$v0, $t1, $zero
	jr	$ra
