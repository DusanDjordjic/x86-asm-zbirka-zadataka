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

    # Opet ucitavamo adresu unosa u ecx jer je
    # mozda ecx registar promenjen tokom sys_read
    leal unos, %ecx
    
    # Smanjujemo eax da preksocimo '\n'
    decl %eax

prvi_broj_petlja:
    testl $0xffffffff, %eax
    jz kraj
    movb -1(%ecx, %eax, 1), %dl
    # Da li je dl broj
    cmpb $'0', %dl
    jl prvi_broj_dalje
    cmpb $'9', %dl
    jg prvi_broj_dalje
    movb %dl, %bl
    movb %dl, %bh
    decl %eax
    jmp trazenje_minmax_petlja
prvi_broj_dalje:
    decl %eax
    jmp prvi_broj_petlja

trazenje_minmax_petlja:
    testl $0xffffffff, %eax
    jz sabiranje 
    movb -1(%ecx, %eax, 1), %dl
    # Da li je dl broj
    cmpb $'0', %dl
    jl trazenje_minmax_dalje 
    cmpb $'9', %dl
    jg trazenje_minmax_dalje 
proveri_najmanji:
    cmpb %bl, %dl
    jge proveri_najveci
    movb %dl, %bl
    jmp trazenje_minmax_dalje
proveri_najveci:
    cmpb %bh, %dl
    jle trazenje_minmax_dalje
    movb %dl, %bh
trazenje_minmax_dalje:
    decl %eax
    jmp trazenje_minmax_petlja 

sabiranje:
    addb %bh, %bl
    xorb %bh, %bh
kraj: 
    movl $1, %eax
    int $0x80
