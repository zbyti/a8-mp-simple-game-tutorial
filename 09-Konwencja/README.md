# 9. Konwencja

Przed następnym rozdziałem naszej podróży sądzę, że nastał czas na podsumowanie konwencji nazewniczej jaka wykrystalizowa się podczas pisania dotychczasowego kodu. Od tej pory będziemy się ję trzymać, myślę, że ułatwi nam to czytanie kodu nawet gdy za narzędzie będzie służył tylko prosty notatnik.

## Zmienne

Nazwy zmiennych zadeklarowanych przez nas będziemy pisać za pomocą [camelCase](https://en.wikipedia.org/wiki/Camel_case) w następujący sposób:

* pierwsza litera będzie zawsze pierwszą literą zadeklarowanego typu np.:
  * **b** `byte`
  * **w** `word`
  * **p** `pointer`
  * **a** `array`
  * **s** `string`
* interatory pomocnicze będziemy kończyć literką **i** po jego numerze porządkowym np: `b01i` lub `w03i`.

Nie widzę powodu by trzymać się tej konwecji dla parametrów procedur i funkcji ale jeżeli chcesz to proszę bardzo :] Ja na komputerze 8-bit będę posługiwał się raczej zmiennymi globalnymi niż parametrami **proc/func** i zwracanymi przez **func** wartościami, trzeba być jednak elastycznym i bez potrzeby nie zaciemniać kodu posługując się tylko zmiennymi globalnymi.

Niektóre rjestry są tylko do zapisu inne tylko do odczytu i nie da się w nich trzymać jakiegoś stanu, np. położenia horyzontalnego gracza czy pocisku.

## Rejestry

Etykiety rejestrów piszemy zawsze kapitalikami zgodnie z nazywnictwem przyjętym w [Mapping The Atari](https://www.atariarchives.org/mapping/memorymap.php) np.:

```pascal
COLPF1  : byte absolute $D017;  // Color and luminance of playfield one
COLPF2  : byte absolute $D018;  // Color and luminance of playfield two
COLBK   : byte absolute $D01A;  // Color and luminance of the background (BAK)
```

## Stałe

Nazwy stałych tak jak etykiety rejestrów również piszemy kapitalikami przy czym w nazwie powinno występować przynajmniej jedno podkreślenie `_` np.:

```pascal
const
  M_OFFSET            = $300;   // missile memory offset
  P0_OFFSET           = $400;   // player 0 memory offset
  P1_OFFSET           = $500;   // player 1 memory offset
```

Dzięki temu już na pierwszy rzut oka będziemy wiedzieli, że dla tej *etykiety* nie można wykonać operacji przypisania `:=`.

## Nazwy procedur i funkcji

* **proc/func** dostarczane przez **Mad Pascal** piszemy **CamelCase** np.:

```pascal
FillByte(pointer(PM_ADR + M_OFFSET), $800 - M_OFFSET, 0);
Move(pointer(P_SHIP_ADR), pointer(PM_ADR + P0_OFFSET), P_SHIP_SEG);
```

* **proc/func** pisane przez nas będzemy pisać za pomocą **camelCase** np.:

```pascal
procedure systemOff;
begin
  pause; asm { sei };
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $40;
end;
```

## Bloki kodu

Osobiście kod nie zawsze najlepiej czyta mi się w *słupku* dlatego jak w powyższym przykładzie tam gdzie nie ma istotnej logiki, trudnej implementacji, czy coś po prostu jest jednorazowo ustawiane albo instrukcje są w logicznym następstwie będę czasem pisał jak poniżej:

```pascal
systemOff; DMACTL := 0;

PMBASE := hi(PM_ADR);
hposp0 := 44; hposp1 := 52; HPOSP01 := shipHpos;
COLPM01 := $0f0f; SIZEP01 := 0; PRIOR := 0; GRACTL := %00000011;

pause; DMACTL := %00111110; setVbi(@vbi);
```

Pusty wiersz separuje linie kodu z różnych przyczyn, akurat w tym przypadku chcę tym podkreślić, że po `systemOff; DMACTL := 0;` zaczynam pracę przy wyłączonym systemie i wyłączonym **ANTIC** czyli wprowadziłem komputer w stan w którym mogę przygotować dane swojego programu, przygotować tryb graficzny etc. bez ryzyka, że będą tego jakieś widoczne ślady na ekranie, do tego dysponując o około 30% większą mocą **CPU** nie wstrzymywanego przez pracjący procesor graficzny.

Na pewno istotnych części kodu lub implementacji algorytmów, które trzeba zrozumieć nie będę pisał w tak zwarty sposób.


