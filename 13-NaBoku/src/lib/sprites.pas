unit sprites;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  joyDirection: byte absolute 3;

procedure init;
procedure moveShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers;

const
{$i inc/const.inc}

var
  bHposp0    : byte absolute 0;
  bHposp1    : byte absolute 1;
  bShipY     : byte absolute 2;
  b01i       : byte absolute $fe;
  wShipX     : word absolute 0;

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

procedure moveShip;
var bMask: byte absolute $ff;
begin
  bMask := %1100;
  for b01i := 1 downto 0 do begin
    case (joyDirection and bMask) of
      JOY_RIGHT: begin
        if bHposp1 < SHIP_RIGHT_LIMIT then begin
          Inc(wShipX,$0101); HPOSP01 := wShipX;
        end;
      end;
      JOY_LEFT: begin
        if bHposp0 > SHIP_LEFT_LIMIT then begin
          Dec(wShipX,$0101); HPOSP01 := wShipX;
        end;
      end;
      JOY_UP: begin
        if bShipY > SHIP_TOP_LIMIT then begin
          Dec(bShipY); copyShip;
        end;
      end;
      JOY_DOWN: begin
        if bShipY < SHIP_BOTTOM_LIMIT then begin
          Inc(bShipY); copyShip;
        end;
      end;
    end;
    bMask := %0011;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
