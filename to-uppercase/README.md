# ToUppercase

Napraviti program koji od korisnika ucitava string (max 50), transformise ga tako sto svako malo slovo pretvori u veliko i opet ga ispise nazad.

## Objasnjenje resenja

Na pocetku radimo dva sistemska poziva. Prvi da ispisemo pitanje "Unesite string: ", a drugi da procitamo to sto je korisnik uneo(Prvi write, drugi read). Nakon sys\_read poziva u %eax se nalazi broj procitanih karaktera koji cemo da koristimo kao indeks.

Zamislimo da je korisnik uneo "abc\n" ('\n' se uvek nalazi na kraju jer prilikom kucanja komande pritisnete enter da bi ste je potvrdili komadnu i on to procita). U eax nam se nalazi 4, '\n' se nalazi na indeksu 3.
Posto hocemo da indeksiramo string u petlji i da polako smanjujemo %eax do 0 moramo da dodamo -1 u indeksni operator. Karakter tada dobijamo na sladeci nacin `movb -1(%ecx, %eax, 1), %dl`. 
Da nismo dodali taj -1 tada prvi karakter nikada ne bismo proverili, A na ovaj nacin proveravamo prvi karakter kada je eax 1. Takodje u nasem primeru kada smo ucitali "abc\n" i potom za jedan smanjili %eax (%eax je sada 3) prvi provereni karakter ce biti 'c' koji je na indeksu 2.
Samo transformisanje karaktera se zasniva na tome da proverimo da li je vrednost bajta u registru %dl izmedju 97 ('a') i 122 ('z'). Ako je vrednost u %dl manja od 97 ili veca od 122 znaci da trenutni karakter nije malo slovo i mozemo da nastavimo dalje a ako jeste od %dl oduzimamo 32 zato sto je razlika u ascii tableli izmedju 'a' i 'A' 32. Cuvanje karaktera nazad u string je isto sto smo radili i prilikom citanja samo obrnuto `movb %dl, -1(%ecx, %eax, 1)`.

