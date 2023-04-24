.section .data
pitanje: .ascii "Unesite string: \0"
pitanje_len = . - pitanje

odgovor: .ascii "Uppercase: \0"
odgovor_len = . - odgovor 

unos: .fill 50, 1, 0
unos_len = . - unos

.section .text
.globl main

.macro Write buffer, len
    movl $4, %eax # Kod za sys_write
    movl $1, %ebx # stdout == 1 
    leal \buffer, %ecx
    movl \len, %edx
    int $0x80
.endm

.macro Read buffer, len
    movl $3, %eax # Kod za sys_read
    movl $0, %ebx # stdin == 0
    leal \buffer, %ecx
    movl \len, %edx
    int $0x80
.endm
main:
    # Napravili smo jednostavne makroe radi laskeg onosa i ispisa
    Write pitanje, $pitanje_len
    Read unos, $unos_len

    # Read nam u eax vrati broj procitanih karaktera
    # Posto cemo da idemo unazad kroz string
    # A eax da koristimo kao index odmah da smajujemo za 1 
    # Da bi smo preskocili '\n' karakter
    decl %eax 
    # Pogledajte ispis unosa na kraju programa.
    # Postavili smo da ispisuje maksimalno unos_len karaktera
    # sto bi znacilo da ako smo nas string unos napunili na pocetku
    # nekom drugom vrednoscu (na primer 42 '*') on bi nam pored stringa
    # koji je korisnik uneo ispisao jos i ostale zvezdice.
    # Iz tog razloga pre nego sto krenemo u algoritam na mesto '\n' 
    # Napisemo 0 da bi smo na tom mestu prekinuli string.
    # Ako je korisnik upisao vise od 50 karaktera a mi procitali samo 50
    # Poslednji nece biti '\n' ali cemo mi svakako da poslednji zamenimo nulom.
    # Probajte da unos na pocetku napunite zavedicama
    # unos: .fill 50, 1, 0 -> unos: .fill 50, 1, 42
    # Zakomentarisite liniju ispod i pokrenite program
    # Nakon unosa "aBc" ispis ce vam biti
    # ABC
    # ************...
    movb $0, (%ecx, %eax, 1)

    # Registar ecx moze biti promenjen posle sistemskog poziva
    # Zato opet u ecx ucitavamo adresu unosa
    leal unos, %ecx

petlja:
    # test radi & (and) binarnu operaciju i brzi je nego cmp.
    # Kada radimo & izmedju broja gde su sve jedinice (0xffffffff) i eax
    # dobicemo 0 samo ako je eax 0, sto i hocemo
    testl $0xffffffff, %eax jz ispis 
    # Registar dl koristimo da privremeno sacuvamo karakter na indeksu eax-1
    # U README.md falju imate detaljniji opis ovog procesa
    movb -1(%ecx, %eax, 1), %dl
    # Treba proveriti da li je dl malo slovo
    # Radimo suprotnu logiku. Ako je manji od 'a' (97) ili
    # veci od 'z' (122) skacemo na lablu dalje 
    # a ako nije oduzimamo 32 od dl i cuvamo ga nazad u string
    cmpb $'a', %dl
    jl dalje
    cmpb $'z', %dl
    jg dalje
    # Zaso 32? Zasto sto je u ascii tabeli razlika izmedju 'a' i 'A' 32
    subb $32, %dl 
    movb %dl, -1(%ecx, %eax, 1)
dalje:
    decl %eax 
    jmp petlja
ispis:
    Write odgovor, $odgovor_len 
    Write unos, $unos_len
kraj:
    movl $1, %eax
    movl $0, %ebx
    int $0x80

    
        
