unit registers;

interface

var
  RTCLOK  : byte absolute $14;
  HPOSP0  : byte absolute $D000;  // (W) Horizontal position of player 0
  HPOSP1  : byte absolute $D001;  // (W) Horizontal position of player 1
  SIZEP0  : byte absolute $D008;  // (W) Size of player 0
  SIZEP1  : byte absolute $D009;  // (W) Size of player 1
  COLPM0  : byte absolute $D012;  // (W) Color and luminance of player and missile 0
  COLPM1  : byte absolute $D013;  // (W) Color and luminance of player and missile 1
  COLPF1  : byte absolute $D017;  // Color and luminance of playfield one
  COLPF2  : byte absolute $D018;  // Color and luminance of playfield two
  COLBK   : byte absolute $D01A;  // Color and luminance of the background (BAK)
  PRIOR   : byte absolute $D01B;  // (W) Priority selection register
  GRACTL  : byte absolute $D01D;  // (W) Used with DMACTL to latch all stick and paddle triggers
  RND     : byte absolute $D20A;  // (R) When this location is read, it acts as a random number generator
  PORTA   : byte absolute $D300;  // (W/R) Reads or writes data from controller jacks one and two if BIT 2 of PACTL is one. Writes to direction control if BIT 2 of PACTL is zero.
  PORTB   : byte absolute $D301;  // (W/R) Port B. Reads or writes data to and/or from jacks three and four
  PACTL   : byte absolute $D302;  // (W/R) Port A controller.
  DMACTL  : byte absolute $D400;  // (W) Direct Memory Access (DMA) control
  DLIST   : word absolute $D402;  // Display list pointer
  PMBASE  : byte absolute $D407;  // (W) MSB of the player/missile base address used to locate the graphics for your players and missiles
  WSYNC   : byte absolute $D40A;  // (W) Wait for horizontal synchronization.
  NMIEN   : byte absolute $D40E;  // (W) Non-maskable interrupt (NMI) enable
  NMIVEC  : word absolute $FFFA;  // The NMI interrupts are vectored through 65530 ($FFFA) to the NMI service routine

  HPOSP01 : word absolute $D000;
  SIZEP01 : word absolute $D008;
  COLPM01 : word absolute $D012;

implementation
end.
