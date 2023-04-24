.section .text
.globl main
main:
    # U ecx postavimo n (tj. do kog broja hocemo da sabiramo)
    movl $5, %ecx
    # Postavljamo eax na 0 sa komandom xor zato sto je brza od mov
    xorl %eax, %eax
petlja:
    cmpl $0, %ecx
    je kraj
    addl %ecx, %eax
    decl %ecx
    jmp petlja
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80


