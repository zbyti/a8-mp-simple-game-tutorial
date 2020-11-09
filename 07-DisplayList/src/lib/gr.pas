unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

const gameLms = $e000;

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

const
  dl2: array [0..31] of byte = (
    $70,$70,$70,
    $42,lo(gameLms),hi(gameLms),
    2,2,2,2,2,2,2,2,2,2,2,2,
    2,2,2,2,2,2,2,2,2,2,2,
    $41,lo(word(@dl2)),hi(word(@dl2))
  );

procedure mode2;
begin
  pause; SDLSTL := word(@dl2);
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
