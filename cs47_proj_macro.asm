# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
#.macro extract_nth_bit($t0, $s1, $t1)
#	srlv   $t0, $s1, $t1
#	andi   $t0, 0x1
#	.end_macro
.macro extract_nth_bit($regD, $regS, $regT)
	srlv $regD, $regS, $regT
	andi $regD, $regD, 1
	.end_macro
	
	.macro insert_to_nth_bit($regD, $regS, $regT, $maskReg)
	li $maskReg, 1
	sllv $maskReg, $maskReg, $regS
	nor $maskReg, $maskReg, $maskReg
	and $regD, $regD, $maskReg
	sllv $regT, $regT, $regS
	or $regD, $regD, $regT
	.end_macro
	
	
