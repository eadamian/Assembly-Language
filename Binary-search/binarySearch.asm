# MIPS assembly language program by Eric Adamian
# takes in number of inputs, stores each value and sorts in an ascending array
# performs binary search on stored input values

# $t0- loop counter, search subroutines
# $t1- print counter for index, holds previous element to compare with current value
# $t2- value to be printed
# $s0- array length based on user input
# $s1- reserved for stack when calling stack subroutine


.data 
	prompt1:     	.asciiz		"\nARRAY SORT: \nInputted values will be stored in an array of ascending order.\n\nHow many integers are you inputting? "
	sort_input: 	.asciiz		"Please enter an int (sort): "
	sort_array:	.asciiz		"Your array in ascending order: "
	prompt2:	.asciiz		"\n\nBINARY SEARCH: \nSearching for inputted values; end using 'stop' button (0 = integer not found, 1 = integer found)."
	search_input:	.asciiz		"\n\nPlease enter an int (search): "
	result:		.asciiz		"Search result: "

# offset of 40 words in an array
.align 2
	array:		.space		160

.text
.globl main

#program entry
main:

    # print sorting prompt	
    sort_prompt:
	la $a0, prompt1
	li $v0, 4
	syscall

    # read user input
    	li $v0, 5
    	syscall
    	
    # move user input, store number of ints
    	move $s0, $v0
    	
    # load starting address for array (used for sorting)
    	la $a1, array
    	li $s1, 0
    		
    	user_input:
    		# condition for end sort prompt
    		beq $s1, $s0, end_sort_prompt
    			
    		# sort input prompt
    		la $a0, sort_input
    		li $v0, 4
    		syscall
    		
    		# reads user input
    		li $v0, 5
    		syscall
    		
    		# takes in user input as an argument
    		move $a0, $v0
    		
    		# jump to stack subroutine
    		jal stack
    		
    		# increment last address by a word
    		addi $a1, $a1, 4
    		
    		# increment loop counter
    		addi $s1, $s1, 1
    		
    		j user_input
    		
    end_sort_prompt:


    print:
		# moving array length to $t0
        	move $t0, $s0
        	
        	# load array size into $t1
        	la $t1, array
        	
        	# prompt for sorted array
        	la $a0, sort_array
    		li $v0, 4
    		syscall
        	
        	printloop:
        		# print number of inputted ints
        		beq $t0, 0, end_print
        		lw $t2, 0($t1)
        
        		# printing out each int
        		move $a0, $t2
        		li $v0, 1
        		syscall

        		# whitespace between int
        		li $a0, 32
        		li $v0, 11
        		syscall
			
			# decrement counter
        		addi $t0, $t0, -1
        		
        		# increment array pointer
        		addi $t1, $t1, 4
        		
        	j printloop
        	
    	end_print:
    	
    	

    search_prompt:
    
      	# print searching prompt
        la $a0, prompt2
        li $v0, 4
        syscall
        
        
        search_loop:
        
       	 	# starting address for array
        	la $a1, array
        	
        	# $a2 as array length
            	move $a2, $s0
            	
            	# shifting by 2^2 for address
            	sll $a2, $a2, 2
            	
            	# $a2 stores array's end address
            	add $a2, $a2, $a1 
            
           	# search input prompt
            	la $a0, search_input
            	li $v0, 4
            	syscall
              
		# taking in user input
            	li $v0, 5 
            	syscall
            
            	# user input moved to find our search value
            	move $a0, $v0
            
		# binary search on our input ($a0 = target, $a1 = start, $a2 = end)
            	jal binary_search
            	
            	# user input stored in array
            	move $t0, $v0
            	
            	# prompt for result
            	la $a0, result
            	li $v0, 4
            	syscall

            	# printing integer
            	move $a0, $t0
            	li $v0, 1
            	syscall
            	
            	# indefinite binary search prompt
            	j search_loop
            
            end_search_prompt:
            

	stack:
    		# stack values, allocate stack space
    		addiu $sp, $sp, -12
    		sw $ra, 8($sp)
    		sw $s1, 4($sp)
    		sw $a1, 0($sp)
	
    		# starting array address
    		la $t0, array
    
    		# store new value in last array index
   		sw $a0, 0($a1)
    
    
    		stackloop:
    			# decrement for last array index
    			addi $a1, $a1, -4
    			blt $a1, $t0, end_stackloop
    		
    			# load element prior to $a0 into $t1
    			lw $t1, 0($a1)
                 
                	# if: $a0 > prior element, branch
                	# else: swap $a0 and previous value                         
    			bge $a0, $t1, end_stackloop
    		
    			# store values before next index
    			sw $a0, 0($a1)
    			sw $t1, 4($a1)
    
    			j stackloop
    		end_stackloop:

    		# unstack values, deallocate stack space
    		lw $ra, 8($sp)
    		lw $s1, 4($sp)
    		lw $a1, 0($sp)
    		addiu $sp, $sp, 12

    		# jump to return address
    		jr $ra
    	
	end_stack:



        # binary search pseudocode implementation
	binary_search:
	
    		# save $ra to stack
    		addiu $sp, $sp, -4 
    		sw $ra, 0($sp) 
	
		# check base case and value found/not found
    		bge $a1, $a2, return_zero
	
		# end - start
    		subu $t0, $a2, $a1
    	
    		# (end - start) / 2
    		sra $t0, $t0, 3
    	
    		# shift left logical for offset
    		sll $t0, $t0, 2
    	
    		# mid = start + (end - start)/2
    		add $t0, $t0, $a1
    	
    		# load $t1 register as array at $t0
    		lw $t1, 0($t0)
    	
    		# return one if value is found
    		beq $t1, $a0, return_one
		
        	# target value < mid
    		blt $a0, $t1, left	
        	
        	# else target value > mid
        	# start = (mid+1), recursive call, branch to end			
        	right:
        		addiu $a1, $t0, 4
        		jal binary_search
        		b end
        
        	# end = mid, recursive call, branch to end
        	left:
        		addiu $a2, $t0, 0
        		jal binary_search
        		b end
        	
    		# return a value of one
    		return_one:
        		li $v0, 1
        		b end
    	
    		# return a value of zero
    		return_zero:
        		li $v0, 0

		# restore return address, deallocate stack space 
    		end:
    			lw $ra, 0($sp) 
    			addiu $sp, $sp, 4
    			jr $ra 

	end_binarysearch:

# terminate the program
exit:
    li $v0, 10
    syscall
