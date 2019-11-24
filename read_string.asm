# MIPS assembly language program by Eric Adamian
# reads user inputted string through a buffer

.data
	.eqv			string_buffer_sz		200
	string_buffer:		.space				string_buffer_sz
	input_prompt:		.asciiz				"Enter a string: "
	output_prompt:		.asciiz				"The string you entered is: "
	.align 2

.text
.globl main

main:	# program entry

	# prints our input prompt
	la $a0, input_prompt
	li $v0, 4
	syscall

	# reads string based on buffer size
	la $a0, string_buffer
	li $a1, string_buffer_sz
	li $v0, 8
	syscall
	
	# prints our output prompt
	la $a0, output_prompt
	li $v0, 4
	syscall
	
	# prints string stored in buffer
	la $a0, string_buffer
	li $v0, 4
	syscall
	
li $v0, 10		# terminate the program
syscall	