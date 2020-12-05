    icl 'inc/const.inc'

dl2
    .byte $f0,$70,$f0
    .byte $42,a(GAME_LMS)
:17 .byte 2
    .byte $41,a(dl2)
