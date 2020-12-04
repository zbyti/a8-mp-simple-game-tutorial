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
  tmp1       : byte absolute $ff;
  tmp2       : byte absolute $fe;
  wShipX     : word absolute 0;

procedure copyShip;
begin
  Move(pointer(GFX_SHIP_ADR), pointer(P0_ADR + bShipY), GFX_SHIP_SEG);
  Move(pointer(GFX_SHIP_ADR + GFX_SHIP_SEG), pointer(P1_ADR + bShipY), GFX_SHIP_SEG);
end;

procedure init;
begin
  pause; DMACTL := 0;

  PMBASE := hi(PM_ADR);
  bShipY := 80; bHposp0 := SHIP_LEFT_LIMIT; bHposp1 := SHIP_LEFT_LIMIT + 8; HPOSP01 := wShipX;
  COLPM01 := $0f0f; SIZEP01 := 0; PRIOR := 0; GRACTL := %011;
  FillByte(pointer(M0_ADR), $500, 0); copyShip;

  pause; DMACTL := %111110;
end;

procedure moveShip;
begin
  for tmp2 := 1 downto 0 do begin
    if tmp2 > 0 then tmp1 := %1100 else tmp1 := %0011;
    case (joyDirection and tmp1) of
      %0100: begin // right
        if bHposp1 < SHIP_RIGHT_LIMIT then Inc(wShipX,$0101);
        HPOSP01 := wShipX;
      end;
      %1000: begin // left
        if bHposp0 > SHIP_LEFT_LIMIT then Dec(wShipX,$0101);
        HPOSP01 := wShipX;
      end;
      %0010: begin // up
        if bShipY > SHIP_TOP_LIMIT then Dec(bShipY);
        copyShip;
      end;
      %0001: begin // down
        if bShipY < SHIP_BOTTOM_LIMIT then Inc(bShipY);
        copyShip;
      end;
    end;
  end;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.