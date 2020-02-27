.data
msg1: .asciiz "Enter the length of your input: "
msg2: .asciiz "Enter your input: "
msg3: .asciiz "Output of the program is: "
input: .space 1024 #input string
reversed: .space 256 #reversed string
output: .space 256 # will store the output palindrome

.text
la $a0,msg1
li $v0,4
syscall

li $v0,5
syscall
move $s1,$v0 # $s1 has the length of the string



la $a0,msg2
li $v0,4
syscall


li	$v0, 8			# Ask the user for the string they want to reverse
la	$a0, input		# We'll store it in 'input'
li	$a1, 1024		# Only 1024 chars/bytes allowed
syscall
move $s0,$a0 # $s0 has the starting address of the string

move $a1, $s1
sub $a1, $a1, 1 #append to get rid of '\n' character in the start of the reverse string
la   $a0, input
add  $a0, $a0, $a1
la   $a2, reversed
jal reverse


la $a0, input
la $a1, reversed 
la $a2, output

jal strcpy

la $a0,msg3
li $v0,4
syscall

la $a0,output 
li $v0,4
syscall

li $v0,10
syscall

reverse:
    # $a0 - address of string to reverse 
    # a1 - length of the string
    # a2 - address of string where to store the reverse(output variable)
    addi  $sp, $sp, -4     #stack memory allocation
    sw    $ra, 0($sp)    	  #store ra in top of stack
    bltz  $a1, reverse_end # Base case - branch if length less than zero
    lb    $t0, 0($a0)
    subi  $a1, $a1, 1	  #decrement by one 
    subi  $a0, $a0, 1 	
    sb    $t0, 0($a2)
    addi  $a2, $a2, 1
    jal reverse
    
reverse_end:
    lw   $ra, 0($sp)        # reallocate stack
    addi $sp, $sp, 4	  # add 4 to stack pointer to re-arrange original position	
    jr   $ra


strcpy: #copies the content of $a0 and $a1 register arrays and make a new array in $a2 register

    li $t8, 10 #store newline in $t8

    #loop through first string and copy to output string
   sCopyFirst:

        lb   $t0, 0($a0)
        beq  $t0, $zero sCopySecond #exit loop on null byte
        beq  $t0, $t8 sCopySecond    #exit loop on new-line
        sb   $t0, 0($a2)
        addi $a0, $a0 1				#increment adresses			
        addi $a2, $a2 1
        b sCopyFirst
    #loop through second string and copy to output string 
    sCopySecond:

        lb   $t0, 0($a1)
        beq  $t0, $zero, sDone #exit on null byte
        beq  $t0, $t8, sDone   #exit on new-line
        sb   $t0, 0($a2)
        addi $a1, $a1 1
        addi $a2, $a2 1
        b sCopySecond

    sDone:

        sb $zero, 0($a2) #null terminate string
        jr $ra
