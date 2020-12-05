# 10. P/MG Wprowadzenie

## O czym warto wiedzieć?

8-bit Atari na którym bawimy się w programowanie jest konstrukcją generalnie nie zmienioną od roku 1979. Wyprzedza ona o 3 lata takie konstrukcje jak Commodore C64 czy ZX Spectrum 48. Pomimo zawansowania swoich układów pod pewnym względem Atari pozostaje w tyle za konkurecją, która pojawiła się później. Na komputerze Atari 400/800 nie ma tak zwanych atrybutów kolorów przez co np. w trybie **ANTIC 2** obraz pozostanie monochromatyczny. A8 pomimo posiadania sprzętowych *sprajtów* niestety nie może się pochwalić duszkami w trybie hi-res co będzie miało praktyczne skutki w naszej grze.

Planujemy napisać grę w trybie **ANTIC 2** który jest trybem znakowym 40 kolumny na 24 wiersze. W tym przypadku każdy znak to matryca 8x8 pikseli. Piksel w tym trybie ma **pół cyklu koloru**, duszek niestety ma już piksel szeroki na **jeden cykl koloru** co na ekranie objawi się tym, że na dwa piksele tła w poziomie będzie przypadał jeden piksel duszka który w naszym przypadku będzie po prostu prostokątem 2x1 a nie 1x1 jak grafika tła.

Mówiąc inaczej - grafika tła będzie szczegółowa a grafika naszego pojazdu trochę zgrubna. Mam nadzieję, że uda mi się narysować coś co nie będzie aż tak się odcinało od tła ;)

Rozwiązaniem powyższego problemu mogą być tak zwane *softwarowe sprajty* czyli ruchome obiekty wykonane na znakach (lub grafice, zależy od wybranego trybu graficznego), my checmy jednak zapoznać się z **P/MG** dlatego pobawimy się w Ghostbusters :D

Warto też przypomnieć, że możliwość przesunięcia w poziomie również odbywa się o **cykl koloru** czyli o dwa piksele naszego tła w **trybie drugim ANTIC**.

Ostatnią niedogodnością jest brak sprzętowej możliwości przesuwania naszego duszka w pionie, jest tak dlatego, że duszek *by design* jest wysoki tak jak nasz ekran, więc przemieszczać musimy dane w pamięci komputera co jest niestety w naszej gestii.

Atari 400/800 oferuje nam 4 obiekty gracza i 4 pociski (które możemy połączyć w piątego gracza). Nie jest to wiele ale za pomocą pewnych technik programistycznych można te obiekty rozmnożyć, być może dokonamy tego cudu, wszystko w swoim czasie ;)

Ponadto duszki można łączyć w pary w celu uzyskania dodakowego koloru przez nałożenie ich na siebie, można je rozciągać, używać do podkolorowywania naszej grafiki etc.

To chyba tyle tytułem wstępu, reszta *wyjdzie w praniu* :]

## Niezbędnik

Niestety w dalszej części tutoriala nie obejdzie się pewnego zasobu wiedzy, więc zapraszam do samodzielnej lektury podanych niżej zasobów :]

Zapoznaj się proszę z:
* [Player-Missile Graphics](https://www.atariarchives.org/agagd/chapter5.php)
* [Player/Missile Graphics Memory Map](https://www.atariarchives.org/mapping/appendix7.php)
* opisem poniższych rejestrów w podręczniku [Mapping The Atari](https://www.atariarchives.org/mapping/memorymap.php) odszukując odpowiednie adresy lub etykiety:

```pascal
HPOSP0 : byte absolute $D000;  // (W) Horizontal position of player 0
HPOSP1 : byte absolute $D001;  // (W) Horizontal position of player 1
SIZEP0 : byte absolute $D008;  // (W) Size of player 0
SIZEP1 : byte absolute $D009;  // (W) Size of player 1
COLPM0 : byte absolute $D012;  // (W) Color and luminance of player and missile 0
COLPM1 : byte absolute $D013;  // (W) Color and luminance of player and missile 1
PRIOR  : byte absolute $D01B;  // (W) Priority selection register
GRACTL : byte absolute $D01D;  // (W) Used with DMACTL to latch all stick and paddle triggers
DMACTL : byte absolute $D400;  // (W) Direct Memory Access (DMA) control
PMBASE : byte absolute $D407;  // (W) MSB of the player/missile base address used to locate the graphics for your players and missiles
```

Dodatkowo możesz rzucić okeim na **atariki** [tutaj](http://atariki.krap.pl/index.php/PMG), [tutaj](http://atariki.krap.pl/index.php/Rejestry_GTIA) oraz [tu](http://atariki.krap.pl/index.php/Rejestry_ANTIC-a#PMBASE). Warto też zapoznać się ze [słownikiem terminów](http://www.atari.org.pl/artykul/dgf/41) z którego cześć pojęć wrzuciełm do słowniczka u dołu strony gdyby artykuł zniknął z sieci.

Jeszcze raz przypomnę: *bez zapoznanie się z opisem powyższych rejestrów dalsza część tutoriala może być niezrozumiała!*

## Słowniczek pojęć

* **PRIOR**
>Rejestr sterujący układu GTIA o adresie $D01B. Służy do wyboru trybu GTIA oraz określenia priorytetów sprite’ów.

* **PMG**
>Grafika graczy i pocisków (Player Missile Graphics) – nazwa dla sprite’ów w Atari.

* **Playfield**
>Pole gry - grafika obejmująca kolory 0-3 (COLPF0-COLPF3) ale nie kolor tła COLBAK.

* **Cykl CPU**
> Cykl zegara taktującego CPU, w nszym przypadku [MOS 6502](https://pl.wikipedia.org/wiki/MOS_Technology_6502) 1.77MHz dla PAL, 1.79MHz w NTSC.

* [**Cykl koloru**](http://www.atariki.krap.pl/index.php/Cykl_koloru)
>Jednostka czasu odpowiadająca jednemu okresowi podstawowego sygnału taktującego GTIA (w systemie PAL - 3,546894 MHz, w systemie NTSC - 3,579545 MHz, w systemie SECAM - 3,563 MHz), co odpowiada 1/228 linii, czyli 1/71136 ramki, a także 1/2 cyklu maszynowego. Jednostka ta ma bezpośrednie przełożenie na określenie poziomej pozycji i szerokości wyświetlanych obiektów graficznych i do tego celu również jest używana.
>
>Jest to czas, w jakim układy graficzne Atari są w stanie dokonać pełnej zmiany koloru w linii poziomej, stąd też wynika najmniejsza szerokość pikseli w kolorowych trybach graficznych. Tryby monochromatyczne ANTIC-a dają możliwość wyświetlania pikseli o szerokości połowy cyklu koloru.

* **Piksel lores**
>Piksel w rozdzielczości poziomej 160 równoważny jednemu cyklowi koloru.

* **Piksel hires**
>Piksel w rozdzielczości poziomej 320 równoważny połowie piksela lores i połowie cyklu koloru.

* **HBLANK**
>Niewidoczna część linii obrazu obejmująca cykle koloru 222-227 oraz 0-33 (cykle CPU 111-113 oraz 0-16), łącznie 40 cykli koloru (20 cykli CPU). W trakcie HBLANK nie działa wykrywanie kolizji obiektów PMG.

* **ACTIVE DISPLAY**
>Widoczna część linii obrazu obejmująca cykle koloru 34-221 (cykle CPU 17-110), łącznie 188 cykli koloru (94 cykle CPU).

* **VBLANK**
>Czas wygaszania pionowego obejmujący wygaszone linie obrazu 248-311 w PAL/SECAM, 248-261 w NTSC oraz 0-7 w każdym z systemów. Zawiera w sobie czas VSYNC. W trakcie VBLANK nie działa wykrywanie kolizji obiektów PMG.

* **VSYNC**
>Czas synchronizacji pionowej obejmujący 3 pełne linie 275-277 w PAL/SECAM, 255-257 w NTSC.

