# 3. Hello World

Napiszmy nasz pierwszy program na Atari:

```pascal
program Game;

begin
  repeat until false;
end.
```
To bardzo prosty kod, składa się z obowiązkowej procedury `begin ... end.` w której ciele znajdujemy wieczną pętlę `repeat ... until`.

Napiszmy sobie jeszcze prosty skrypt budujący z powyższego kodu wykonywalny plik **XEX**:

```bash
#!/bin/bash

mp="$HOME/Programs/MadPascal/mp"
mads="$HOME/Programs/mads/mads"
base="$HOME/Programs/MadPascal/base"
name="main"

$mp $name.pas -o

if [ -f $name.a65 ]; then
  [ ! -d "output" ] && mkdir output
  mv $name.a65 output/
  $mads output/$name.a65 -x -i:$base -o:output/$name.xex
else
  exit 1
fi
```

Powyższy skrypt ustawia lokalne zmienne systemowe **mp**, **mads**, **base**, **name**, które aktywne są tylko tak długo, jak długo żyje sesja terminala w którym odpaliliśmy skrypt. Wyjaśnijmy sobie co oznaczają owe zmienne:

* **mp** ścieżka do pliku binarnego kompilatora Mad Pascala
* **mads** ścieżka do pliku binarnego assemblera MADS
* **base** zestaw bibliotek niezbędnych do prawidłowej kompilacji przez MADS źródeł wygenerowanych przez MP
* **name** nazwa pliku `.pas` zawierającego nasz główny kod

Wraz z używaniem powyższe stanie się dla Ciebie bardziej jasne, na ten moment zadowólmy się, że powyższe działa :]

Po uruchomieniu skryptu w katalogu projektu pojawi się podkatalog `output`, powinieneś znaleźć w nim pliki binarny możliwy do uruchomienia na Atari `main.xex`. Pozostaje go już tylko uruchomić, np.: `atari800 output/main.xex`.

## Słowniczek pojęć:

* [**XEX**](http://atariki.krap.pl/index.php/COM)
>COM to format pliku zawierającego pliki wykonywalne dla ośmiobitowego Atari. Pliki o tym formacie występują też z rozszerzeniami EXE (głównie na Atari), oraz XEX (głównie do użycia w emulatorach). W wyniku niepełnej standaryzacji zamiennie stosuje się rozszerzenia .COM i .EXE, choć pierwotnie zakładano rozszerzenie .COM (command) dla plików rozszerzeń przeznaczonych dla procesora komend DOS-u oraz .EXE jako plików wykonywalnych (executable) czyli właściwych (użytkowych) programów.
