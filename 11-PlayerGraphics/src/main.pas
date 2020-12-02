{$librarypath 'lib'}

program Game;

uses registers, gr, sys;

const
{$i const.inc}
{$r res/gfx.rc}

var
  hposp0    : byte absolute 0;
  hposp1    : byte absolute 1;
  wShipHpos : word absolute 0;


procedure vbi; interrupt;
begin
  asm { phr };

  Inc(hposp0); Inc(hposp1); HPOSP01 := wShipHpos;

  asm { plr };
end;

procedure init;
begin
  systemOff; DMACTL := 0;

  PMBASE := hi(PM_ADR);
  hposp0 := 44; hposp1 := 52; HPOSP01 := wShipHpos;
  COLPM01 := $0f0f; SIZEP01 := 0; PRIOR := 0; GRACTL := %00000011;

  FillByte(pointer(M0_ADR), $500, 0);
  Move(pointer(GFX_SHIP_ADR), pointer(P0_ADR + 8), GFX_SHIP_SEG);
  Move(pointer(GFX_SHIP_ADR + GFX_SHIP_SEG), pointer(P1_ADR + 8), GFX_SHIP_SEG);

  pause; DMACTL := %00111110; setVbi(@vbi);
end;

begin
  init;
  repeat until false;
end.
