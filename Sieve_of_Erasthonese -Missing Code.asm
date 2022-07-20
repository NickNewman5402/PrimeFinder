#Sieve of Erasthonese Prime Finder Algorithm
#Complete the code 
#Find the following missing:
#<1>, <2>, <3>, <4> are numbers
#<x>, <w>, <y>, <z> are instructions or operands of instructions
############################### Registers ###############################
#s1 - The array stored in memory
#a1 - The greatest number stored in the array
#a2 - The maximum value of p
#a3 - Is "N" - The total amount of cells in the array (i.e. a1+1)
#t0 - Loop counter i
#t1 - Stores the dynamic "p" value
#t2 - Dynamic limit for "Composite_Eraser" loop
#t3 - p*4 for array index (since there are 4 bytes per integer)
#t6 - Prime Number Counter
#t7 - Controls when new line is printed in output
#t8 - Controls how many numbers are printed per line in the output


.data
list: .space <1>	#minimum required array size in Bytes

.text
li $t1, 1		#initialize p
li $a1, <2>		#set to the max number stored in the array
li $a2, <3>		#set to the minimum number of times the eraser loop needs to iterate (i.e. max value of p)
addi $a3, $a1, 1	#set N to the max number + 1


##########################################################################
####################### Initialize Array of Size N ####################### 
##########################################################################
la $s1, list		#initialize array address
li $t0, 0 		#initialize i
init_array:					
beq $t0, $a3, Loop_Initializer	
sw $t0, 0($s1) 		#list[i] = addr of list[i]	
addi $s1, $s1, <4>	#step to next array cell							
addi $t0, $t0, 1	#increment the number to be stored in next cell	
j init_array						
##########################################################################


Loop_Initializer:
li $t0, 0			#re-initialize i
la $s1, list 			#s1 = array address
beq $t1, $a2, Print_Init	#exit if the limiting p value has been reached 
addi $t1, $t1, 1		#increment p
<x> $t2, $a1, $t1		#set loop limit according to p
mul $t3, $t1, 4			#t3=p*4 for address
add $s1, $s1, <y>		#start eraser loop at the proper index


Composite_Eraser:
beq $t0, <z>, Loop_Initializer	#move to next p if dynamic limit has been reached
add $s1, $s1, <y>		#skip to next index 
<w> $zero, 0($s1)		#store 0 in current index (i.e. erase value in current index)
addi $t0, $t0, 1		#increment counter i
j Composite_Eraser


##########################################################################
######################### Print Array of Size N ########################## 
##########################################################################
Print_Init:
la $s1, list 		#re-initialize s1 = beginning index of array address
addi $s1, $s1, 8	#skip first two indexes of the array
li $t0, 0 		#initialize i=0
li $t6, 0		#initialize prime number counter
li $t7, 0		#initialize new line control
li $t8, 20		#set prime numbers per line to 20
j Print
NewLine:
li $a0, 10		#load an ascii line feed (new line) character to a0
li $v0, 11 		#syscall to print a character
syscall			#print a new line character
j IfZero
Print:
beq $t0, $a3, End	#end program if i = number of indexes in array
lw $a0, ($s1) 		#load t0 to a0
beq $a0, 0, IfZero	#if number stored in index is 0, then skip printing procedure
li $v0, 1 		#syscall to print an integer
syscall
addi $a0, $zero, 9 	#load an ascii horizontal tab character to a0
li $v0, 11 		#syscall to print a character
syscall	
addi $t6, $t6, 1
div $t6, $t8		#find if t8 number of primes have been output to the current line of text in the output
mfhi $t7		#store the remainder of the division above to t7
beqz $t7, NewLine	#if t8 many primes have been output to the current line in the output, print a new line
IfZero:
addi $s1, $s1, 4 	# step to next array cell
addi $t0, $t0, 1 	# count elem just init'd	
j Print
End:
li $v0, 10		#end program
syscall 
