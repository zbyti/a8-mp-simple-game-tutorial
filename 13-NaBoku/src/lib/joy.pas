unit joy;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  joyDirection: byte absolute 3;

procedure moveShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses registers, sprites;

const
{$i inc/const.inc}

procedure moveShip;
begin
  bMask01 := %1100;
  for b01i := 1 downto 0 do begin
    case (joyDirection and bMask01) of
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
    bMask01 := %0011;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
