unit sprites;

//---------------------- INTERFACE ---------------------------------------------

interface

var
  bHposp0     : byte absolute 0;
  bHposp1     : byte absolute 1;
  bShipY      : byte absolute 2;
  bCannonX    : byte absolute 3;
  wShipX      : word absolute 0;
  wCannonY    : word absolute 4;

procedure init;
procedure copyShip; assembler;

//---------------------- IMPLEMENTATION ----------------------------------------

implementation

uses globals;

procedure copyShip; assembler;
asm {
        sta WSYNC
        mva #$f COLBAK


        ldy #>P0_ADR
        sty p0Ship+2
        sty clrP0+2
        iny
        sty p1Ship+2
        sty clrP1+2

        ldy BSHIPY
        sty p0Ship+1
        sty p1Ship+1

        ;move
        ldy #GFX_SHIP_SEG-1
@:      lda GFX_SHIP_ADR,y
p0Ship: sta P0_ADR,y
        lda GFX_SHIP_ADR+GFX_SHIP_SEG,y
p1Ship: sta P1_ADR,y
        dey
        bpl @-

        ;clear
        ldy BSHIPY
        lda JOY.JOYDIRECTION
        and #%0011
        cmp #JOY_DOWN
        beq @+
        tya
        add #SHIP_Y_STEP*2
        bne @+1
@:      tya
        sub #SHIP_Y_STEP
@:      sta clrP0+1
        sta clrP1+1

        lda #0
        ldy #GFX_SHIP_SEG-SHIP_Y_STEP-1
clrP0:  sta P0_ADR,y
clrP1:  sta P1_ADR,y
        dey
        bpl clrP0

        mva #0 COLBAK

};
end;



procedure init;
begin
  FillByte(pointer(M0_ADR), $500, 0);
  FillByte(pointer(M0_ADR + 32), $90, $ff);

  PMBASE := hi(PM_ADR);
  COLPM3 := $a; COLPM01 := SHIP_COL;
  bHposp0 := SHIP_LEFT_LIMIT; bHposp1 := SHIP_LEFT_LIMIT + 8; HPOSP01 := wShipX;
  bShipY := 80; SIZEP01 := 0; SIZEM := 0; PRIOR := %0000; GRACTL := %011;

  copyShip;
end;

//---------------------- INITIALIZATION ----------------------------------------

initialization

end.
