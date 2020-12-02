M_OFFSET            = $308;   // missile memory offset
P0_OFFSET           = $408;   // player 0 memory offset
P1_OFFSET           = $508;   // player 1 memory offset
PM_ADR              = $1000;  // player & missile memory 2K start address
P_SHIP_ADR          = $1000;  // player ship memory start address, ship size = 20 bytes, 16 bytes for gfx and 4 bytes fo top/bottom empty rows
P_SHIP_SEG          = 10;     // player ship 10 byte segment, 10 bytes for P0 & 10 for P1
DL_2                = $1800;  // display list memory start address for ANTIC mode 2
GAME_LMS            = $e000;  // Load Memory Scan address
