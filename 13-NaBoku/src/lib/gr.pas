unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

procedure mode2;
begin
  DLIST := DL_2;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
