.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	#addi	$sp, $sp, -32
	#sw	$fp, 32($sp)
	#sw	$ra, 28($sp)
	#sw	$a0, 24($sp)
	#sw	$a1, 20($sp)
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw      $a2,  8($sp)
	#sw      $v0, 12($sp)
	#sw      $v1,  8($sp)
	addi	$fp, $sp, 24
	
beq     $a2, '+', Add
beq     $a2, '-', Sub
beq     $a2, '*', Mul
beq     $a2, '/', Div

Add:
add $v0, $a0, $a1
j End
Sub:
sub $v0, $a0, $a1
j End
Mul:
mult $a0, $a1
mflo $v0
mfhi $v1
j End
Div:
div $a0, $a1
mflo $v0
mfhi $v1

End:
# TBD: Complete it
	#lw     $fp, 32($sp)
	#lw     $ra, 28($sp)
	#lw     $a0, 24($sp)
	#lw     $a1, 20($sp)
	#lw     $a2, 16($sp)
	lw     $fp, 24($sp)
	lw     $ra, 20($sp)
	lw     $a0, 16($sp)
	lw     $a1, 12($sp)
	lw     $a2, 8($sp)
	#lw     $v0, 12($sp)
	#3lw     $v1,  8($sp)
	addi   $sp, $sp, 24
	jr	$ra
