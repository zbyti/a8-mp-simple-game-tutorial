unit registers;

interface

var
  RTCLOK  : byte absolute $14;
  HPOSP0  : byte absolute $D000;  // (W) Horizontal position of player 0
  HPOSP1  : byte absolute $D001;  // (W) Horizontal position of player 1
  HPOSM0  : byte absolute $D004;  // (W) Horizontal position of missile 0
  HPOSM1  : byte absolute $D005;  // (W) Horizontal position of missile 1
  HPOSM2  : byte absolute $D006;  // (W) Horizontal position of missile 2
  HPOSM3  : byte absolute $D007;  // (W) Horizontal position of missile 3
  SIZEP0  : byte absolute $D008;  // (W) Size of player 0
  SIZEP1  : byte absolute $D009;  // (W) Size of player 1
  SIZEP2  : byte absolute $D00A;  // (W) Size of player 2
  SIZEP3  : byte absolute $D00B;  // (W) Size of player 3
  SIZEM   : byte absolute $D00C;  // (W) Size for all missiles
  GRAFM   : byte absolute $D011;  // (W) Graphics for all missiles, not used with DMA
  COLPM0  : byte absolute $D012;  // (W) Color and luminance of player and missile 0
  COLPM1  : byte absolute $D013;  // (W) Color and luminance of player and missile 1
  COLPM2  : byte absolute $D014;  // (W) Color and luminance of player and missile 2
  COLPM3  : byte absolute $D015;  // (W) Color and luminance of player and missile 3
  COLPF1  : byte absolute $D017;  // Color and luminance of playfield one
  COLPF2  : byte absolute $D018;  // Color and luminance of playfield two
  COLBK   : byte absolute $D01A;  // Color and luminance of the background (BAK)
  PRIOR   : byte absolute $D01B;  // (W) Priority selection register
  GRACTL  : byte absolute $D01D;  // (W) Used with DMACTL to latch all stick and paddle triggers
  RND     : byte absolute $D20A;  // (R) When this location is read, it acts as a random number generator
  PORTA   : byte absolute $D300;  // (W/R) Reads or writes data from controller jacks one and two if BIT 2 of PACTL is one. Writes to direction control if BIT 2 of PACTL is zero.
  PORTB   : byte absolute $D301;  // (W/R) Port B. Reads or writes data to and/or from jacks three and four
  PACTL   : byte absolute $D302;  // (W/R) Port A controller
  DMACTL  : byte absolute $D400;  // (W) Direct Memory Access (DMA) control
  DLIST   : word absolute $D402;  // Display list pointer
  PMBASE  : byte absolute $D407;  // (W) MSB of the player/missile base address used to locate the graphics for your players and missiles
  WSYNC   : byte absolute $D40A;  // (W) Wait for horizontal synchronization
  VCOUNT  : byte absolute $D40B;  // (R) Vertical line counter. Used to keep track of which line is currently being generated on the screen
  NMIEN   : byte absolute $D40E;  // (W) Non-maskable interrupt (NMI) enable
  NMIVEC  : word absolute $FFFA;  // The NMI interrupts are vectored through 65530 ($FFFA) to the NMI service routine

  HPOSP01 : word absolute $D000;
  SIZEP01 : word absolute $D008;
  COLPM01 : word absolute $D012;

// auxiliary variables
var
  bMask01 : byte absolute $ff;
  bMask02 : byte absolute $fe;
  b01i    : byte absolute $fd;
  b02i    : byte absolute $fc;

implementation
end.
