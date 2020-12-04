    icl 'inc/const.inc'

dl2
:3  .byte $70
    .byte $42,a(GAME_LMS)
:23 .byte 2
    .byte $41,a(dl2)
