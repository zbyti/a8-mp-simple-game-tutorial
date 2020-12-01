# 8. Resources

W poprzednim rozdziale dowiedzieliśmy się jakie warunki musi spełnić **Display List** by **ANTIC** pracował z nią poprawnie.

Ułożyliśmy nasz kod tak by tablica przechowująca polecenia **DL** po skompilowaniu naszego programu znajdowała się na jego początku. Jest to jednak metoda mało elastyczna i w pewnych sytuacjach może okazać się zawodna.

By mieć pełną kontrolę nad tym gdzie w pamięci komputera wyląduje nasza **DL** posłużymy się przewidzianymi (między innymi) do tego celu [dyrektywami](http://mads.atari8.info/doc/madpascal.html#direc) **Mad Pascala**.

## INCLUDE

`INCLUDE {$I filename}, {$INCLUDE filename}`

Dyrektywa dołączenia tekstu zawartego w pliku dołącza dokładnie w miejscu użycia dyrektywy co sprawia, że możemy *zszyć* swój plik z kilku *kawałków* kodu.

W naszym przypadku posłużymy się dyrektywą `include` by dołączyć nasze zmienne globalne, które umieścimy w katalogu głównym naszego projektu pod nazwą `const.inc`. Przyjmijmy, że globalne stałe będziemy pisać kapitalikami zamiast [camelCase](https://pl.wikipedia.org/wiki/CamelCase).

```pascal
DL_2      = $1000;
GAME_LMS  = $e000;
```

Z powodu naszej organizacji w moduły kodu musimy umieścić te zmienne w naszym **UNIT** odpowiedzialnym za grafikę. Niestety musimy to zrobić w części interfejsu a nie w części implementacji bo inaczej kompilator nie będzie widział naszych stałych.

```pascal
unit gr;
interface

const
{$i const.inc}
```
## [RESOURCE](http://mads.atari8.info/doc/madpascal.html#resource)

`RCLABEL RCTYPE RCFILE`

Możemy już sterować za pomocą stałych globalnych w którym miejscu pamięci będzie nasz ekran rozgrywki a gdzie będzie znajdować się nasza **DL** dlatego teraz w wygodny sposób podepnijmy kod **DL** pod wskazany adres.

W katalogu `lib` tworzymy plik `gr.rc` a w nim umieszczamy wpis:

```
DL_2 rcasm 'res/dl.asm'
```

Jak zapewne spostrzegłeś musimy teraz stworzyć katalog `res` a w nim plik `dl.asm` co niniejszym uczyńmy, a następnie posłużmy się najwygodniejszym ze znanych mi sposobów na tworzenie **DL** czyli za pomocą **MADS** :]

```
    icl 'const.inc'

dl2
:3  .BYTE $70
    .BYTE $42,A(GAME_LMS)
:23 .BYTE 2
    .BYTE $41,A(dl2)
```

Jeżeli pamiętasz jak zbudowany jest nasz ekran powyższy zapis powinien być dla Ciebie łatwy do odszyfrowania.

Nasz **UNIT** graficzny po zamianach powinien wyglądać tak:

```pascal
unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

const
{$i const.inc}
{$r gr.rc}

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

procedure mode2;
begin
  pause; SDLSTL := DL_2;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
```

## Rezultat

Budujemy naszą grę za pomocą skryptu `.build` i czytamy co też pisze do nas kompilator:

```
./build
Mad Pascal Compiler version 1.6.5 [2020/11/03] for 6502
Compiling main.pas
main.pas (9) Note: Use assembler block instead pascal
21 lines compiled, 0.62 sec, 5123 tokens, 410 idents, 169 blocks, 5 types
1 note(s) issued
$R RCASM   $1000..$101F 'res/dl.asm'
ZPAGE: $0080..$00D7
RTLIB: $2000..$1FFF
SYSTEM: $2036..$2040
GR: $2041..$204F
SYS: $2050..$207C
CODE: $2000..$20A8
DATA: $20A9..$20B4
Writing listing file...
Writing object file...
8657 lines of source assembled in 4 pass
379 bytes written to the object file
```

Możemy zobaczyć taką informację: **$R RCASM   $1000..$101F 'res/dl.asm'**. Zgodnie z oczekiwaniem nasza **DL** jest pod adresem `$1000` i zajmuje spodziewaną ilość miejsca czyli `$1f` bajtów, nasz program *główny* tak jak poprzednio zaczyna się od `$2000`.

Dla porządku sprawdźmy jeszcze czy `output/main.xex` działa i czy w *debug* zobaczymy naszą **DL** w oczekiwanej postaci i miejscu:

```
dlist
1000: 3x 8 BLANK
1003: LMS E000 MODE 2
1006: 23x MODE 2
101D: JVB 1000
```

Wszystko gra! :)
