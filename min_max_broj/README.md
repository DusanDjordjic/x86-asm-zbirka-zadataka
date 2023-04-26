# Minimalni i maksimalni broj u stringu

Program treba da ucita string i da nadje najmanji i najveci broj u stringu. Kao povartnu vrendost treba da vrati zbir njihova dva ascii koda.

## Resenje

Resenje se sastoji iz dve petlje. Prva petlja prolazi kroz string i trazi prvi broj. Kada ga nadje postavlja i `%bl` i `%bh` na tu vrednost. Na ovaj nacin smo pretpostavili da su i najmanji i najveci broj taj prvi koji smo nasli. Ako u stringu nema ni jedan broj skacemo na labelu kraj gde zbog toga sto smo pre same petlje uradili `xor %ebx, %ebx` povratna vrednost ce biti 0 sto i hocemo.

Nakon prve petlje dolazimo u drugu koja treba da nastavi dalje prolazak kroz string i da nadje najmanji i najveci broj. To radimo tako sto citamo karakter po karakter i ako jeste broj uporedjujemo ga prvo sa `%bl` (trenutno najmanji) i `%bh` (trenutno najveci). Ako je manji od `%bl` onda `%bl` postavljamo na taj karakter (`%dl`). Isto tako i za `%bh` samo sto proveravamo da li je `%dl` veci od `%bh` i ako jeste onda u `%bh` sacuvamo `%dl`.

Napomena:
Logika u programu je obrnuta. Umesto da se pitamo da li je `%dl` veci od `%bh` i da onda radimo nesto mi se pitamo da li je `%dl` manji ili jednak sa `%bh` i ako jeste preskacemo kod koji `%dl` cuva u `%bh`. Isto je i za `%bl`.

Nakon prolaska kroz ceo string druga petlja skace na labelu sabiranje. Tamo se `%bh` doda u `%bl` tako da sada u `%bl` imamo zbir koji treba da vratimo kao izlazni kod. Jos samo moramo da `%bh` postavimo na 0 da bi onda ceo registar `%ebx` imao istu vrednost kao `%bl`.
