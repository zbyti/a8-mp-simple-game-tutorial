# 6. UNIT

Skoro już wszystko wiemy czas na mała reorganizację kodu.

Mad Pascal zapewnia grupowanie kodu w **UNIT** co daje nam możliwość dość elastycznego budowania włsnych bibliotek dla tego języka oraz odrębną przestrzeń nazw. Po szczegóły odsyłam do dokumetacji Free Pascala lub Mad Pascal.

Nasz kod wyglądą tak:

```pascal
unit sys;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  PORTB  : byte absolute $D301;
  NMIEN  : byte absolute $D40E;
  DLIST  : word absolute $D402;
  NMIVEC : word absolute $FFFA;

  procedure systemOff;
  procedure setVbi(a: pointer); assembler;
  procedure setDli(a: pointer); assembler;
  procedure resetVbi; assembler;
  procedure resetDli; assembler;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

procedure nmi; assembler; interrupt;
asm
{
      bit NMIST \ bpl vbi   ; check kind of interrupt
.def  :__dlijmp
      jmp __off               ; VDSLST
vbi:  inc RTCLOK+2
.def  :__vbijmp
      jmp __off               ; VBIVEC
.def  :__off
};
end;

procedure setVbi(a: pointer); assembler;
asm
{
  mwa a __vbijmp+1
};
end;

procedure setDli(a: pointer); assembler;
asm
{
  mwa a __dlijmp+1
};
end;

procedure resetVbi; assembler;
asm
{
  mwa __off __vbijmp+1
};
end;

procedure resetDli; assembler;
asm
{
  mwa __off __dlijmp+1
};
end;

procedure systemOff;
begin
  asm { sei };
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $40;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
```

Wyróżnić możemy trzy części naszej biblioteki:
* **interfejs** tutaj deklaujemy stałe, zmienne i procedury jakie nasza biblioteka `sys` *wystawia* na *świat*.
* **implementacja** obowiązkowo należy tutaj napisać procedury i funckje które zadeklarowaliśmy w interfejsie ale można również zadeklarować stałe, zmienne oraz napisać procedury i funckje pomocnicze, niewidoczne na zewnątrz biblioteki.
* **initcjalizacja** możemy nadać wartość początkową pewnym zmiennym itd.

Oczywiście powyższe zmienne **NMIWN** itd. nie muszą być *publiczne* ale z powodu świadomej rezygnacji z dostarczanego przez **MP** unitu `atari` rejestry sprzętowe postanowiłem na wszelki wypadek pozostawić gotowe do użycia bez ponownej ich deklaracji, nawet jak do ich obsługi napisane są odpowiednie procedury i funkcje.

Jak widzimy są tutaj wszystkie elementy niezbędne aby wygodnie wyłączyć system i zarządzać przerwaniami **NMI**. Możliwe, że to mogą być już wszystkie wstawki *asm* w naszej przyszłej grze, dla porządku wspomnę czym jest to na co patrzysz:

* `.def  :__dlijmp` deklaracja etykiety globalnej widzianej przez **MADS**, dla odróżnienia od etykiet lokalnych można nazwę rozpocząć od `__`
* `mwa a __vbijmp+1` makro przepisujące daną dwubajtową `word` z jednego adresu w pamięci pod inny, w naszym przypadku adres na który wskazuje `a` pod adres oznaczony etykietą `__vbijmp` zwiększoną o `1` by pominąc rozkaz `jmp`

## Kod główny

```pascal
{$librarypath 'lib'}

program Game;

uses sys;

var counter: byte absolute 0;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

begin
  systemOff;
  pause(100);
  setVbi(@vbi);
  repeat until false;
end.
```

Tutaj na uwagę zasługuje tylko dyrektywa `{$librarypath ...}`, która dołącza wskazany katalog do ścieżek przeszukiwanych przez kompilator.

Słowo kluczowe `uses` jak się zapewne domyśliłeś pozwala nam skorzystać z naszej bibioteki `sys`.
