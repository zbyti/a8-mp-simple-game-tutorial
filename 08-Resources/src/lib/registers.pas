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