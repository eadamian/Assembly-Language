# MIPS assembly language program by Eric Adamian
# asks user to input 20 integers, prints in a single line

#	$t0	base address of array
#	$t1	array’s upper bound
#	$t2	holding test values and misc

.data
	array:			.space		320
	array_sz:		.word		80
	greeting_msg: 		.asciiz		"Please enter 20 integers\n"
	input_prompt:		.asciiz		"Enter integer: "
	output_prompt:		.asciiz		"Your inputted values on a single line: "
	.align 2

.text
.globl main

main:	# program entry

	# display greeting message
	la $a0, greeting_msg
	li $v0, 4
	syscall 
	
	# take input using a loop
	la $t0, array				# load base address in $t0 (iterator)
	la $t1, array_sz			# load address of array size word to $t1
	lw $t1, 0($t1)				# load array size value to $t1
	addu $t1, $t0, $t1			# calc upper bound address
	
	input_loop:
		slt $t2, $t0, $t1		# $t0 < $t1 ?
		beq $t2, $0, exit_input_loop	# condition to exit loop
		
		# print input prompt
		la $a0, input_prompt
		li $v0, 4
		syscall
		
		# get input
		li $v0, 5
		syscall 
		
		# store int in array
		sw $v0, 0($t0)
		
		#increment iterator
		addiu $t0, $t0, 4
	
	
	j input_loop
	exit_input_loop:
	
	# outputs each inputted int
	la $t0, array
	
	# print output prompt
	la $a0, output_prompt
	li $v0, 4
	syscall
	
	
	output_loop:
		slt $t2, $t0, $t1		# $t0 < $t1 ?
		beq $t2, $0, exit_output_loop	# condition to exit loop
		
		
		# get int from array
		lw $a0, 0($t0)
		li $v0, 1
		syscall
		
		# print on a single line
		li $a0, ' '
		li $v0, 11
		syscall
		
		# increment iterator
		addiu $t0, $t0, 4
	
	j output_loop
	exit_output_loop:

li $v0, 10		# terminate the program
syscall
