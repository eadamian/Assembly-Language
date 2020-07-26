# MIPS assembly language program by Eric Adamian
# asks user to input a value of n, outputs n'th fibonacci value and sequence

# 	$t0 value for a
# 	$t1 value for b
# 	$t2 temp value/condition for output
# 	$t3 array
# 	$t4 array size
# 	$t5 int_input prompt
# 	$t6 fibo_output prompt
# 	$s0 counter
# 	$s1 user input

# storage for fibonacci sequence (4n -1 for array size from 0 index)
.data
	array:		.space		192	
	array_sz:	.word		47
	int_input:	.asciiz		"Please enter a value of n: "
	nth_fibo:	.asciiz		"Your n'th value of sequence: "
	fibo_output:	.asciiz		"Your fibonacci sequence: "
	error_message:	.asciiz		"Error: Number is not within range!\n\n"
	.align 2

.text
.globl main

main:	# program entry

# loading address of our strings into registers
la $t5, int_input	
la $t6, fibo_output

# a = 0; b = 1
li $t0, 0
li $t1, 1

# s0 will be used as counter variable for the for loop
li $s0, 0

# printing input message
la $a0, int_input
li $v0, 4
syscall

# retrieving user input
li $v0, 5
syscall

# storing user input
addu $s1, $v0, $0

# loading address into array/array sizes
la $t3, array				
la $t4, array_sz			

# loading array size; adding our array to the loaded array size
lw $t4, 0($t4)			
addu $t4, $t3, $t4		

#************************************************************************************************************

# checks for error message when input is less than 0
slt $t5, $s1, $0
bne $t5, $0, print_error

# checks for error message when input is 47 or greater (out of range, cannot store)
slti $t5, $s1, 47
beq $t5, $0, print_error

# increment int for user input by 1 byte
addi $s1, $s1, 1

# jump loop
j input_loop
	
	
	# error message under main loop
	print_error:

		la $a0, error_message
		li $v0, 4
		syscall

		j main


	# fibonacci translated into assembly
	input_loop:
		
		# checks if counter is equal to user input, exit the loop
		beq $s0, $s1, exit_input_loop
		
		# store int into array and increment
		sw $t0, 0($t3)
		addiu $t3, $t3, 4
		
		# store b into temp
		addiu $t2, $t1, 0
		
		# adding a to b, storing into b
		addu $t1, $t0, $t1
		
		# setting a to temp value
		addiu $t0, $t2, 0
		
		# incrementing counter variable by 1
		addiu $s0, $s0, 1 
				
		j input_loop
	exit_input_loop:
	
# ensures counter increment
addu $s0, $0, $0
	
#*************************************************************************************************************
# nth fibonacci sequence value
	
# prints our string
la $a0, nth_fibo
li $v0, 4
syscall
	
# point to array, will look 4 bytes backwards from end of array (needs unsigned value for nth term)
lw $a0, -4($t3)
li $v0, 36
syscall
	
# hexadecmial used for spacing between nth size and fibonacci array strings
li $a0, 0xa
li $v0, 11
syscall

# printing output message
la $a0, fibo_output
li $v0, 4
syscall
		
# loads address of array for output	
la $t3, array
#*************************************************************************************************************	

	# outputting our fibonacci sequence
	output_loop:
	
		# condition
		slt $t2, $s0, $s1
		beq $t2, $0, exit_output_loop
		
		# get int from array
		lw $a0, 0($t3)
		li $v0, 36
		syscall
		
		# prints array onto a single line
		li $a0, ' '
		li $v0, 11
		syscall
		
		# increment iterator
		addiu $t3, $t3, 4
		
		# increment counter
		addiu $s0, $s0, 1
	
		j output_loop
	exit_output_loop:
	
	
li $v0, 10		# terminate the program
syscall
