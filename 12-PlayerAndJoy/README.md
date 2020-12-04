# 12. Player & Joy

## Na wstępie trochę organizacyjnie

Od ostatniej części tutka kod przeszadł mały refaktoring dlatego warto byś pobieżnie rzucił okiem do katalogu `src` tej części kursu.

Podstawowa zmiania to wyniesienie derekty dołączającej zasoby:

```
{$r res/gr.rc}
{$r res/gfx.rc}
```

do głównego pliku `main.pas`, także w bibliotekach katalogu `lib` jest już porządek.

Plik `const.inc` trafiły do folderu `inc` gdzie będziemy trzymać podobne skrawki kodu doklejane dyrektywą `include` - oczywiście jeżeli będzie taka potrzeba.

Kod odpowiedzialny za sprajty trafił do dedykowaego modułu.

Mam nadzieję, że do tej pory nauczyłeś się już korzystać z mapy pamięci Atari bo mogę od teraz nie omawiać wszystkich rejestrów, które wystąpią w kodzie. Gdy napotkasz nazwę rejestru, która nic Ci nie mówi, albo nie wiesz dlaczego wstawiam takie a nie inne wartości to zatrzymaj się na moment i poszperaj w internecie albo w książce.

## Para buch, koła w ruch!

Skoro mamy już nasz pojazd na ekranie czas sprawić by był nam powolny ;) Rozpocznijmy od zakreślenia granic w jakich będzie się on przemieszczał:

```pascal
SHIP_LEFT_LIMIT     = 48;
SHIP_RIGHT_LIMIT    = SHIP_LEFT_LIMIT + (16 * 5);
SHIP_TOP_LIMIT      = 32;
SHIP_BOTTOM_LIMIT   = 10 * 18;
```

* `SHIP_LEFT_LIMIT` z poprzedniej części powinieneś wiedzieć dlaczego  ma taką a nie inną wartość.
* `SHIP_RIGHT_LIMIT` ni mniej ni więcej pozwoli przemieścić się naszej rakiecie maksymalnie o jej `5` szerokości w prawo - czyli lekko poza środek ekranu.
* `SHIP_TOP_LIMIT` jeszcze nie wiem jakie wymiary będzie miał nasz playfield, więc wartość standardowa dla atarowskiego ekranu.
* `SHIP_BOTTOM_LIMIT` na początek możemy zejść maksymalnie `18` wierszy od góry ekranu.

Przyda nam się też zmienna przechowyjąca odczytany stan manipulatora:

```pascal
interface
var joyDirection: byte absolute 3;
```

## Joystick

Do poruszania naszymi sprajtami będziemy używać *dżoja* w porcie pierwszym. W tym celu (dla pewności) ustawmy drugi bit na `1` w rejestrze `PACTL`:

```pascal
PACTL := PACTL or %100;
```

zapewni nam to że młodszy [nibble](https://pl.wikipedia.org/wiki/P%C3%B3%C5%82bajt) rejestru `PORTA` będzie zwracał nam stan *manipulatorów wychyłkowych* :D

Pozycja spoczynkowa to wartość `%1111`, wygaszenie któregoś z tych bitów poinformuje nas o kierunku wychylenia *przyjemnej pałęczki*.

```
     Decimal                   Binary
               14                       1110
                |                         |
            10  | 6                 1010  | 0110
              \ |/                      \ |/
          11-- 15 ---7           1011-- 1111 --0111
              / |\                      / |\
             9  | 5                 1001  | 0101
                |                         |
               13                       1101
```

Przy okazji (jak widać na powyższym) kolejny raz można zobaczyć dlaczego pisząc kod czasem posługuję się liczbami w systemie binarnym a czasem szesnastkowym, najrzadzej systemem dziesiętnym.

O ile wartości dziesiętne stanu joya nie wiele mogą mówić to już wartości binarne pozwolają dokonać ciekawej obserwacji. Gdy podzielimy te cztery bity na pół to okaże się, że kierunki ukośne są złożeniem `góra/dół/prawo/lewo`. Jakoż, że od strony programistycznej implementacja skosów wymagała by od nas wykonania po sobie kodu odpowiadającego za przesunięcie pionowe i poziome to nie będziemy kodu powielać tylko zastosujemy sztuczkę.

Tutaj warto wspomnieć o decyjach jakie podejmue się na 8-bit komuterze. Można napisać szybszy kod obsługując każdy z `8` kierunków osobno ale odbędzie się to kosztem zużycia cennej pamięci. Napisać kod bardzo kompaktowo ale pójdzie na to masa cylki procesora. Ja proponuję kompromis między długością kodu a szybkością jego wykonania.

Tutaj warto też wspomnieć, że czas wykonania naszej procedury nie będzie stały, dlatego przy obliczaniu cyklożarłoczności procedury bierzemy zawsze najdłuższą ścieżkę naszego algorytmu. W naszym przypadku skosy będą wykonywały się dłużej niż np. ruch tylko w prawo.

Napiszmy stałe, które będą odpowiadały ruchom joysticka:

```pascal
JOY_LEFT            = %1000;
JOY_RIGHT           = %0100;
JOY_UP              = %0010;
JOY_DOWN            = %0001;
```

Jak widzisz, pomijam nieistotne części nibbla dla danego kierunku aby łatwiej było mi zrobić moja dwu przebiegową procedurę zakładając odpowednią maskę.

Najlepiej zobaczmy gotowy kod:

```pascal
procedure moveShip;
begin
  bMask := %1100;
  for b01i := 1 downto 0 do begin
    case (joyDirection and bMask) of
      JOY_RIGHT: begin
        if bHposp1 < SHIP_RIGHT_LIMIT then begin
          Inc(wShipX,$0101); HPOSP01 := wShipX;
        end;
      end;
      JOY_LEFT: begin
        if bHposp0 > SHIP_LEFT_LIMIT then begin
          Dec(wShipX,$0101); HPOSP01 := wShipX;
        end;
      end;
      JOY_UP: begin
        if bShipY > SHIP_TOP_LIMIT then begin
          Dec(bShipY); copyShip;
        end;
      end;
      JOY_DOWN: begin
        if bShipY < SHIP_BOTTOM_LIMIT then begin
          Inc(bShipY); copyShip;
        end;
      end;
    end;
    bMask := %0011;
  end;
end;
```

Pętla **FOR** zapewnia nam dwa przebiegi na wypadek gdyby kierunek był skosem i trzeba było wykonać dwa warunki zawarte w instrukcji `case`. `bMask` korzysta z poczynionej wcześniej obserwacji, że góra/dół ma swója połówkę nibbla a lewo/prawo swoją, dzięki operacji `and` i odpowiedniej masce jesteśmy za pomocą tego kodu obsłużyć także skosy :]

Pozorny minus jest taki, że jeżli kierunek nie był skosem to dokonamy nieptrzebnych operacji, ustaliliśmy jednak już wcześniej, że interesje nas tylko maksymalny czas wykonania procedur. Jeżeli wszystko chcemy mieć zsynchronizowane na ekranie to zaoszczędzone cykle na niewiele nam się przydadzą. No chyba, że będziemy śrubować kod i wrzucić coś w wolne cykle, ale to już zabaw przeznaczona raczej dla języka maszynowego ;)

Warto wspomnieć o `Inc(wShipX,$0101);`. Ta sztuczka dzięki połączeniu `HPOSP0` i `HPOSP1` w jeden 16-bit rejestr pozwala nam w zwięzły sposób zwiększyć oba 8-bit rejestry o jeden. W sysetmie szesnaskowym od razu widać co robimy, że w zmiennej typu `word` młodszy i starszy bajt inkremetujemy o jeden. Gdybym napisał dziesiętnie liczbę **257** zamiast `$0101` to nie było by to takie oczywiste co się dzieje już na pierwszy rzut oka jak to jest widoczne gdy posługujemy się systemem szesnastkowym.

Porcedura `copyShip` powinna być Ci znan z poprzedniej części, a przynajmniej jej implementacja:

```pascal
procedure copyShip;
begin
  Move(pointer(GFX_SHIP_ADR), pointer(P0_ADR + bShipY), GFX_SHIP_SEG);
  Move(pointer(GFX_SHIP_ADR + GFX_SHIP_SEG), pointer(P1_ADR + bShipY), GFX_SHIP_SEG);
end;
```

Pozostało już tylko *zczytać* stan dżoja na przerwani **VBI** i gotowe! :]

```pascal
procedure vbi; interrupt;
begin
  asm { phr };

  joyDirection := PORTA;
  if (joyDirection and %1111) <> %1111 then moveShip;

  asm { plr };
end;
```

Procedurę `moveShip` wywołujemy tylko wtedy gdy stan joysticka w porcie pierwszym jest inny niż spoczynkowy.

Pzostała już tylko kompilacja swiżego kodu i można spróbować rozbić sprajt o krawędź ekranu :D
