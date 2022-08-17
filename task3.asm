	.data
smash: 		.asciiz "Hulk SMASH! >:("
sad: 		.asciiz "Hulk sad :("
end_prompt1: 	.asciiz "Hulk smashed "
end_prompt2: 	.asciiz " people"
newline:    	.asciiz "\n"
	
.text

main:
	#Set $fp and make space for locals
	addi $fp, $sp, 0
	addi $sp, $sp, -8

	# create the array [1,2,3,4,5]
	addi $a0, $0, 16               	    # 5 elements mean 4 * (3 + 1) = 16 bytes
	addi $v0, $0, 9                     # syscall for allocating space
	syscall
	sw $v0, -8($fp)                     # store the starting address of the array
	
	#store size of array as first element
	addi $t0, $0, 3
	sw $t0, ($v0)
	
	#Store elements into array
	addi $t0, $0, 10
	sw $t0, 4($v0) #my_list[0] = 10
	
	addi $t0, $0, 14
	sw $t0, 8($v0) #my_list[1] = 14
	
	addi $t0, $0, 16
	sw $t0, 12($v0) #my_list[2] = 16
	
	#hulk_power = 15
	addi $t0, $0, 15
	sw $t0, -4($fp)
	
	addi $sp, $sp, -8
	
	lw $t0, -8($fp)
	sw $t0, 0($sp) #arg1 = my_list
	
	lw $t0, -4($fp)
	sw $t0, 4($sp) #arg2 = hulk_power

	jal smash_or_sad	
	
smash_or_sad:
	addi $sp, $sp, -8 #Make space
	sw $ra, 4($sp) #Save $ra
	sw $fp, 0($sp) #Save $fp
	
	#copy $sp to $fp
	addi $fp, $sp, 0
	
	#allocate local variables
	addi $sp, $sp, -8
	
	sw $0, -4($fp) #smash count = 0
	sw $0, -8($fp) #i = 0
	jal loop
	
loop:
	lw $t0, -8($fp) #$t0 = i
	lw $t1, 8($fp) #$t1 = my_list
	lw $t2, ($t1)
	slt $t0, $t0, $t2 #check if i < len(my_list)
	beq $t0, $0, end
	
	# print the_array[i]
        lw $t0, 8($fp)
        lw $t1, -8($fp)
        sll $t1, $t1, 2
        add $t0, $t0, $t1
        lw $t2, 4($t0) #$t2 = my_array[i]
        lw $t3, 12($fp) #$t3 = hulk_power
        
        slt $t0, $t2, $t3
        beq $t0, $0, else
        
        #Print hulk smash
        la $a0, smash
	addi $v0, $0, 4
	syscall
	
	#Print newline
	la $a0, newline
	addi $v0, $0, 4
	syscall
	
	#Increment smash_count
	lw $t0, -4($fp)
	addi $t0, $t0, 1
	sw $t0, -4($fp)

        #increment i
        lw $t0, -8($fp)
        addi $t0, $t0, 1
        sw $t0, -8($fp)
	
        j loop
        
else:
	#Print hulk sad
        la $a0, sad
	addi $v0, $0, 4
	syscall
	
	#Print newline
	la $a0, newline
	addi $v0, $0, 4
	syscall
	
        # increment i
        lw $t0, -8($fp)
        addi $t0, $t0, 1
        sw $t0, -8($fp)
	
        j loop
	
end:
	#Print out smash count
	la $a0, end_prompt1
	addi $v0, $0, 4
	syscall
	
	lw $a0, -4($fp)
	addi $v0, $0, 1
	syscall
	
	la $a0, end_prompt2
	addi $v0, $0, 4
	syscall
	
	
	addi $v0, $0, 10
        syscall
