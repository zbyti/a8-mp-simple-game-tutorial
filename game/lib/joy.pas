unit joy;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  joyDirection  : byte absolute 6;

procedure moveShip;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses globals, sprites;

procedure moveShip;
begin
  asm { sta WSYNC }; COLBK := 15;
  bTmp1 := %1100;
  for b1i := 1 downto 0 do begin
    case (joyDirection and bTmp1) of
      JOY_RIGHT: begin
        if bHposp1 < SHIP_RIGHT_LIMIT then begin
          Inc(wShipX,SHIP_X_STEP); HPOSP01 := wShipX;
          if oddCounter then Inc(bCannonX);
        end;
      end;
      JOY_LEFT: begin
        if bHposp0 > SHIP_LEFT_LIMIT then begin
          Dec(wShipX,SHIP_X_STEP); HPOSP01 := wShipX;
          if oddCounter then Dec(bCannonX);
        end;
      end;
      JOY_UP: begin
        if bShipY > SHIP_TOP_LIMIT then begin
          Dec(bShipY,SHIP_Y_STEP); Dec(wCannonY,20);
          copyShip;
        end;
      end;
      JOY_DOWN: begin
        if bShipY < SHIP_BOTTOM_LIMIT then begin
          Inc(bShipY,SHIP_Y_STEP); Inc(wCannonY,20);
          copyShip;
        end;
      end;
    end;
    bTmp1 := %0011;
  end;
  COLBK := 0;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
