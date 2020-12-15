{$librarypath 'lib'}

{$r res/gr.rc}
{$r res/gfx.rc}

program Game;

uses globals, sys, gr, sprites, joy;

const
{$i inc/const.inc}

var
  aStars : array[0..124] of byte absolute $1200;
  aSpeed : array[0..124] of byte absolute $127d;
  pJoy, pStars : pointer;

procedure vbi; interrupt;
begin
  asm { phr };
  //------------------> test <-------------------

  if (RTCLOK and %11) = 0 then begin
    if (TRIG0 = 0) then Poke(wDl2Lms + bCannonX + wCannonY,2);
  end;

  if wDl2Lms > GAME_LMS_END then Dec(wDl2Lms) else wDl2Lms := GAME_LMS;

  wTmp1 := wDl2Lms;

  asm {
        ldx #GAME_SCREEN_ROWS
        ldy #0
  clr:  tya
        sta (GLOBALS.WTMP1),y
        lda GLOBALS.WTMP1
        add #40
        sta GLOBALS.WTMP1
        bcc @+
        inc GLOBALS.WTMP1+1
  @:    dex
        bpl clr
  };

  //------------------> end <--------------------
  asm { plr };
end;

procedure joyHandler; interrupt;
begin
  asm { phr };

  if (RTCLOK and %1) = 0 then
    begin
      joyDirection := PORTA;
      if (joyDirection and %1111) <> %1111 then moveShip;
    end
  else moveShip;

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

  CHBAS := Hi(GFX_FONTS_ADR);

  FillByte(pointer(GAME_LMS), $3c0, 0);

  for b1i := 124 downto 0 do begin
     aStars[b1i] := RND;
     aSpeed[b1i] := (RND and 3) + 1;
  end;

  PACTL := PACTL or %100; sprites.init; mode2;
  COLBK := $00; COLPF0 := $00; COLPF1 := $0f; COLPF2 := $02; COLPF3 := $00;
  pJoy := @joyHandler; pStars := @stars;

  bCannonX := 3; wCannonY := bShipY * 3;

  setVbi(@vbi);
  setDli(@joyHandler);

  Pause; DMACTL := %111110;
end;

begin
  init;
  repeat until false;
end.
