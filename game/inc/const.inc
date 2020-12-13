PM_ADR              = $1000;                      // players & missiles memory (2K) start address
M0_ADR              = PM_ADR + $300;              // missile 0 start memory address
P0_ADR              = PM_ADR + $400;              // player 0 start memory address
P1_ADR              = PM_ADR + $500;              // player 1 start memory address
GFX_SHIP_ADR        = $1000;                      // ship gfx memory start address, ship size = 20 bytes, 16 bytes for gfx and 4 bytes fo top/bottom empty rows
GFX_SHIP_SEG        = 8;                          // ship gfx 10 byte segment, 10B for P0 & 10B for P1

SHIP_COL            = $0e0e;
SHIP_LEFT_LIMIT     = 48;
SHIP_RIGHT_LIMIT    = SHIP_LEFT_LIMIT + (16 * 8);
SHIP_TOP_LIMIT      = 32;
SHIP_BOTTOM_LIMIT   = 8 * 21;
SHIP_X_STEP         = $0202;

JOY_LEFT            = %1000;
JOY_RIGHT           = %0100;
JOY_UP              = %0010;
JOY_DOWN            = %0001;

DL_2                = $1100;                      // display list memory start address for ANTIC mode 2
GAME_LMS            = $e000;                      // Load Memory Scan address
