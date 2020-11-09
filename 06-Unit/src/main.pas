{$librarypath 'lib'}

program Game;

uses sys;

var counter: byte absolute 0;

procedure vbi; interrupt;
begin
  asm { phr };
  inc(counter);
  asm { plr };
end;

begin
  systemOff;
  pause(100);
  setVbi(@vbi);
  repeat until false;
end.
