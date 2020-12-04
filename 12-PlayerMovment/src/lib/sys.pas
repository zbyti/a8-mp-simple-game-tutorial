unit sys;

//---------------------- INTERFACE ---------------------------------------------

interface

procedure systemOff;
procedure setVbi(a: pointer); assembler;
procedure setDli(a: pointer); assembler;
procedure resetVbi; assembler;
procedure resetDli; assembler;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

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
  pause; asm { sei };
  NMIEN := 0; PORTB := $FE; NMIVEC := word(@nmi); NMIEN := $40;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
