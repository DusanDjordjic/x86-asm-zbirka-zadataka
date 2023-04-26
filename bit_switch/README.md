
# BitSwitch

Zadatak mozete naci u folderu t34 na [linku](http://www.acs.uns.ac.rs/sr/node/237/6727646).

## Resenje  

Deklaracija fukcije koju treba da napravimo izgleda ovako:
``` C
int BitSwitch(unsigned int* niz, int duzina);
```

Funkcija treba da prodje kroz niz brojeva i da za svaki broj promeni na nacin definisan u zadatku. Povratna vrednost je zbir broja promenjenuh bitova u svakom od brojeva. Da bi smo to lakse uradili u nasem programu cemo da napravimo jos jednu funkciju kojoj cemo da posaljemo adresu broja i ona ce da ga promeni. Povratna vrednost je broj promenjenih bitova.
``` C
unsigned int switch_bits(unsigned int* n);
```

### BitSwitch funkcija

Prvo sto cemo da uradimo je da sacuvamo `%ebx` i `%esi` registre na staku posto cemo da ih koristimo u daljem radu i moramo da ih vratimo na pocetnu vrednost prilikom vracanja iz funkcije. 

Nakon toga zauzimamo mesto za lokalnu varijablu na steku i postavljamo je na 0. U njoj cemo da cuvamo broj promenjenih bita i na kraju cemo da je stavimo u eax i to ce nam biti povratna vrednost.

Pravimo petlju sa kojom prolazimo kroz niz brojeva, adresu svakog broja stavljamo na stek i pozivamo drugu funkciju switch\_bits koja menja bitove i kao povratnu vrendost vraca broj promenjenih bitova (`%eax`). Taj broj saberemo sa stek varijablom koju smo napravili na pocetku i idemo u sledecu iteraciju petlje. 

### Switch\_bits funkcija

Switch\_bits funkcija treba da ide redom bit po bit i da ako je trenutni bit 1 sledeci promeni sa 0 u 1 ili sa 1 u 0. To radimo tako sto napravimo masku u `%edx`. Na pocetku maska je 1 (...00001). 

U petlji proveravamo da li je `%edx` 0 i ako jeste skacemo na kraj. To radimo zato sto cemo u petlji da shift-ujemo levo `%edx` i kada jedinica izadje van registra `%edx` vrednost registra `%edx` ce da bude 0 sto znaci da smo proverili sve bitove.

Radimo & (and) izmadju `%edx` i broja koji proveramo (`%ecx`). Binarana operacija and ce da vrati ne nula vrendost onda kada su u oba registra biti na odredjenoj poziciji 1.

Primer: 
Proveravamo da li je 3. bit 1:
```
    ...00011101 (%ecx)
&   ...00000100 (%edx)
---------------
    ...00000100
```
Ako bit na trenutnoj poziciji jeste 1 treba sledeci bit da promenimo (flip-ujemo). To radimo tako sto prvo `%edx` shift-ujemo levo za 1 da bi smo jedinicu pomerili za jedno mesto levo tj. na sledeci bit i onda radimo `xor %edx, %ecx`. 

Xor operacija: 

| xor | 1 | 0 |
|-----|---|---|
|  1  | 0 | 1 |
|  0  | 1 | 0 |

Kao sto vidimo mozemo da flipujemo bit tako sto uradimo xor sa 1.
Nakon sto smo uradili xor skacemo nazad na petlju. 

Napomena: 
Pogresno je posle xor-a jos jednom pomeriti `%edx` ulevo jer treba da proverimo da li je taj promenjeni bit sad 1 ili 0 i ako je 1 da sledeci promenimo.

Napomena:
Kada je bit na trenutnoj poziciji 1 i shift-ovali smo `%edx` ulevo da bi smo uradili xor u sledecoj instrukciji moramo proveriti da li je `%edx` postao 0. To nastaje u sledecoj situaciji.
```
    100110... (%ecx)
^   100000... (%edx)
-------------
    100000...
```
Kada je poslednji bit 1 onda nema sta vise da flipujemo i nakon pomeranja `%edx` ulevo `%edx` ce postati 0. Greska nastaje ako to ne proverimo jer onda cemo da povecamo brojac promenjenih bitova a nismo trebali to da uradimo jer je `%edx` dosao do kraja.
