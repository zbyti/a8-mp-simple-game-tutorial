{$librarypath 'lib'}

program Game;

uses registers, gr, sys;

const
{$i const.inc}
{$r res/gfx.rc}

var
  hposp0   : byte absolute 0;
  hposp1   : byte absolute 1;
  shipHpos : word absolute 0;


procedure vbi; interrupt;
begin
  asm { phr };

  Inc(hposp0); Inc(hposp1); HPOSP01 := shipHpos;

  asm { plr };
end;

procedure init;
begin
  systemOff; DMACTL := 0;

  PMBASE := hi(PM_ADR);
  hposp0 := 44; hposp1 := 52; HPOSP01 := shipHpos;
  COLPM01 := $0f0f; SIZEP01 := 0; PRIOR := 0; GRACTL := %00000011;

  FillByte(pointer(PM_ADR + M_OFFSET), $800 - M_OFFSET, 0);
  Move(pointer(P_SHIP_ADR), pointer(PM_ADR + P0_OFFSET), P_SHIP_SEG);
  Move(pointer(P_SHIP_ADR + P_SHIP_SEG), pointer(PM_ADR + P1_OFFSET), P_SHIP_SEG);

  pause; DMACTL := %00111110; setVbi(@vbi);
end;

begin
  init;
  repeat until false;
end.
