unit gr;

//---------------------- INTERFACE ---------------------------------------------

interface

const
{$i const.inc}
{$r res/gr.rc}

procedure mode2;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

procedure mode2;
begin
  pause; DLIST := DL_2;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
