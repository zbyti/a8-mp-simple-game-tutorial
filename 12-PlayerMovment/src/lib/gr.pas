unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

const
{$i inc/const.inc}

procedure mode2;
begin
  pause; DLIST := DL_2;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
