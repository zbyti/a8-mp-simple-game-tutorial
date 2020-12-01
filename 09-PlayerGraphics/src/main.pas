{$librarypath 'lib'}

program Game;

uses registers, gr, sys;

const
{$i const.inc}
{$r res/gfx.rc}

var
  pm0_x   : byte absolute 0;
  pm1_x   : byte absolute 1;
  pm_x    : word absolute 0;


procedure vbi; interrupt;
begin
  asm { phr };

  inc(pm0_x); inc(pm1_x); HPOSP := pm_x;

  asm { plr };
end;

procedure init;
begin
  systemOff; DMACTL := 0;

  pm0_x := 44;
  pm1_x := 52;

  PMBASE := hi(PMG_ADDRESS);
  SIZEP0 := 0; SIZEP1 := 0;
  HPOSP0 := pm0_x; HPOSP1 := pm1_x;
  COLPM0 := $0f; COLPM1 := $0f;
  GRACTL := %00000011;
  PRIOR  := 0;

  FillByte(pointer(PMG_ADDRESS + MISSILES_OFFSET), $800 - MISSILES_OFFSET, 0);
  Move(pointer(PLAYER_SHIP_ADDRESS), pointer(PMG_ADDRESS + PLAYER0_OFFSET), PLAYER_SHIP_SEG);
  Move(pointer(PLAYER_SHIP_ADDRESS + PLAYER_SHIP_SEG), pointer(PMG_ADDRESS + PLAYER1_OFFSET), PLAYER_SHIP_SEG);

  pause; DMACTL := %00111110; setVbi(@vbi);
end;

begin
  init;
  repeat until false;
end.
