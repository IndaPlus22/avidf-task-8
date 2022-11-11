##### The Sieve of Eratosthenes
### I must not fear. 
##Fear is the mind-killer. 
#Fear is the little-death that brings total obliteration.

.data

message:	.asciiz "Write your number of desire and you will recieve what you seek, probably:\n"
prime_Num:	.space  1000            # reserves a block of 1000 bytes in application memory
err_msg:	.asciiz "Invalid input! Number exceeds limit 1 < n < 1001.\n"
out_msg: 	.asciiz "The prime numbers are:\n"
spacing: 	.asciiz ", "


.text

main:

    li      $v0, 4                  # magic code to print string
    la      $a0, message                 
    syscall

    # get input
    li      $v0,5                   # set system call code to "read integer"
    syscall                         # read integer from standard input stream to $v0

    # Check input
    li 	    $t0,1001            # set max to 1000
    slt	    $t1,$v0,$t0		# $t1 = input < 1001
    beq     $t1,$zero,err 	# if !(input < 1001), jump to invalid_input
    nop
    li	    $t0,1               # $t0 = 1
    slt     $t1,$t0,$v0		# $t1 = 1 < input
    beq     $t1,$zero,err 	# if !(1 < input), jump to invalid_input
    nop
    
    # initialise primes array
    la	    $t0,prime_Num	# $s1 = address of the first element in the array
    add     $t1, $0, $v0
    add     $t1, $t1, 1
    li 	    $t2,0
    li	    $t3,1
    
    
init_loop:

    sb	    $t3, ($t0)              # prime numbers
    addi    $t0, $t0, 1             # increment pointer
    addi    $t2, $t2, 1             # increment counter
    bne	    $t2, $t1, init_loop     # loop if counter != 999
    
    
    ### Let the Sieving commence! ###
	sieve_through:
	add $t3, $t3, 1
	mul $t2, $t3, $t3
	add $t4, $0, $t2
	
	evaluate_loop:
	la $t0, prime_Num
	add $t0, $t0, $t4
	sb $0, ($t0)
	add $t4, $t4, $t3
	ble $t4, $t1, evaluate_loop
	ble $t2, $t1, sieve_through
	
	
    ### Print nicely to output stream ###
    li $v0, 4
    la $a0, out_msg
    syscall
    	
    li $t2, 1
    
    print_loop:
    	la $t0, prime_Num
    	add $t2, $t2, 1
    	add $t0, $t0, $t2
    	lb $t3, ($t0)
    	bge $t2, $t1, exit_program	#exit program if the loop has run more times than input
  
    	beq $t3, $0, skip_print 	#skip if zero
    	
    	#spacing
    	bgt $t2, 2, space	
    	return_space:
    	
    	#print message
    	li $v0, 1
    	add $a0, $0, $t2 
    	syscall
   
    	ble $t2, $t1, print_loop
    	
    skip_print:
    	j print_loop
    	
    space: #add ", " 
    	li $v0, 4
    	la $a0, spacing 
    	syscall
    	j	return_space

    # exit program
    j       exit_program
    nop

err:
    # print error message
    li      $v0, 4                  # set system call code "print string"
    la      $a0, err_msg            # load address of string err_msg into the system call argument registry
    syscall                         # print the message 

exit_program:
    # exit program
    li $v0, 10                      # set system call code to "terminate program"
    syscall                         # exit program
