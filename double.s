.section .data
msg: .ascii "The double is: "
msg_len = . - msg
nl: .ascii "\n"

.section .bss
buf: .space 32

.section .text
.global _start

_start:
    mov 16(%rsp), %rsi      # argv[1] pointer, 8 bytes for argc

    xor %rax, %rax          # accumulator = 0

# string → int
1:                          # specifically ascii digits into an int
    movzbq (%rsi), %rcx     # loads next char
    cmp $0, %rcx
    je 2f                   #

    sub $'0', %rcx          # convert ascii digits to num val
    imul $10, %rax, %rax    # shift left 1
    add %rcx, %rax          # accum = accum * 10 = dig

    inc %rsi
    jmp 1b                  

2:
    add %rax, %rax          # double the value

    # int → string, write digits into buf from the right
    mov $buf+31, %rdi       # end of buffer
    movb $'\n', (%rdi)      # put newline at end (optional, we print separately)
    dec %rdi

3:
    xor %rdx, %rdx
    mov $10, %rcx
    div %rcx                # rax = quotient, rdx = remainder

    add $'0', %dl           # convert digit to ascii
    mov %dl, (%rdi)
    dec %rdi

    test %rax, %rax
    jnz 3b                  # loop until quotient is 0 (when all digits written)

    inc %rdi                # rdi now points to first digit character

    # compute length: (buf+31) - rdi
    mov $buf+31, %rcx
    sub %rdi, %rcx          # was subtracting rsi from itself (always 0)
    mov %rcx, %rdx          # rdx = length

    # save number pointer and length
    push %rdi
    push %rdx

    # print "The double is: "
    mov $1, %rax
    mov $1, %rdi
    mov $msg, %rsi
    mov $msg_len, %rdx
    syscall

    # print number
    pop %rdx
    pop %rsi
    mov $1, %rax
    mov $1, %rdi
    syscall

    # print newline
    mov $1, %rax
    mov $1, %rdi
    mov $nl, %rsi
    mov $1, %rdx
    syscall

    # exit(0)
    mov $60, %rax
    xor %rdi, %rdi
    syscall
#this would be way easier if we were allowed to just use the assembly dump of a C program
