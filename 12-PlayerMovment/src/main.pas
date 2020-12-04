{$librarypath 'lib'}

{$r res/gr.rc}
{$r res/gfx.rc}

program Game;

uses registers, sys, sprites;

const
{$i inc/const.inc}

procedure vbi; interrupt;
begin
  asm { phr };

  if (RTCLOK and 3) = 0 then begin
    joyDirection := RND and %1111; moveShip;
  end;

  asm { plr };
end;

procedure init;
begin
  systemOff;
  sprites.init;
  setVbi(@vbi);
end;

begin
  init;
  repeat until false;
end.
