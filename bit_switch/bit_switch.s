# int BitSwitch(unsigned int* arr, int len)

.section .text
.globl BitSwitch
BitSwitch:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %esi
    # Stack varijabla za cuvanje broja promenjenih bitova
    # Postavljamo je na 0
    subl $4, %esp
    movl $0, -12(%ebp)
    # Adresa niza 
    movl 8(%ebp), %ebx
    # Broj elemenata niza
    movl 12(%ebp), %esi
bit_switch_loop:
    testl $0xffffffff, %esi
    jz bit_switch_end 
    # Pusujemo adresu broja na indexu esi-1
    leal -4(%ebx, %esi, 4), %ecx
    pushl %ecx
    call switch_bits
    addl $4, %esp
    # Sabiramo broj promenjenih bitova
    addl %eax, -12(%ebp)
    decl %esi
    jmp bit_switch_loop
bit_switch_end:
    # Broj promenjenih bita stavljamo u eax
    popl %eax
    popl %esi
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

# unsigned int switch_bits(unsigned int* n)
switch_bits:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx
    pushl %edx
    # Brojac promenjenih bitova
    xor %eax, %eax
    # Adresa broja ebx
    movl 8(%ebp), %ebx
    # Vrednost broja ecx
    movl (%ebx), %ecx
    movl $1, %edx
switch_bits_loop:
    testl $0xffffffff, %edx
    jz switch_bits_end
    testl %ecx, %edx
    jz dont_switch 
    # Pomeramo mesku za jedno mesto i radimo xor
    # ali pre toga moramo da proverimo da li 
    # smo dosli do kraja jer ako je poslednji bit 1
    # nemamo sta dalje da switch-ujemo

    shll %edx
    testl $0xffffffff, %edx
    jz switch_bits_end
    xor %edx, %ecx
    incl %eax
    jmp switch_bits_loop
dont_switch:
    shll %edx
    jmp switch_bits_loop
switch_bits_end:
    # Vracamo promenjeni broj na adresu
    movl %ecx, (%ebx)

    popl %edx
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

