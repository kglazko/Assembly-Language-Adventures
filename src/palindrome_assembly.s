# palindrome_assembly.s
# Name:  Kate Glazko
	.data
buf1:   .space  21     # receive original input in this buffer
counter: .byte 0,0,0,0,0,0,0,0,0,0
# the following are constant strings that you can use for your prompts and messages
msgin:  .asciiz "Enter up to 20 digits without spaces: "
msg1:   .asciiz "Your string: "
msg2:   .asciiz " IS a palindrome\n"
msg3:   .asciiz " IS NOT a palindrome\n"
msg4:   .asciiz "The mode digit is: "

# print this string for a newline character
nline:  .asciiz "\n"

	.text
main:
	
	la 	$a0, msgin
	li 	$v0, 4
	syscall
	
	la 	$a0, msgin
	li 	$v0, 8
	la 	$a0, buf1
	#li $a1, 20
	move	$a1, $a0
	
	syscall
	
	
	
	la 	$s0, buf1
	add 	$s2, $zero, $zero
	addi 	$s3, $zero, '\n'
length:
	lb 	$s1, 0($s0)
	beq 	$s1, $s3, end
	addi 	$s2, $s2, 1
        addi 	$t9, $s2, 0
	addi 	$s0, $s0, 1
		
	j length
end:    sb 	$0, 0($s0)

palindrome:
	
	ble	$s2, 1, true
	
	lb 	$t0, 0($a1)
	addi 	$t1, $s2, -1
	add 	$t1, $t1, $a1
	lb 	$t1, 0($t1)
	bne 	$t0, $t1, false
	
	addi 	$s2, $s2, -2
	addi 	$a1, $a1, 1
	
	j palindrome
	
false:
	addi 	$s7, $zero, 0
	b 	output
	
	
true:
	addi 	$s7, $zero, 1
		
	b 	output

output:

	la 	$a0,msg1
	li 	$v0, 4
	syscall
 
  	
	li 	$v0, 4
	la 	$a0, buf1
	syscall
	
	bne 	$s7, $zero, outputPOS
	la 	$a0, msg3
	syscall
	b check_mode
	
outputPOS:	
	 la 	$a0, msg2
	 syscall
	 b check_mode
	 
check_mode:
	la 	$s4, counter
	addi 	$s5, $s4, 9
	la 	$s0, buf1
	lb  	$s5, 0($s0)
	addi 	$t4, $zero, 0
	
loop:   lb 	$t6, 0($s0)
	subi 	$t6, $t6, 48
	add 	$s6, $s4, $t6
	
	lb 	$t5, 0($s6)
	
	addi 	$t5, $t5, 1
	sb 	$t5, 0($s6)
	
	addi 	$t4, $t4, 1
	
	beq 	$t4, $t9, search_mode
	addi 	$s0, $s0,1
	j loop
	
search_mode:
	la 	$s4, counter
	addi 	$s3, $s4, 9
	lb 	$t6, 0($s3)
	addi 	$s5, $zero, 9
	
inner_loop:
	beq 	$s3,$s4, exit
	
	sub 	$s3, $s3, 1
	lb 	$t5, 0($s3)
	ble 	$t5, $t6, inner_loop
	addi 	$t6, $t5, 0
	sub 	$s5, $s3, $s4
	
	j inner_loop
	


	

	
exit:
# exit	
	
	
	la 	$a0, msg4
	li 	$v0, 4
	syscall
	
	addi 	$a0, $s5, 0
	li 	$v0, 1
	syscall
	
	
	li 	$v0, 10
	syscall
