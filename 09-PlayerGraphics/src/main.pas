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

  inc(hposp0); inc(hposp1); HPOSP := shipHpos;

  asm { plr };
end;

procedure init;
begin
  systemOff; DMACTL := 0;

  hposp0 := 44;
  hposp1 := 52;

  PMBASE := hi(PMG_ADDRESS);
  SIZEP0 := 0; SIZEP1 := 0;
  HPOSP0 := hposp0; HPOSP1 := hposp1;
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
