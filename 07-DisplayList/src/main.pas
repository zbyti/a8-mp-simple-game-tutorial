{$librarypath 'lib'}

program Game;

uses registers, gr, sys;

var counter: byte absolute 0;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

begin
  systemOff; mode2;
  repeat until false;
end.
