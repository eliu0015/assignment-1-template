.data

greeting: .asciiz "Welcome to the Thor Electrical Company!\n"
prompt_age: .asciiz "Enter your age: "
prompt_con: .asciiz "Enter your total consumption in kWh: "
prompt_out: .asciiz "Mr Loki Laufeyson, your electricity bill is $"
dot: .asciiz "."
age: .word 0
discount: .word 0
consumption: .word 0
total_cost: .word 0
gst: .word 0
total_bill: .word 0
t1_price: .word 9
t2_price: .word 11
t3_price: .word 14

.text
#Print greeting
la $a0, greeting
addi $v0, $0, 4
syscall

#Ask for age
addi $v0, $0, 4
la $a0, prompt_age
syscall

addi $v0, $0, 5
syscall
sw $v0, age

#Ask for power consumption
addi $v0, $0, 4
la $a0, prompt_con
syscall

addi $v0, $0, 5
syscall
sw $v0, consumption

#Find consumption tier 
lw $t0, consumption
addi $t2, $0, 600
addi $t3, $0, 1000
slt $t1, $t3, $t0
beq $t1, $0, tier2 #If consumption < 1000 branch to tier 2

#Else price is tier 3 -------------------------------------------------------------
#lw $t0, discount
#bne $t0, $0, tier3_discount #If discount == 1, branch to tier3_discount

#Determine discount flag
addi $t0, $0, 18
addi $t3, $0, 65
lw $t2, age
sle $t1, $t2, $t0
bne $t1, $0, tier3_discount
sle $t1, $t3, $t2
bne $t1, $0, tier3_discount

lw $t0, consumption
lw $t1, total_cost
subi $t2, $t0, 1000 # $t2 = Consumption - 1000
lw $t4, t3_price
mult $t2, $t4 #(Consumption - 1000)*tier3_price
mflo $t2 
sw $t2, total_cost # total_cost = (Consumption - 1000)*tier3_price
addi $t0, $0, 1000 
sw $t0, consumption # Consumption = 1000
j tier2
#----------------------------------------------------------------------------------

tier3_discount:
	lw $t0, consumption
	lw $t1, total_cost
	subi $t2, $t0, 1000 # $t2 = Consumption - 1000
	lw $t3, t3_price
	subi $t4, $t3, 2
	mult $t2, $t4 #(Consumption - 1000)*tier3_price-2
	mflo $t2 
	sw $t2, total_cost # total_cost = (Consumption - 1000)*tier3_price
	addi $t0, $0, 1000 
	sw $t0, consumption # Consumption = 1000
	j tier2

tier2:
	lw $t0, consumption
	addi $t2, $0, 600
	slt $t1, $t0, $t2
	bne $t1, $0, output #If consumption is < 600 branch to tier 1
	lw $t1, total_cost
	subi $t2, $t0, 600 # $t2 = Consumption - 600
	lw $t4, t2_price
	mult $t2, $t4 #(Consumption - 600)*tier2_price
	mflo $t2 
	add $t3, $t2, $t1
	sw $t3, total_cost
	addi $t0, $0, 600 
	sw $t0, consumption # Consumption = 1000
	j output
	
	
output:
	lw $t0, total_cost
	lw $t1, consumption
	lw $t2, t1_price
	mult $t1, $t2 # $t1 = consumption*tier_one_price
	mflo $t1
	add $t0, $t0, $t1
	sw $t0, total_cost
	addi $t1, $0, 10
	div $t0, $t1
	mflo $t2
	sw $t2, gst
	
	#total_bill = total_cost + gst
	lw $t0, total_cost
	lw $t1, gst
	add $t2, $t0, $t1
	sw $t2, total_bill
	
	#Print output prompt
	la $a0, prompt_out
	addi $v0, $0, 4
	syscall
	
	#Print dollars
	addi $t0, $0, 100
	div $t2, $t0
	mflo $t0
	mfhi $t1	
	add $a0, $0, $t0
	addi $v0, $0, 1
	syscall
	
	#Print dot
	la $a0, dot
	addi $v0, $0, 4
	syscall
	
	#Print cents
	add $a0, $0, $t1
	addi $v0, $0, 1
	syscall

	#End program
	addi $v0, $0, 10
	syscall
