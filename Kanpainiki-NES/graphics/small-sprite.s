;  76543210
;  |||   ||
;  |||   ++- Color Palette of sprite.  Choose which set of 4 from the 16 colors to use
;  |||
;  ||+------ Priority (0: in front of background; 1: behind background)
;  |+------- Flip sprite horizontally
;  +-------- Flip sprite vertically

;0000 0000
; SPRITE:
;     ;Y POS, SPRITE ADDRESS, ATTR, X POS
;     .byte $40, $20, $40, $40
;     .byte $40, $20, $00, $48
;     .byte $48, $21, $00, $48
;     .byte $48, $21, $40, $40
;     .byte $50, $22, $00, $40
;     .byte $50, $23, $00, $48
;     .byte $50, $50, $00, $32

SPRITENEW:
    ;Y POS, SPRITE ADDRESS, ATTR, X POS
    .byte $40, $20, $40, $40
    .byte $40, $20, $00, $48
    .byte $48, $21, $00, $48
    .byte $48, $21, $40, $40
    .byte $50, $40, $00, $44
    .byte $4F, $50, $00, $40

SPRITEWALK:
    .byte $48, $40, $00, $48
    .byte $48, $41, $40, $40
    .byte $50, $40, $00, $40
    .byte $50, $41, $00, $48    

EARTWITCH:
    .byte $40, $70, $40, $40 ; FRAME 1
    .byte $40, $71, $40, $40 ; FRAME 2

TAILWAG:
    .byte $40, $50, $00, $40 ; FRAME 1
    .byte $40, $51, $00, $40 ; FRAME 2
    .byte $40, $52, $00, $40 ; FRAME 3