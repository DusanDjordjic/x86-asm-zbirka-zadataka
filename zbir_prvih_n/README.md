# Zbir prvih n brojeva

Napisati program koji sabira prvih n brojeva. Broj n postaviti u neki od registara opste namene. Razultat takodje cuvati u nekom od registara opste namene.

## Resenje

Registar %ecx cemo da korsitimo za brojac i na pocetku cemo ga postaviti na 5 (trazimo zbir prvih 5 brojeva). Registar %eax cemo koristiti za zbir i na pocetku ga postavljamo na 0 na jedan od dva nacina `movl $0, %eax` ili `xorl %eax, %eax`. Odlucili smo se za komandu xor zato sto je brza od mov.
Dok %ecx ne dodje na 0, %ecx dodajemo u %eax. Proveru da li je %ecx 0 mozemo takodje uraditi na dva nacina `cmpl $0, %ecx` ili `testl $0xffffffff, %ecx`. Ovaj put iako je test brza komanda od cmp odlucili smo se za cmp radi lepseg koda.
Na kraju nam se resenje nalazi u %eax i to proveravamo uz pomoc debuggera. 5 + 4 + 3 + 2 + 1 = 15.

### Napomena
Lakse nam je da napravimo petlju koja ce da ide unazad i da proveravamo da li je %ecx dosao do 0 nego da koristimo jos jedan registar kao brojac i da proveravamo da li je dosao do %ecx. Takodje je i brze :)
