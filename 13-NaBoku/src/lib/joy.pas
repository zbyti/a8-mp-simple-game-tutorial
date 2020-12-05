unit joy;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  joyDirection: byte absolute 3;

procedure moveShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers, sprites;

procedure moveShip;
begin
  bMask1 := %1100;
  for b1i := 1 downto 0 do begin
    case (joyDirection and bMask1) of
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
    bMask1 := %0011;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
