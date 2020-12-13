{$librarypath 'lib'}

{$r res/gr.rc}
{$r res/gfx.rc}

program Game;

uses globals, sys, gr, sprites, joy;

var
  aStars : array[0..124] of byte absolute $1200;
  aSpeed : array[0..124] of byte absolute $127d;
  pJoy, pStars : pointer;

procedure vbi; interrupt;
begin
  asm { phr };

  Poke(dl2Lms + (RND and %1111) * 40,$80); Dec(dl2Lms);
  for b1i := 21 downto 0 do Poke(dl2Lms + b1i * 40,0);

  asm { plr };
end;

procedure joyHandler; interrupt;
begin
  asm { phr };

  asm { sta WSYNC };
  COLBK := $f;

  joyDirection := PORTA;
  if (joyDirection and %1111) <> %1111 then moveShip;

  COLBK := 0;

  setDli(pStars);

  asm { plr };
end;

procedure stars; interrupt;
begin
  asm { phr };

  for b1i := 124 downto 0 do begin
    asm { sta WSYNC };
    HPOSM3 := aStars[b1i];
    Dec(aStars[b1i],aSpeed[b1i]);
    COLPM3 := RND;
  end;

  setDli(pJoy);

  asm { plr };
end;

procedure init;
begin
  Pause; DMACTL := 0; systemOff;

  FillByte(pointer(GAME_LMS), $3c0, 0);

  for b1i := 124 downto 0 do begin
     aStars[b1i] := RND;
     aSpeed[b1i] := (RND and 3) + 1;
  end;

  sprites.init;
  mode2; COLBK := 0; COLPF2 := 2;
  PACTL := PACTL or %100;
  pJoy := @joyHandler; pStars := @stars;

  setVbi(@vbi);
  setDli(@joyHandler);

  Pause; DMACTL := %111110;
end;

begin
  init;
  repeat until false;
end.
