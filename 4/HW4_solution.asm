.data
str1: 			.space 30
str2: 			.space 30
stringId:		.asciiz "'First input string'"
colon:			.asciiz " : "
stringId2:		.asciiz "'Second input string'"
msg_gt: 		.asciiz "' is > than '"
msg_eq:			.asciiz "' is = to '"
msg_lt:			.asciiz "' is < than '"
quote:			.asciiz "'"

.text
main:			la 	$a0, str1		#system call 8 -- string with maxsize $a1 will be placed in str1 (pointed to by $a0)
			addi	$a1, $zero, 30
			addi	$v0, $zero, 8		
			syscall

			move	$t0, $a0		# temprarily keeping the a0 in t0. a0 is going to be used by syscall 8
			
			la 	$a0, stringId
			addi 	$v0, $zero, 4
			syscall
			la 	$a0, colon
			syscall
			
			la 	$a0, str1		# Print str1
			syscall

			la      $a0, str2		#system call 8 -- string with maxsize $a1 will be placed in str2 (pointed to by $a0)
			addi	$a1, $zero, 30
			addi	$v0, $zero, 8
			syscall
			
			la 	$a0, stringId2
			addi	$v0, $zero, 4
			syscall
			la 	$a0, colon
			syscall
			
			la 	$a0, str2		# Print str2
			syscall

			move	$a1, $a0		#address of first element of the str2
			move	$a0, $t0		#address of first element of the str1. --> reversing the line 17.a0 no points to beggining of the str1.
			
			addi 	$sp, $sp, -4		# Pusing a0 to the stack
			sw 	$a0, 0($sp)
			addi 	$sp, $sp, -4		# Pusing a1 to the stack
			sw 	$a1, 0($sp)
							# arguments are already set for the function
			jal 	strcmp			# result is returned in $v0
			
			lw 	$a0, 4($sp)
			lw 	$a0, 0($sp)
			addi 	$sp, $sp, 8		# another way to pop. a0 and a1 together. 

			add 	$s0, $zero, $v0		# s0 = result

			la 	$a0, quote
			addi 	$v0, $zero, 4 
			syscall 			# Print quote
			la 	$a0, stringId
			syscall
			
cond1:			slt 	$t0, $s0, $zero
			beq 	$t0, $zero, cond2
then1:			la 	$a0, msg_lt		# Print msg_lt
			addi 	$v0, $zero, 4
			syscall
			j endif
cond2:			bne 	$s0, $zero, else
then2:			la 	$a0, msg_eq		# Print msg_eq
			addi 	$v0, $zero, 4
			syscall
			j endif
else:			la 	$a0, msg_gt		# Print msg_gt
			addi 	$v0, $zero, 4
			syscall 
endif:			la 	$a0, stringId2		# Print str2
			addi 	$v0, $zero, 4
			syscall
			la 	$a0, quote		# Print quote
			addi 	$v0, $zero, 4
			syscall
			addi 	$v0, $zero, 10		# Exit
			syscall
			
strcmp:			addi $sp, $sp, -4  
			sw $ra, 0($sp)			# Push $ra

			
strcmp_loop:		lb $t0, 0($a0)
			lb $t1, 0($a1)
strcmp_cond1:		bge $t0, $t1, strcmp_cond2
strcmp_then1:		addi $v0, $zero, -1
			j strcmp_ret
strcmp_cond2:		ble $t0, $t1, strcmp_endif
strcmp_then2:		addi $v0, $zero, 1
			j strcmp_ret
strcmp_endif:		addi $a0, $a0, 1
			addi $a1, $a1, 1
strcmp_loopcond:	bne $t0, $zero, strcmp_loop
strcmp_endloop:		addi $v0, $zero, 0

strcmp_ret:     	lw $ra, 0($sp)    		# Pop $ra
			addi $sp, $sp, 4
			jr $ra  			# Return
