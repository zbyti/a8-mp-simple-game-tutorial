unit joy;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  joyDirection: byte absolute 4;

procedure moveShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses globals, sprites;

procedure moveShip;
begin
  bTmp1 := %1100;
  for b1i := 1 downto 0 do begin
    case (joyDirection and bTmp1) of
      JOY_RIGHT: begin
        if bHposp1 < SHIP_RIGHT_LIMIT then begin
          Inc(wShipX,SHIP_X_STEP); HPOSP01 := wShipX;
        end;
      end;
      JOY_LEFT: begin
        if bHposp0 > SHIP_LEFT_LIMIT then begin
          Dec(wShipX,SHIP_X_STEP); HPOSP01 := wShipX;
        end;
      end;
      JOY_UP: begin
        if bShipY > SHIP_TOP_LIMIT then begin
          bShipYClear := bShipY + 6; Dec(bShipY,2);
          copyShip;
        end;
      end;
      JOY_DOWN: begin
        if bShipY < SHIP_BOTTOM_LIMIT then begin
          bShipYClear := bShipY; Inc(bShipY,2);
          copyShip;
        end;
      end;
    end;
    bTmp1 := %0011;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
