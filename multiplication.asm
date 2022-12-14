
###
##
# Push value to application stack.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4              
	sw	    %reg,0($sp)             
.end_macro


 # Load value from stack to given registery 
.macro	POP (%reg)
	lw	    %reg,0($sp)             
	addi	$sp,$sp,4               
.end_macro

.data
new:     .asciiz "\n"
.text

main: 
	#multiplication
	li $a0, 20
	li $a1, 1
	
	jal multiplication
	move $a3, $v1
	li $v0, 1
	syscall
	
	#newline
    	li      $v0, 4                  
    	la      $a0, new                
    syscall    
	
	#factorial
	li $a0, 5
	jal factorial
	
	
	final:
	move $a0, $s4
	li $v0, 1
	syscall
	
	j	exit_program
	
multiplication:
	PUSH($s0)
	PUSH($s1)
	move $s0, $a0 
	move $s1, $a1
	 
	li $t0, 0  	# int i = 0
	
	loop:
		add $v1, $v1, $s1
		addi $t0,$t0,1     	# increment loop
 		bne $t0,$s0,loop  	# if $t2, loop 
  	
  	end:
  		POP($s0)
  		POP($s1)
  		jr $ra

factorial:
	PUSH($s3)
	li	$v1, 0 
	li	$s3, 0
	li	$s4, 1
	move 	$t2, $a0 	# int i = 0
	
	fackLoops:
		add	$s3,$s3, 1
		move	$a0,$s3
		move	$a1,$s4
		jal 	multiplication
		move	$s4,$v1
		li $v1, 0
		bne $t2,$s3, fackLoops  # if $t2, loop 		
		
	thisIsTheEnd:		#Hold your breath and count to ten!
		POP ($s3)
	
		j final
		
exit_program:
	li $v0, 10
	syscall
