{$librarypath 'lib'}

{$r res/gr.rc}
{$r res/gfx.rc}

program Game;

uses registers, sys, gr, sprites;

const
{$i inc/const.inc}

procedure vbi; interrupt;
begin
  asm { phr };

  //joyDirection := PORTA;
  //if (joyDirection and %1111) <> %1111 then moveShip;

  asm { plr };
end;

procedure joy; interrupt;
begin
  asm { phr };
  asm { sta WSYNC};

  COLBK := $f;

  joyDirection := PORTA;
  if (joyDirection and %1111) <> %1111 then moveShip;

  COLBK := 0;

  asm { plr };
end;


procedure init;
begin
  Pause; DMACTL := 0;

  systemOff;
  PACTL := PACTL or %100;
  sprites.init;
  mode2;
  setVbi(@vbi);
  setDli(@joy);

  Pause; DMACTL := %111110;
end;

begin
  init;
  repeat until false;
end.
