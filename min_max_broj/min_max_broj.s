.section .data

pitanje: .ascii "Unesite string: \0"
pitanje_len = . - pitanje

unos: .fill 50, 1, 0
unos_len = . - unos

.section .text
.globl main
.macro Write buffer, len
    movl $4, %eax
    movl $1, %ebx
    leal \buffer, %ecx
    movl \len, %edx
    int $0x80
.endm

.macro Read buffer, len
    movl $3, %eax
    movl $0, %ebx
    leal \buffer, %ecx
    movl \len, %edx
    int $0x80
.endm

main:
    Write pitanje, $pitanje_len
    Read unos, $unos_len

    # Ocitimo ceo ebx posto cemo da kasnije koristimo bl i bh
    # A rezultat vracamo kao izlazni kod
    xor %ebx, %ebx
    # Pretpostavimo da je najmanji broj '9'
    movb $'9', %bl

    # Pretpostavimo da je najveci broj '0'
    movb $'0', %bh

    # U dh koristimo kao flag da znamo da li uopste u stringu ima
    # bilo kakav broj
    xorb %dh, %dh
    # Opet ucitavamo adresu unosa u ecx jer je
    # mozda ecx registar promenjen tokom sys_read
    leal unos, %ecx
    
    # Smanjujemo eax da preksocimo '\n'
    decl %eax

petlja:
    testl $0xffffffff, %eax
    jz sabiranje 
    movb -1(%ecx, %eax, 1), %dl
    # Da li je dl broj
    cmpb $'0', %dl
    jl dalje
    cmpb $'9', %dl
    jg dalje
proveri_najmanji:
    cmpb %bl, %dl
    jge proveri_najveci
    movb %dl, %bl
    movb $1, %dh
proveri_najveci:
    cmpb %bh, %dl
    jle dalje 
    movb %dl, %bh
    movb $1, %dh
dalje:
    decl %eax
    jmp petlja

sabiranje:
    testb $1, %dh
    jnz ima_broja_u_stringu
    xor %ebx, %ebx
    jmp kraj
ima_broja_u_stringu:
    addb %bh, %bl
    xorb %bh, %bh
kraj: 
    movl $1, %eax
    int $0x80
