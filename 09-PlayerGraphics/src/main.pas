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

  inc(hposp0); inc(hposp1); HPOSP01 := shipHpos;

  asm { plr };
end;

procedure init;
begin
  systemOff; DMACTL := 0;

  PMBASE := hi(PM_ADR);
  hposp0 := 44; hposp1 := 52; HPOSP01 := shipHpos;
  COLPM01 := $0f0f; SIZEP01 := 0; PRIOR := 0; GRACTL := %00000011;

  FillByte(pointer(PM_ADR + MISSILES_OFFSET), $800 - MISSILES_OFFSET, 0);
  Move(pointer(PLAYER_SHIP_ADDRESS), pointer(PM_ADR + PLAYER0_OFFSET), PLAYER_SHIP_SEG);
  Move(pointer(PLAYER_SHIP_ADDRESS + PLAYER_SHIP_SEG), pointer(PM_ADR + PLAYER1_OFFSET), PLAYER_SHIP_SEG);

  pause; DMACTL := %00111110; setVbi(@vbi);
end;

begin
  init;
  repeat until false;
end.
