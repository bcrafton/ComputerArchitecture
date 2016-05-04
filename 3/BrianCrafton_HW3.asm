.data
source_string: .asciiz "kayakkayakkayak"
reverseString:	.space	40
string_length_message: .asciiz "The length of the string "
string_length_message2: .asciiz " = "
is_a_palindrome: .asciiz " is a palindrome "
is_not_a_palindrome: .asciiz " is not a palindrome "
new_line: .asciiz "\n"

temp:		.word	0

.text
j main
################################################
print:
# push register a0
sub $sp,$sp,4
sw $a0,4($sp)

li $v0, 4
#print whatever is in a0
syscall
#pop the value back off
lw $a0, 4($sp)
add $sp,$sp,4
#return to the program
jr $ra
################################################
string_length:
#take the string reference from $a0, put the lenght in $t0

# push register a0
sub $sp,$sp,4
move $s0, $a0
sw $s0,4($sp)

li $t0, 0 # initialize the count to zero
string_length_while:
lbu $t1, 0($a0) # load the next character into t1
beqz $t1, string_length_end # check for the null character
addi $a0, $a0, 1 # increment the string pointer
addi $t0, $t0, 1 # increment the count

j string_length_while # return to the top of the loop
string_length_end:
#pop the value back off
lw $a0, 4($sp)
add $sp,$sp,4
jr $ra
################################################
reverse_string:
#take the string reference in $a0, put the new string in array which is in $a1

# push register a0
sub $sp,$sp,4
move $s0, $a0
sw $s0,4($sp)

# push register a1
sub $sp,$sp,4
move $s0, $a1
sw $s0,4($sp)

# push register ra
sub $sp,$sp,4
move $s0, $ra
sw $s0,4($sp)

jal string_length

lw $ra, 4($sp)
add $sp,$sp,4

li $t2, 0

add $a0, $a0, $t0
subu $a0, $a0, 1

reverse_string_loop:

lb $t1, ($a0)
sb $t1, ($a1)

addi $t2, $t2, 1
subu $a0, $a0, 1
addi $a1, $a1, 1

beq $t2, $t0, reverse_string_exit
j reverse_string_loop
reverse_string_exit:
lw $a1, 4($sp)
add $sp,$sp,4

lw $a0, 4($sp)
add $sp,$sp,4
jr $ra
################################################
is_palindrome:

# push register a0
sub $sp,$sp,4
move $s0, $a0
sw $s0,4($sp)

# push register a1
sub $sp,$sp,4
move $s0, $a1
sw $s0,4($sp)

# push register ra
sub $sp,$sp,4
move $s0, $ra
sw $s0,4($sp)

jal string_length

lw $ra, 4($sp)
add $sp,$sp,4

li $t3, 0

is_palindrome_loop:
addi $t3, $t3, 1
addi $a0, $a0, 1
addi $a1, $a1, 1

lb $t1, ($a0)
lb $t2, ($a1)

bne $t1, $t2, is_palindrome_false
beq $t3, $t0, is_palindrome_true

is_palindrome_true:
la $a0, is_a_palindrome
syscall
j is_palindrome_end

is_palindrome_false:
la $a0, is_not_a_palindrome
syscall

is_palindrome_end:

lw $a1, 4($sp)
add $sp,$sp,4

lw $a0, 4($sp)
add $sp,$sp,4
jr $ra
################################################
main:
li $v0, 4
la $a0, source_string
la $a1, reverseString

jal reverse_string

la $a0, string_length_message
jal print
la $a0, source_string
jal print
la $a0, string_length_message2
jal print

la $a0, source_string
jal string_length

li $v0, 1
move $a0, $t0
syscall

li $v0, 4

la $a0, new_line
jal print

la $a0, source_string
jal print
jal is_palindrome

li $v0, 10
syscall
