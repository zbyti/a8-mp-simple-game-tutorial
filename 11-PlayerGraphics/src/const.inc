PM_ADR              = $1000;          // players & missiles memory (2K) start address
M0_ADR              = PM_ADR + $300;  // missile 0 start memory address
P0_ADR              = PM_ADR + $400;  // player 0 start memory address
P1_ADR              = PM_ADR + $500;  // player 1 start memory address
GFX_SHIP_ADR        = $1000;          // ship gfx memory start address, ship size = 20 bytes, 16 bytes for gfx and 4 bytes fo top/bottom empty rows
GFX_SHIP_SEG        = 10;             // ship gfx 10 byte segment, 10B for P0 & 10B for P1
DL_2                = $1800;          // display list memory start address for ANTIC mode 2
GAME_LMS            = $e000;          // Load Memory Scan address