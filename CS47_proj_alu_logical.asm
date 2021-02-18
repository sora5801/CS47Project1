.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################

#####################################################################
# Procedure name: twos_complement
# Argument: 
#       $a0: Number of which 2's complement to be computed
# Return:
#        $v0: Two's complement of $a0
# Notes:
#####################################################################
twos_complement:
	addi	$sp, $sp, -20
	sw	$fp, 20($sp)
	sw	$ra, 16($sp)
	sw      $a0, 12($sp)
	sw      $a1,  8($sp)
	addi	$fp, $sp, 20
	
	not $a0, $a0
	li $a1, 1

	jal add_logical
	
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a1,  8($sp)
	addi $sp, $sp, 20
	jr $ra
	
#####################################################################
# Procedure name: twos_complement_if_neg
# Argument: 
#       $a0: Number of which 2's complement to be computed
# Return:
#        $v0: Two's complement of $a0 if $a0 is negative
# Notes:
#####################################################################	
twos_complement_if_neg:
addi	$sp, $sp, -16
	sw	$fp, 16($sp)
	sw	$ra, 12($sp)
	sw      $a0, 8($sp)
	addi	$fp, $sp, 16
	
bge $a0, 0, skip_call
jal twos_complement

j enditnow #This part is necessary because after the stack frame restore, $a0 will contain the original negative results and $v0 will contain the 2's complement(it will be positive).

skip_call:
move $v0, $a0

enditnow:

	lw $fp, 16($sp)
	lw $ra, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 16
jr $ra

#####################################################################
# Procedure name: twos_complement_64bit
# Argument: 
#       $a0: Lo of the number
#       $a1: Hi of the number
# Return:
#        $v0: Lo part of 2's complemented 64 bit
#        $v1: Hi part of 2's complemented 64 bit
# Notes:
#####################################################################
twos_complement_64bit:
addi	$sp, $sp, -20
	sw	$fp, 20($sp)
	sw	$ra, 16($sp)
	sw      $a0, 12($sp)
	sw      $a1,  8($sp)
	addi	$fp, $sp, 20

not $a0, $a0
not $a1, $a1
move $s3, $a1
li $a1, 1


jal add_logical

move $s4, $v0
move $a1, $v1
move $a0, $s3

jal add_logical

move $v1, $v0
move $v0, $s4

lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a1,  8($sp)
	addi $sp, $sp, 20

jr $ra

#####################################################################
# Procedure name: twos_complement_64bit
# Argument: 
#       $a0: Lo of the number
#       $a1: Hi of the number
# Return:
#        $v0: Lo part of 2's complemented 64 bit
#        $v1: Hi part of 2's complemented 64 bit
# Notes:
#####################################################################

bit_replicator:
addi	$sp, $sp, -16
	sw	$fp, 16($sp)
	sw	$ra, 12($sp)
	sw      $a0, 8($sp)
	addi	$fp, $sp, 16
	
beq $a0, 1, skip
move $v0, $zero
j endthis
skip:
li $v0, 0xFFFFFFFF
endthis:


lw $fp, 16($sp)
	lw $ra, 12($sp)
	lw $a0,  8($sp)
	addi $sp, $sp, 16
jr $ra



au_logical:
	addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw      $a2, 44($sp)
	sw      $a3, 40($sp)
	sw      $s0, 36($sp)
	sw      $s1, 32($sp)
	sw      $s2, 28($sp)
	sw      $s3, 24($sp)
	sw      $s4, 20($sp)
	sw      $s5, 16($sp)
	sw      $s6, 12($sp)
	sw      $s7,  8($sp)
	addi	$fp, $sp, 60
# TBD: Complete it

beq     $a2, '+', add_logical
beq     $a2, '-', sub_logical	
beq     $a2, '*', mul_signed
beq     $a2, '/', div_signed


#Add:
add_sub_logical:
addi    $sp, $sp, -24
    sw    $fp, 24($sp)
    sw    $ra, 20($sp)
    sw    $a0, 16($sp)
    sw    $a1, 12($sp)
    sw    $a2,  8($sp)
    addi    $fp, $sp, 24

li $t0, 0 #this one is i
li $v0, 0 #This one is S
extract_nth_bit($v1, $a2, $zero)

addition_loop:
   	beq $t0, 32, exit
   	extract_nth_bit($t2, $a0, $t0) #Get ith bit of A and place it in t2
   	extract_nth_bit($t3, $a1, $t0) #Get ith bit of B and place it in t3
   	xor $t4, $t2, $t3 #Let t4 carry the result of Xor A and B
   	xor $t5, $t4, $v1 #Let t5 carry the result of Ci xor t4, which is Y
   	and $t8, $t2, $t3 #Let t8 carry the result of A and B
 	and $t7, $t4, $v1 #Let t7 carry the result of Cin and t4
   	or  $t9, $t8, $t7 #Let t9 carry the result of t5 or t8, which is the CO
   	move $v1, $t9 #Change the content of Cin to CO
   	insert_to_nth_bit($v0, $t0, $t5, $t4)
   	addi $t0, $t0, 1
   	j addition_loop
exit:

 lw    $fp, 24($sp)
    lw    $ra, 20($sp)
    lw    $a0, 16($sp)
    lw    $a1, 12($sp)
    lw    $a2,  8($sp)
    addi    $sp, $sp, 24
jr $ra

add_logical:
addi    $sp, $sp, -24
    sw    $fp, 24($sp)
    sw    $ra, 20($sp)
    sw    $a0, 16($sp)
    sw    $a1, 12($sp)
    sw    $a2,  8($sp)
    addi    $fp, $sp, 24
 
li $a2, 0x00000000
jal add_sub_logical
 
  lw    $fp, 24($sp)
    lw    $ra, 20($sp)
    lw    $a0, 16($sp)
    lw    $a1, 12($sp)
    lw    $a2,  8($sp)
    addi    $sp, $sp, 24
jr $ra

sub_logical:
addi    $sp, $sp, -24
    sw    $fp, 24($sp)
    sw    $ra, 20($sp)
    sw    $a0, 16($sp)
    sw    $a1, 12($sp)
    sw    $a2,  8($sp)
    addi    $fp, $sp, 24

not $a1, $a1 
li $a2, 0xFFFFFFFF
jal add_sub_logical 

  lw    $fp, 24($sp)
    lw    $ra, 20($sp)
    lw    $a0, 16($sp)
    lw    $a1, 12($sp)
    lw    $a2,  8($sp)
    addi    $sp, $sp, 24
jr $ra


mul_unsigned:
addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw      $a2, 44($sp)
	sw      $a3, 40($sp)
	sw      $s0, 36($sp)
	sw      $s1, 32($sp)
	sw      $s2, 28($sp)
	sw      $s3, 24($sp)
	sw      $s4, 20($sp)
	sw      $s5, 16($sp)
	sw      $s6, 12($sp)
	sw      $s7,  8($sp)
	addi	$fp, $sp, 60
li $s0, 0 #this one is i
li $s1, 0 #this one is H
move $s2, $a1 #this one is L, which is the multiplier
move $s3, $a0 #This one is M, the multiplicand

loop:
beq $s0, 32, Exit
extract_nth_bit($a0, $s2, $zero) #Repeat the LSB of $s2 and place it in s4
jal bit_replicator

move $s4, $v0 #s4 now has the LSB of $a0 bit replicated 
and $s5, $s3, $s4 #This one has X, which is M & R
move $a1, $s5 #Let $a1 have be assigned s5. This is to be added to $a0
la $a0, ($s1) #Set the address of H to a0

jal add_logical

move $s1, $v0 #Assign the value v0 back to H. v0 contained the value H + X
srl $s2, $s2, 1 #L has been shifted right logical by 1
extract_nth_bit($s7, $s1, $zero) #Extract the LSB of H and place it in 7
li $t1, 31
insert_to_nth_bit($s2, $t1  $s7, $t9) #Assign the 31st bit of L with the LSB of H, which is in $s7
srl $s1, $s1, 1 #Shift the value of H right logical by 1
addi $s0, $s0, 1 #Increment by 1 
j loop

Exit:
move $v0, $s2 #Assign the value of $v0 by L, which is the Lo part
move $v1, $s1 #Assign the value of $v1 by H, which is the hi part

lw     $fp, 60($sp)
	lw     $ra, 56($sp)
	lw     $a0, 52($sp)
	lw     $a1, 48($sp)
	lw     $a2, 44($sp)
	lw     $a3, 40($sp)
	lw     $s0, 36($sp)
	lw     $s1, 32($sp)
	lw     $s2, 28($sp)
	lw     $s3, 24($sp) 
	lw     $s4, 20($sp)
	lw     $s5, 16($sp)
	lw     $s6, 12($sp)
	lw     $s7,  8($sp)
	addi   $sp, $sp, 60
	jr 	$ra


mul_signed:
addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw      $a2, 44($sp)
	sw      $a3, 40($sp)
	sw      $s0, 36($sp)
	sw      $s1, 32($sp)
	sw      $s2, 28($sp)
	sw      $s3, 24($sp)
	sw      $s4, 20($sp)
	sw      $s5, 16($sp)
	sw      $s6, 12($sp)
	sw      $s7,  8($sp)
	addi	$fp, $sp, 60
	
move $s6, $a0 #let N1, which will be $s6, be $a0. That is, N1 = $a0
move $s5, $a1 #temporarily letting 
jal twos_complement_if_neg #v0 contains the two complement of $a0 if $a0 is negative
move $a3, $v0 #a3 will hold the twos complement if $a0 was negative
move $t6, $s5 #let N2, which will be $t6, be $a1. That is, N2 = $a1
move $a0, $t6 #Move N2 into a0. This way, when twos_complement_if_neg is called, a0 will contain the twos_complement of N2, which ia the original a1
jal twos_complement_if_neg
move $a1, $v0 
move $a0, $a3
jal mul_unsigned

li $t0, 31
extract_nth_bit($t1, $s6, $t0) #extract $a0[31] and place it in $t1
extract_nth_bit($t2, $t6, $t0) #extract $a1[31] and place it in $t2
xor $t3, $t1, $t2 #Xor between t2 and t1, place it in t3, and this is the sign of the result. 
bne $t3, 1, continue2
move $a0, $v0
move $a1, $v1
jal twos_complement_64bit
continue2:

lw     $fp, 60($sp)
	lw     $ra, 56($sp)
	lw     $a0, 52($sp)
	lw     $a1, 48($sp)
	lw     $a2, 44($sp)
	lw     $a3, 40($sp)
	lw     $s0, 36($sp)
	lw     $s1, 32($sp)
	lw     $s2, 28($sp)
	lw     $s3, 24($sp) 
	lw     $s4, 20($sp)
	lw     $s5, 16($sp)
	lw     $s6, 12($sp)
	lw     $s7,  8($sp)
	addi   $sp, $sp, 60
	jr 	$ra

div_unsigned:
addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw      $a2, 44($sp)
	sw      $a3, 40($sp)
	sw      $s0, 36($sp)
	sw      $s1, 32($sp)
	sw      $s2, 28($sp)
	sw      $s3, 24($sp)
	sw      $s4, 20($sp)
	sw      $s5, 16($sp)
	sw      $s6, 12($sp)
	sw      $s7,  8($sp)
	addi	$fp, $sp, 60

li $s0, 0 #this one is i
li $s1, 0 #this one is R
move $s2, $a0 #this one is Q, which is the the dividend
move $s3, $a1 #This one is D, which is the divisor

div_loop:
beq $s0, 32, Exit_Div
sll $s1, $s1, 1 #Shift R left logical by 1
li $t1, 31 #Load $t1 with the number 31. This will be used to extract the 31st bit from Q
extract_nth_bit($t2, $s2, $t1) #Extract the 31st bit of Q and place it in $t2
insert_to_nth_bit($s1, $zero, $t2, $t9) #insert the 31st bit of Q into the zeroth bit of R
sll $s2, $s2, 1 #Shift left logical Q by 1
move $a0, $s1 #move R into $a0
move $a1, $s3 #move D into $a1
#jal Sub
jal sub_logical
blt $v0, $zero, increment
move $s1, $v0 #move the difference into R
li $t1, 1 #Load $t1 with 1, which will be inserted into the 0th bit of Q
insert_to_nth_bit($s2, $zero, $t1, $t9)
increment:
addi $s0, $s0, 1

j div_loop

Exit_Div:
move $v0, $s2 #Move Q, the quotient, into $v0
move $v1, $s1 #Move R, the remainder, into $v1


lw     $fp, 60($sp)
	lw     $ra, 56($sp)
	lw     $a0, 52($sp)
	lw     $a1, 48($sp)
	lw     $a2, 44($sp)
	lw     $a3, 40($sp)
	lw     $s0, 36($sp)
	lw     $s1, 32($sp)
	lw     $s2, 28($sp)
	lw     $s3, 24($sp) 
	lw     $s4, 20($sp)
	lw     $s5, 16($sp)
	lw     $s6, 12($sp)
	lw     $s7,  8($sp)
	addi   $sp, $sp, 60
	jr 	$ra

div_signed: 
addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw      $a2, 44($sp)
	sw      $a3, 40($sp)
	sw      $s0, 36($sp)
	sw      $s1, 32($sp)
	sw      $s2, 28($sp)
	sw      $s3, 24($sp)
	sw      $s4, 20($sp)
	sw      $s5, 16($sp)
	sw      $s6, 12($sp)
	sw      $s7,  8($sp)
	addi	$fp, $sp, 60
	
move $s6, $a0 #let N1, which will be $s6, be $a0. That is, N1 = $a0
move $s5, $a1 #temporarily letting $s5 hold $a1
jal twos_complement_if_neg
move $a3, $v0 #a3 will hold the twos complement if $a0 was negative
move $t6, $s5 #let N2, which will be $t6, be $a1. That is, N2 = $a1
move $a0, $t6 #Move N2 into a0. This way, when twos_complement_if_neg is called, a0 will contain the twos_complement of N2, which ia the original a1
jal twos_complement_if_neg
move $a1, $v0 
move $a0, $a3
jal div_unsigned

li $t0, 31
extract_nth_bit($t1, $s6, $t0) #extract $a0[31] and place it in $t1
extract_nth_bit($t2, $t6, $t0) #extract $a1[31] and place it in $t2
xor $t3, $t1, $t2 #Xor between t2 and t1, place it in t3, and this is the sign of the result. 
move $a0, $v0
move $s1, $v1
bne $t3, 1, continue4
jal twos_complement
move $s4, $v0
j continue6
continue4:
move $s4, $v0
continue6:
li $t0, 31
extract_nth_bit($t1, $s6, $t0) #extract $a0[31] and place it in $t1
move $a0, $s1
bne $t1, 1, continue5
jal twos_complement
move $v1, $v0
move $v0, $s4
j End
continue5:
move $v0, $s4
move $v1, $s1
j End

End:

lw     $fp, 60($sp)
	lw     $ra, 56($sp)
	lw     $a0, 52($sp)
	lw     $a1, 48($sp)
	lw     $a2, 44($sp)
	lw     $a3, 40($sp)
	lw     $s0, 36($sp)
	lw     $s1, 32($sp)
	lw     $s2, 28($sp)
	lw     $s3, 24($sp) 
	lw     $s4, 20($sp)
	lw     $s5, 16($sp)
	lw     $s6, 12($sp)
	lw     $s7,  8($sp)
	addi   $sp, $sp, 60
	jr 	$ra

	lw     $fp, 60($sp)
	lw     $ra, 56($sp)
	lw     $a0, 52($sp)
	lw     $a1, 48($sp)
	lw     $a2, 44($sp)
	lw     $a3, 40($sp)
	lw     $s0, 36($sp)
	lw     $s1, 32($sp)
	lw     $s2, 28($sp)
	lw     $s3, 24($sp) 
	lw     $s4, 20($sp)
	lw     $s5, 16($sp)
	lw     $s6, 12($sp)
	lw     $s7,  8($sp)
	addi   $sp, $sp, 60
	jr 	$ra