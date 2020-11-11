# 4. System Off - teoria

## Gawęda

Czas na mała lobotomię, materiał podzieliłem na dwie części: teoretyczną i praktyczną.

Może zauważyłeś, że nasz komputer ma 64KB pamięci podstawowej ale Dr. Frankenstein by go ożywić wszczepił mu fałszywe wspomnienia pod postacią *systemu operacyjnego* i sporo z tej pamięci zajął dla siebie. Teraz nasza kolej na małą incepcję :D

O ile odzyskanie pamięci od adresu $a000-$bfff jest względnie łatwe bo można komputer uruchomić w takim trybie (z wyłączonym Basic-iem) to oduczenie go jak żyć *po staremu* nastręcza trochę więcej pracy - całe szczęście niezbyt dużo :]

Wyłączenie **OS** i niekorzystanie z DOS-u sprawi, że nie tylko zaoszczędzimy wiele pamięci ale także sporów z konserwatywnymi jak i nowoczesnymi Atarowcami ;P

O ile bez OS można się śmiało obejść to DOS bywa potrzebny. Jeżeli jednak napiszesz już tak dużą grę na A8, że będziesz miał potrzebę coś doczytać czy zapisać to jestem przekonany, że sam już sobie poradzisz - ja nie zamierzam dotrzeć do takiego punktu, wspomnę tylko, że wtedy z odsieczą przyjdą wam specjalne DOS-y napisane przez Fox'a czy XXL'a.

## Do rzeczy

Jeżeli byłeś dociekliwy to mogłeś zobaczyć, że w części trzeciej pojawił się katalog **src** w którym znajdują się źródła naszej gry (będą one systematycznie przyrastać). Odpalmy skrypt build i zobaczmy *co da się zobaczyć*:

```
./build
Mad Pascal Compiler version 1.6.5 [2020/11/03] for 6502
Compiling main.pas
7 lines compiled, 0.61 sec, 4884 tokens, 389 idents, 155 blocks, 5 types
ZPAGE: $0080..$00D7
RTLIB: $2000..$1FFF
SYSTEM: $2030..$2033
CODE: $2000..$204C
DATA: $204D..$2058
Writing listing file...
Writing object file...
7111 lines of source assembled in 4 pass
95 bytes written to the object file
```

zainteresujmy się **ZPAGE** i **CODE**:

* **ZPAGE** informuje nas ile pamięci na stronie zerowej zajmuje Mad Pascal na swoje zmienne i gdzie są one umiejscowione.
* **CODE** informuje nas od którego adresu zaczynają się dane naszego programu.

Dlaczego takie wartości a nie inne, dlaczego `$2000` a nie np. `$a00` albo `$80` zamiast `0`? Otóż dlatego, że ktoś tak przed nami ponakręcał te zegary, że wolne adresy zaczynają się na stronie zerowej dopiero od `$80` a najpopularniejsze DOS-y zabierają pamięć często aż do `$2000`. Jednym słowem **marnotrawstwo** zwłaszcza z puntu widzenia programisty gier na 8-bit platformę! :D

Co więcej, komórki na stronie zerowej są ważne bo pozwalają nam na najszybszą z możliwych operację na pamięci, adres jest wtedy 8-bitowy a nie 16-sto. W związku z tym postarajmy się je odzyskać dla siebie, skoro jednak odbierzemy tę pamięć naszemu **OS** to na cóż nam i on sam? Słusznie... Też go wyrzućmy na śmietnik historii :]

Jaką mapę pamięci chcemy dla siebie osiągnąć zaraz **po** starcie naszego programu? Jak wygląda nasza Atarowska *tabula rasa*?

* `$0 - $ff` strona zerowa, cała dla nas (!) za wyjątkiem zmiennych **MP**
* `$100 - $1ff` stos procesora, nie dotykamy!
* `$200 - $cfff` wolne
* `$d000 - $d7ff` rejestry sprzętowe
* `$d800 - $fff9` wolne

W skrócie: gdy już załadujemy nasz program za pomocą np. jakiegoś micro DOS-u i przejmiemy kontrolę nad komputerem to niedostępne dla naszego programu powinna być już tylko przestrzeń zarezerwowana na **stos**, **rejestry sprzętowe** i **ostatnie 6 bajtów** gdzie znajdują się ważne wektory.

Jak wyłączyć system komputera Atari w praktyce dowiesz się w następnej części.

## Słowniczek pojęć:

* [**Mapa pamięci**](http://atariki.krap.pl/index.php/Mapa_pami%C4%99ci)
>"Mapa pamięci" to wyszczególnione i opisane obszary pamięci komputera, czyli do czego służy, co robi konkretna komórka, rejestr lub obszar pamięci.
* [**Strona zerowa**](http://atariki.krap.pl/index.php/Strona_zerowa)
>Obszar pamięci $0000-$00FF, mający dla procesorów z rodziny 65xx specyficzne, 'sprzętowe' znaczenie, ze względu na istnienie oddzielnego trybu adresowania "strony zerowej", szybszego niż adresowanie reszty pamięci. Na stronie zerowej typowo umieszcza się wskaźniki, gdyż wymagają tego prawie wszystkie (oprócz JMP) rozkazy działające w pośrednim trybie adresowania.
* [**Stos**](http://atariki.krap.pl/index.php/6502)
>W przestrzeni adresowej 6502 jest wyróżniony obszar przeznaczony na stos - jest to obszar od $0100 do $01FF.
* **Rejestry**
  * [ANTIC](http://atariki.krap.pl/index.php/Rejestry_ANTIC-a)
  * [GTIA](http://atariki.krap.pl/index.php/Rejestry_GTIA)
  * [PIA](http://atariki.krap.pl/index.php/Rejestry_PIA)
  * [POKEY](http://atariki.krap.pl/index.php/Rejestry_POKEY-a)
  * [inne](http://atariki.krap.pl/index.php/Kategoria:Programowanie_Atari_8-bit)
