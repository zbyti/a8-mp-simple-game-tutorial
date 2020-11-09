# 5. System Off - praktyka

Jak może wyglądać kod w Mad Pascalu, który pozwoli nam osiągnąć nasze cele? Poniżej jedna z możliwych dróg. Starałem się, żeby było jak najmaniej assemblera jdenak nie ma potrzeby unikać go za wszelką cenę ;)

Poniższy kod w następnej części zrefaktoryzujemy (więcej asm) i przeniesiemy do **UNIT**.

```pascal
program Game;

var
  PORTB  : byte absolute $D301;
  NMIEN  : byte absolute $D40E;
  DLIST  : word absolute $D402;
  NMIVEC : word absolute $FFFA;

var
  counter        : byte absolute 0;
  vbivec, vdslst : ^word;
  offrti         : word;

procedure nmi; assembler; interrupt;
asm
{
      bit NMIST \ bpl vbi   ; check kind of interrupt
      jmp off               ; VDSLST
vbi:  inc RTCLOK+2
      jmp off               ; VBIVEC
off:
};
end;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

procedure systemOff;
begin
  asm { sei };
  vdslst := pointer(word(@nmi) + 6);
  vbivec := pointer(word(@nmi) + 11);
  offrti := word(@nmi) + 13;
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $40;
end;

begin
  systemOff;
  pause(100);
  vbivec^ := word(@vbi);
  repeat until false;
end.
```
Pozostaje już tylko *rozebrać z uwagą* ;) ten program, bez wdawania się w oczywistości.

## Z grubsza:

* `program Game;` nieobowiązkowe, ale mile widziane.
* `var PORTB: byte absolute $D301;` przykład deklaracji zemiennej typu **BYTE** zamapowanej jawnie na konkretny adres w pamięci komputera.
* `var vdslst: ^word;` zmienna będąca wskaźnikiem typu word (2 bajty). Kompilator sam zadecyduje gdzie będzie znajdować się w pamięci komputera.
* `assembler` modyfikator procedury informujący, że ciało (w tym przypadku procedury) będzie napisane w MADS.
* `interrupt` modyfikator informujący, że procedurę należy zakończyć rozkazem **RTI** (powrót z przerwania) a nie zwyczajowym **RTS** powrót z podprocedury.
* `pointer(word(@nmi) + 6);` tutaj kompilator pracuje następująco:
  * `@nmi` zwraca adres wskaźnik do procedury `nmi`.
  * `word(@nmi)` zmienia typ ze wskaźnika na word, czyli otrzymujemy dwubajtową liczbę, którą zwiększamy o 6 i zmieniamy znów na wskaźnik bo takiego typu jest `vdslst`.
* `vbivec^ := word(@vbi);` zmieniamy wartość pod adresem na jaki wskazuje `vbivec`.

## Jak to działa?

* Nasz kod startuje pierwszą instrukcją z obowiązkowego bloku `begin .. end.`, którą to jest wywołanie naszej procedury bezparametrowj `SystemOff`
  * `SystemOff` na samym początku wyłącza przerwania maskowalne **IRQ** instrukcją `SEI`
  *  `vdslst` wskaźnik na miejscie pamięci gdzie znajduje się adres skoku `jmp off; VDSLST`, który obsługuje przerwanie wywołana przez naszą *Display Listę*, jeżeli takie będziemy potrzebować. Domyślnie jest ustawiany by skakać od razu do rozkazu `RTI`.
  *  `vbivec` wskaźnik na miejscie pamięci gdzie znajduje się adres skoku `jmp off; VBIVEC`, który będzie obsługiwać nasze przerwanie **VBI**. Domyślnie skacze do rozkazu `RTI`.
  *  `offrti` ustalamy asres wystąpienie rozkazu `RTI` w procedurze `nmi` do późniejszego użycia.
  *  `NMIEN := 0;` wyłączamy przerwania niemaskowalne.
  *  `PORTB := $FE;` ta wartość wyłącza w atari *self-test*, **Basic** i **OS**.
  *  `NMIVEC := word(@nmi)` przekazujemy adres naszej procedury obsługi przerwań niemaskowalnych.
  *  `NMIEN := $40;` skoro poinformowaliśmy Atari jak ma reagować na przerwania **NMI** to możeby je włączyć, na początek włączmy **VBI** ustawiając szósty bit na `%01000000`.
* `vbivec^ := word(@vbi);` podmieniamy adres dla skoku `jmp off; VBIVEC` na adres naszej procedury.

Możemy też pokusić się o krótkie omówienie kodu **asm** zawartego w procedurze `nmi`:
* `bit NMIST` konwertuje dwa ostatnie bity wartości znajdujęcj się pod asresem `$D40F` na flagi procesora 6502. Odpowiednio bit 7 ustawia flagę `N` a szósty flagę 'V'. Dzięki temu będziemy wiedzieć jakie przerwanie **NMI** wywołało naszą procdurę. Jeżeli flaga `N` nie została zapalona to mamy doczynienia z przerwaniem **VBL** inaczej jest to przerwanie **DLI**.
* `bpl vbi` jeżeli wynik operacji `bit NMIST` jest dodatni to skocz do `inc RTCLOK+2`.
* `inc RTCLOK+2` aby zapewnić sobie działanie procedury `pause` i jej przeciążonej wersji np. `pause(100)` musimy zapewnić działanie jednego z liczików systemowych. W naszym przypadku podbijany jest co przerwanie **VBL** (PAL raz na 1/50 sekundy, NTSC raz na 1/60 sekundy) o jeden wartość pod adresem `$14`. Dzięki temu możemy używać procedury `puse(x: BYTE)` aż do wartości 255. Jest to trochę pójście na skróty bo w rzeczywistoći `pause` może przyjmować większą wartość niż bajt, ale do tego musielibyśmy obsłużyć jeszcze adresy `$13` i `$12` a to nie jest nam potrzebne.

Na koniec zajmijmy się procedurą `vbi`, która jak widzimy też przeznaczona jest do obsługi przez przerwanie:
* `asm { phr };` zrzucamy wszystkie rejestry procesora 6502 za pomocą makra MADS na stos procesora aby po poworcie z przerwania przwrócić właściwą wartość tych rejestrów (swoje flagi `NV-BDIZC` procesor odkłada na stos automatycznie) na których w tej procedurze raczej na pewno nsz kod będzie pracował przy większej ilości operacji.
* `inc(counter);` zwiększamy o jeden jakiś nasz licznik, tak jak `RTCLOK` będzie zwiększany co przerwania **VBL** z częstotliwością pracy naszego systemu telewizyjnego.
* `asm { plr };` koniec precedury, za chwilę napotkamy `RTI`, więc przedtem obowiązkowo przywróćmy wartości rejestrów `A`, `X`, `Y` do stanu z przed przerwania pobierając je ze stosu.

## Słowniczek pojęć:

* [**VBL**](http://atariki.krap.pl/index.php/VBL)
>Vertical Blank Interrupt jest to przerwanie NMI generowane przez układ ANTIC zawsze w 248 linii skaningowej po zakończeniu kreślenia obrazu, w momencie wygaszenia plamki.

* [**NMI**](http://atariki.krap.pl/index.php/NMI)
>Rodzaj przerwania, które w momencie wystąpienia (najpóźniej po zakończeniu wykonywania bieżącego rozkazu) musi być przyjęte i obsłużone przez procesor. A to w odróżnieniu od IRQ, które przyjęte i obsłużone być tylko może.

* [**IRQ**](http://atariki.krap.pl/index.php/IRQ)
>Rodzaj przerwania, które procesor może zignorować, jeśli programista sobie tego zażyczy; a to w odróżnieniu od NMI, które zignorowane być nie może.

* [**Rejestr stanu**](https://pl.wikipedia.org/wiki/Rejestr_stanu)
>Rejestr stanu lub rejestr flag (niepoprawnie: rejestr statusu) – rejestr procesora opisujący i kontrolujący jego stan. Zawartość tego rejestru może zależeć od ostatnio wykonanej operacji (zmiana pośrednia), bądź trybu pracy procesora, który można ustawiać (zmiana bezpośrednia).

* [**NMIST**](http://atariki.krap.pl/index.php/Rejestry_ANTIC-a)
>Rejestr statusu przerwań NMI

* [**PORTB**](http://atariki.krap.pl/index.php/Rejestry_PIA)
>W serii XL rejestr ten steruje układem zarządzania pamięcią oraz (istniejącymi w niektórych modelach) diodami konsoli.