unit registers;

interface

var
  RTCLOK : byte absolute $14;
  HPOSP0 : byte absolute $D000;
  HPOSP1 : byte absolute $D001;
  SIZEP0 : byte absolute $D008;
  SIZEP1 : byte absolute $D009;
  COLPM0 : byte absolute $D012;
  COLPM1 : byte absolute $D013;
  COLPF1 : byte absolute $D017;
  COLPF2 : byte absolute $D018;
  COLBK  : byte absolute $D01A;
  PRIOR  : byte absolute $D01B;
  GRACTL : byte absolute $D01D;
  PORTB  : byte absolute $D301;
  DMACTL : byte absolute $D400;
  SDLSTL : word absolute $D402;
  PMBASE : byte absolute $D407;
  NMIEN  : byte absolute $D40E;
  DLIST  : word absolute $D402;
  NMIVEC : word absolute $FFFA;

  HPOSP  : word absolute $D000;

implementation
end.