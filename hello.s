.section .data
msg:    .ascii "Hello, World!\n"
len = . - msg

.section .text
.global _start

_start:
    mov $1, %rax      # syscall: write
    mov $1, %rdi      # file descriptor: stdout
    mov $msg, %rsi    # pointer to message
    mov $len, %rdx    # message length
    syscall

    mov $60, %rax     # syscall: exit
    xor %rdi, %rdi    # status 0
    syscall
