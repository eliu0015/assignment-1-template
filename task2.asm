.data
space: .asciiz " "
newline: .asciiz "\n"
A: .asciiz "A "
star: .asciiz "* "
prompt: .asciiz "How tall do you want the tower: "
height: .word 0
i: .word 0
s: .word 0
j: .word 0

.text
j input

input: 
	#Print prompt
	la $a0, prompt
	addi $v0, $0, 4
	syscall

	#Ask height
	addi $v0, $0, 5
	syscall
	sw $v0, height
	
	#Loop back if height entered is < 5
	lw $t0, height
	addi $t1, $0 5
	slt $t2, $t0, $t1
	bne $t2, $0, input
	
	j main
main: #for i in range(height):
		
	lw $t2, i
	lw $t3, height
	lw $t0, s
	lw $t1, height
	addi $s0, $0, -1 # $s0 = -1
	#s = (height+1)*-1
	addi $t1, $t1, 1 # $t1 = height + 1
	mult $t1, $s0 # $t1 = (height+1)*-1
	mflo $t1
	sw $t1, s 
	slt $t0, $t2, $t3
	bne $t0, $0,  s_loop
	j end
	
s_loop: #for s in range((height+1)*-1, -i):
	#Print space
	la $a0, space
	addi $v0, $0, 4
	syscall
	
	#lw $a0, s
	#addi $v0, $0, 1
	#syscall
	
	#Loop back if s < -1, else jump to j_loop
	lw $t0, s
	lw $t1, i
	addi $t2, $t0, 1
	sw $t2, s
	lw $t0, s
	mult $t1, $s0
	mflo $t2 # $t2 = -i
	slt $t4, $t0, $t2
	bne $t4, $0, s_loop
	#Reset j to 0
	sw $0, j
	j j_loop
	
j_loop: #for j in range(i+1):
	lw $t0, i
	beq $t0, $0, print_A
	
	#Else print star
	la $a0, star
	addi $v0, $0, 4
	syscall
	
	lw $t0, j
	lw $t1, i
	addi $t1, $t1, 1
	addi $t0, $t0, 1 
	sw $t0, j #j = j + 1
	slt $t2, $t0, $t1
	bne $t2, $0,  j_loop
	
	#Print newline
	la $a0, newline
	addi $v0, $0, 4
	syscall
	
	#Increment i
	lw $t2, i
	addi $t2, $t2, 1
	sw $t2, i
	j main

print_A:
	la $a0, A
	addi $v0, $0, 4
	syscall	
	
	lw $t0, j
	addi $t0, $t0, 1 
	sw $t0, j #j = j + 1
	
	#Print newline
	la $a0, newline
	addi $v0, $0, 4
	syscall
	
	#Increment i
	lw $t2, i
	addi $t2, $t2, 1
	sw $t2, i
	j main
			
end:
	#End program
	addi $v0, $0, 10
	syscall
	

