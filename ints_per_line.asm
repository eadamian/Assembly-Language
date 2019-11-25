# MIPS assembly language program by Eric Adamian
# asks user to input 20 integers, prints reverse of input on single line
# asks user to input number of ints per line, prints based on reverse array

#	$t0	base address of array
#	$t1	array’s upper bound
#	$t2	holding test values and misc
#	$t3	holds number of ints per line
# 	$t4 	counter initally $t3

.data
	array:			.space		320
	array_sz:		.word		80
	greeting_msg: 		.asciiz		"Please enter 20 integers\n"
	input_prompt:		.asciiz		"Enter integer: "
	ints_per_line_prompt:	.asciiz		"\nEnter number of ints per line: "
	.align 2

.text
.globl main


main:	# program entry

	# display greeting msg
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
	
	
	# using $t1 as iterator
	output_loop:
		slt $t2, $t0, $t1		# $t0 < $t1 ?
		beq $t2, $0, exit_output_loop	# condition to exit loop
		
		# get int from array
		lw $a0, -4($t1)
		li $v0, 1
		syscall
		
		# print newline char
		li $a0, ' '
		li $v0, 11
		syscall
		
		#decrement iterator
		addiu $t1, $t1, -4
	
	
	j output_loop
	exit_output_loop:


	# prompt for number of integers per line
	la $a0, ints_per_line_prompt
	li $v0, 4
	syscall
	
	# get number of ints per line
	li $v0, 5
	syscall
	
	# copying value between registers
	move $t3, $v0
	move $t4, $t3
	
	#reset $t1 as upperbound
	la $t1, array_sz			# load address of array size word to $t1
	lw $t1, 0($t1)				# load array size value to $t1
	addu $t1, $t0, $t1			# calc upper bound address
	
	# using $t1 as iterator
	int_output_loop:
		slt $t2, $t0, $t1		# $t0 < $t1 ?
		beq $t2, $0, exit_int_output_loop	# condition to exit loop
		
		
		# get int from array
		lw $a0, -4($t1)
		
		# print int to console
		li $v0, 1
		syscall
		
		# decrement counter
		addi $t4, $t4, -1
		
		# if counter == 0 print newline, else print space
		if:
		beq $t4, $0, print_newline
		
		# else
		li $a0, ' '
		j exit_if
		
		# if 
		print_newline:			# print newline char
		li $a0, '\n'
		move $t4, $t3			# reset counter
		
		exit_if:
		
		# prints character
		li $v0, 11
		syscall
		
		#decrement iterator
		addiu $t1, $t1, -4
	
	
	j int_output_loop
	exit_int_output_loop:

li $v0, 10		# terminate the program
syscall
