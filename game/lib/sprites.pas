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
        txa \ pha

        ldx #>P0_ADR
        stx GLOBALS.WTMP1+1
        inx
        stx GLOBALS.WTMP2+1

        ldx BSHIPY
        stx GLOBALS.WTMP1
        stx GLOBALS.WTMP2

        ;move
        ldy #GFX_SHIP_SEG-1
@:      mva GFX_SHIP_ADR,y (GLOBALS.WTMP1),y
        mva GFX_SHIP_ADR+GFX_SHIP_SEG,y (GLOBALS.WTMP2),y
        dey
        bpl @-

        ;clear
        lda JOY.JOYDIRECTION
        and #%0011
        cmp #JOY_DOWN
        beq @+
        txa
        add #SHIP_Y_STEP*2
        bne @+1
@:      txa
        sub #SHIP_Y_STEP
@:      sta GLOBALS.WTMP1
        sta GLOBALS.WTMP2

        lda #0
        ldy #GFX_SHIP_SEG-SHIP_Y_STEP-1
@:      sta (GLOBALS.WTMP1),y
        sta (GLOBALS.WTMP2),y
        dey
        bpl @-

        pla \ tax
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
