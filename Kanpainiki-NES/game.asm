.segment "HEADER"
    .byte "NES", $1A ;IDENTIFICATION STRING
    .byte $02   ;PRG ROM 16K UNITS
    .byte $01   ;CHR ROM 8K UNITS
    .byte $00   ;MAPPER AND MIRROR
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00

.segment "VECTORS"
    .addr NMI
    .addr RESET
    .addr IRQ

.segment "STARTUP"

.segment "CODE"



.segment "CHARS"
    .incbin "graphics.chr"