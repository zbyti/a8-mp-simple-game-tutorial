{$librarypath 'lib'}

{$r res/gr.rc}
{$r res/gfx.rc}

program Game;

uses registers, sys, gr, sprites;

const
{$i inc/const.inc}


var
  b01i   : byte absolute $fe;
  aStars : array[0..124] of byte absolute $1200;
  aSpeed : array[0..124] of byte absolute $127d;
  pJoy, pStars : pointer;

procedure vbi; interrupt;
begin
  asm { phr };
  asm { plr };
end;

procedure joy; interrupt;
begin
  asm { phr };

  joyDirection := PORTA;
  if (joyDirection and %1111) <> %1111 then moveShip;

  setDli(pStars);

  asm { plr };
end;

procedure stars; interrupt;
begin
  asm { phr };

  for b01i := 124 downto 0 do begin
    asm { sta WSYNC };
    HPOSM3 := aStars[b01i];
    Dec(aStars[b01i],aSpeed[b01i]);
    COLPM3 := RND;
  end;

  setDli(pJoy);

  asm { plr };
end;

procedure init;
begin
  Pause; DMACTL := 0; systemOff;

  FillByte(pointer(GAME_LMS), $3c0, 0);

  for b01i := 124 downto 0 do begin
     aStars[b01i] := RND;
     aSpeed[b01i] := (RND and 3) + 1;
  end;

  sprites.init;
  mode2; COLBK := 0; COLPF2 := 2;
  PACTL := PACTL or %100;
  pJoy := @joy; pStars := @stars;

  setVbi(@vbi);
  setDli(@joy);

  Pause; DMACTL := %111110;
end;

begin
  init;
  repeat until false;
end.
