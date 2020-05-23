	# main program
#
# program variables
#   n:   $s0
#   sum: $s1
#   i:   $s2
#
main:
    li      $v0, 4          # issue prompt
    la      $a0, prompt
    syscall

    li      $v0, 5          # get n from user
    syscall
    move    $s0, $v0

    li      $s1, 0          # sum = 0
    li      $s2, 0          # i = 0
for:
    blt     $s0, $s2, endf  # exit loop if n < i
    add     $s1, $s1, $s2   #     sum += i
    add     $s2, $s2, 1     #     i++
    b       for             # continue loop
endf:
     