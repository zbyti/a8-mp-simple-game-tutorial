unit sprites;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  bHposp0     : byte absolute 0;
  bHposp1     : byte absolute 1;
  bShipY      : byte absolute 2;
  bShipYClear : byte absolute 3;
  wShipX      : word absolute 0;

procedure init;
procedure copyShip; assembler;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses globals;

procedure copyShip; assembler;
//FillByte(pointer(P0_ADR + bShipYClear),GFX_SHIP_SEG,0);
//FillByte(pointer(P1_ADR + bShipYClear),GFX_SHIP_SEG,0);
//Move(pointer(GFX_SHIP_ADR), pointer(P0_ADR + bShipY), GFX_SHIP_SEG);
//Move(pointer(GFX_SHIP_ADR + GFX_SHIP_SEG), pointer(P1_ADR + bShipY), GFX_SHIP_SEG);
asm
{
    lda BSHIPYCLEAR
    sta GLOBALS.WTMP1
    sta GLOBALS.WTMP2
    lda BSHIPY
    sta GLOBALS.WTMP3
    sta GLOBALS.WTMP4

    ldx #>P0_ADR
    stx GLOBALS.WTMP1+1
    stx GLOBALS.WTMP3+1
    inx
    stx GLOBALS.WTMP2+1
    stx GLOBALS.WTMP4+1

    ;fill
    lda #0
    ldy #GFX_SHIP_SEG-SHIP_Y_STEP-1
@:  sta (GLOBALS.WTMP1),y
    sta (GLOBALS.WTMP2),y
    dey
    bpl @-

    ;move
    ldy #GFX_SHIP_SEG-1
@:  mva GFX_SHIP_ADR,y (GLOBALS.WTMP3),y
    mva GFX_SHIP_ADR+GFX_SHIP_SEG,y (GLOBALS.WTMP4),y
    dey
    bpl @-
};
end;



procedure init;
begin
  FillByte(pointer(M0_ADR), $500, 0);
  FillByte(pointer(M0_ADR + 32), $90, $ff);

  PMBASE := hi(PM_ADR);
  COLPM3 := $a; COLPM01 := SHIP_COL;
  bShipY := 80; bShipYClear := bShipY;
  bHposp0 := SHIP_LEFT_LIMIT; bHposp1 := SHIP_LEFT_LIMIT + 8; HPOSP01 := wShipX;
  SIZEP01 := 0; SIZEM := 0; PRIOR := %0000; GRACTL := %011;

  copyShip;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
