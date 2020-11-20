    icl 'const.inc'

dl2
:3  .BYTE $70
    .BYTE $42,A(GAME_LMS)
:23 .BYTE 2
    .BYTE $41,A(dl2)
