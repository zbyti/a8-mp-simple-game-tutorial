program Game;

var
  PORTB  : byte absolute $D301;
  NMIEN  : byte absolute $D40E;
  DLIST  : word absolute $D402;
  NMIVEC : word absolute $FFFA;

var
  counter        : byte absolute 0;
  vbivec, vdslst : ^word;
  offrti         : word;

procedure nmi; assembler; interrupt;
asm
{
      bit NMIST \ bpl vbi   ; check kind of interrupt
      jmp off               ; VDSLST
vbi:  inc RTCLOK+2
      jmp off               ; VBIVEC
off:
};
end;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

procedure systemOff;
begin
  asm { sei };
  vdslst := pointer(word(@nmi) + 6);
  vbivec := pointer(word(@nmi) + 11);
  offrti := word(@nmi) + 13;
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $40;
end;

begin
  systemOff;
  pause(100);
  vbivec^ := word(@vbi);
  repeat until false;
end.
