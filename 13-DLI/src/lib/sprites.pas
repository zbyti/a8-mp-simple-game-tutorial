unit sprites;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  bHposp0    : byte absolute 0;
  bHposp1    : byte absolute 1;
  bShipY     : byte absolute 2;
  wShipX     : word absolute 0;

procedure init;
procedure copyShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses globals;

procedure copyShip;
begin
  Move(pointer(GFX_SHIP_ADR), pointer(P0_ADR + bShipY), GFX_SHIP_SEG);
  Move(pointer(GFX_SHIP_ADR + GFX_SHIP_SEG), pointer(P1_ADR + bShipY), GFX_SHIP_SEG);
end;

procedure init;
begin
  FillByte(pointer(M0_ADR), $500, 0);
  FillByte(pointer(M0_ADR + 32), $90, $ff);

  PMBASE := hi(PM_ADR);
  COLPM3 := $a; COLPM01 := SHIP_COL;
  bShipY := 80; bHposp0 := SHIP_LEFT_LIMIT; bHposp1 := SHIP_LEFT_LIMIT + 8; HPOSP01 := wShipX;
  SIZEP01 := 0; SIZEM := 0; PRIOR := %0000; GRACTL := %011;

  copyShip;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
