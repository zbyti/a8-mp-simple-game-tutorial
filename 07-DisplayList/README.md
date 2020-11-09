# 7. Display List

## Teoria

Kolejnym etapem kładzenia fundamentów pod naszą grę jest organizacja ekranu. W 8-bit komputerach Atari odpowiada za to **ANTIC**, układ ten wykonuje program zwany **Display Listą**.

Sprawa jest bardzo prosta, do dyspozycji mamy instrukcje informujące układ graficzny, które linie skaningowe (lub wiersze) mają być wyświetlone a które nie, czy mają wywołać przerwanie DLI, czy ma być włączony scroll poziomy, pionowy (lub oba), z jakiego obszaru pamięci ma zacząć pobierać dane dla obraz oraz czy następne instrukcje dla **DL** po dojściu do jej końca mają być pobierane z innej **DL** czy też z tej samej.

Instrukcje te to zwyczajne wartości 8-bit które w większości przypadków można sumować, np.: wyśietlić linię z danego obszaru pamięci, wybrać tryb graficzny ANTIC, włączyć skroll poziomy i przerawnie DLI będzie sumą wartościL

* **LMS** `$40`
* **tryb graficzny** np. tryb **ANTIC 2** to `$2`
* **DLI** wywołanie przerwania `$80`
* **scroll horyzontalny** `$10`

Zsumowanie tych wartości daje nam liczbę `$D2` i będzie to poprawna instrukcja porgramu **ANTIC**. Detale znajdziesz w literaturze podanej we wprowadzeniu a jeżeli chcesz pobawić się narzędziem do tworzenia **DL** to możesz skorzystać z tej [strony](https://bocianu.gitlab.io/fidl/), osobiście jednak polecam się tego nauczyć.

Na początku nie będziemy potrzebowali innej **DL** niż ta z którą zgłasza się Atari np. z włączonym Basic-iem, czyli zwykły tryb tekstowty zwany **Basic 0** albo **Antic 2**. Taki program możemy łatwo wykraść naszemu komputerowi. Ja to zrobię za pmocą **Atari800** wchodząc w trybie tekstowym do monitora emulatora:

```
dlist
9C20: 3x 8 BLANK
9C23: LMS 9C40 MODE 2
9C26: 23x MODE 2
9C3D: JVB 9C20
```

Jak widać emulator podaje, że aktywna **DL** mieści się pod adresem `$9c20` do `$9c3f`, pamięć ekranu (**LMS**) pobierana jest od adresu `$9c40` rozpoczyna się trzema wierszami pustymi (24 linie skaningowe `$70 $70 $70`) i składa z 24 wierszy trybu **ANTIC 2** `$2` (każdy po 8 linii skaningowych) i kończy skokiem **JVB** `$41` do początku **DL**, ze skokiem poczekamy do przerwania **VBL**. Reasumując: klasyczny ekran 40x24 znaki.

Z ważnych informacji nalezy jeszcze wspomnieć, że **DL**:
* nie może być dłuższa niż **1KB**
* 16-bit licznik pobieranie rozkazów zmienia tylko dziesięć najmłodszych bitów w związku z tym po przekroczeniu granicy **1KB** pobieranie dalszych rozkazów **DL** jest kontynuowane od początku bloku **1KB**
* licznik **LMS** jest **12-bit**, więc zadresować jako pamięc ekranu możemy jednorazowo tylko **4KB**, z tego powodu np. w trybie **ANTIC F** instrukcja **LMS** pojawia zazwyczaj dwukrotnie.

Nie pozostaje nam nic innego jak napisać własną bibliotekę graficzną zapewniająca nam ten tryb graficzny. Do dzieła :]

## Warsztaty ;)

Reorganizacja kodu: wynosimy z *libki* `sys` rejestry sprzętowe do osobnej biblioteki `registers`:

```pascal
unit registers;

interface

var
  PORTB  : byte absolute $D301;
  SDLSTL : word absolute $d402;
  NMIEN  : byte absolute $D40E;
  DLIST  : word absolute $D402;
  NMIVEC : word absolute $FFFA;

implementation
end.
```

Teraz piszemy naszą bibliotekę graficzną:

```pascal
unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

const gameLms = $e000;

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

const
  dl2: array [0..31] of byte = (
    $70,$70,$70,
    $42,lo(gameLms),hi(gameLms),
    2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,
    $41,lo(word(@dl2)),hi(word(@dl2))
  );

procedure mode2;
begin
  pause; SDLSTL := word(@dl2);
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
```

I spinamy wszystko w całość:

```pascal
{$librarypath 'lib'}

program Game;

uses registers, gr, sys;

var counter: byte absolute 0;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

begin
  systemOff; mode2;
  repeat until false;
end.
```

Budujemy skryptem naszą grę, uruchamiamy main.xex i w *debug* sprawdzamy naszą aktywną **DL** poleceniem `DLIST`:

```
2000: 3x 8 BLANK
2003: LMS E000 MODE 2
2006: 23x MODE 2
201D: JVB 2000
```

Wygląda, że wszystko gra :]

O czym warto wspomnięć? Może o tym, że jak dokonujemy jakichś zmian widocznych na ekranie warto poczekać na przerwanie **VBL** by np. niechcący nie zmienić trybu graficznego w połowie ekranu, co może się zdarzyć gdy korzystamy z rejstrów sprzętowych zamiast rejestów **cieni** (rejestrów **cieni** nie będę omawiał bo programujemy bez systemu) w tym celu używamy procedury `pause` która czeka na zmianę `RTCLOK` a ta jak widzieliśmy w procedrzue `nmi` następuje zaraz po wywołaniu przerwania **VBL**.

Wyłączyliśmy **OS** dlatego na pamięć ekranu mogliśmy przeznaczyć obszar w którym zazwyczaj znajdują się fonty systemowe `$e000`, fajnie nie?

Funkcje `lo(gameLms)` i `hi(gameLms)` zwracają nam odpowienio *młodszy* i *starszy* bajt naszego **LMS**.

Aby zastosować się do restrykcji związanych z programem **DL** zadbaliśmy by biblioteka `gr` kompilowana była jako pierwsza a **DL** jako pierwsza statyczna tablica, dzięki temu - jak widzimy - znajduje się ona na samym początku naszego kodu, czyli w tym przypadku od adresu `$2000`.

## Słowniczek pojęć:

* [**ANTIC**](http://atariki.krap.pl/index.php/ANTIC_%28uk%C5%82ad%29)
>Alpha-Numeric Television Interface Controller - układ scalony montowany w ośmiobitowych komputerach Atari i w konsolach 5200, zaprojektowany w 1978 roku. Zawiera 8100 tranzystorów.

* [**Display List**](http://atariki.krap.pl/index.php/ANTIC_Display_List)
>Display List (DL) jest programem wyświetlania dla procesora graficznego ANTIC, stosowanego w Atari 8-bit.

* **LMS**
>Rozkazem ładowania wskaźnika pamięci ekranu (LMS - Load Memory Scan) może być każdy z rozkazów tworzenia linii trybu. Uzyskuje się to przez ustawienie bitu 6 kodu rozkazu oraz podanie adresu danych obrazu w dwóch następnych bajtach. W efekcie dane obrazu nie muszą być odłożone w pamięci sekwencyjnie - wystarczy, żeby sekwencję stanowiły bajty składające się na pojedynczą linię obrazu.

* **DL JMP/JVB**
>$01 jest to rozkaz skoku JMP pod adres podany w następnych dwóch bajtach Display List. Rozkaz ten tworzy oprócz tego - przed skokiem - jedną pustą linię obrazu. Ustawienie bitu 7 powoduje jeszcze wygenerowanie przerwania DLI, natomiast ustawienie bitu 6 przekształca rozkaz JMP w JVB (Jump and wait for Vertical Blank). Różnica jest taka, że po wykonaniu skoku JVB ANTIC czeka z wykonywaniem dalszych rozkazów na impuls synchronizacji pionowej. Rozkaz taki - skoku z oczekiwaniem na synchronizację pionową - powinien kończyć Display List i jednocześnie "uruchamiać" ją od początku.