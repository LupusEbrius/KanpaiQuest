
;  76543210
;  |||   ||
;  |||   ++- Color Palette of sprite.  Choose which set of 4 from the 16 colors to use
;  |||
;  ||+------ Priority (0: in front of background; 1: behind background)
;  |+------- Flip sprite horizontally
;  +-------- Flip sprite vertically

;0000 0000
SPRITE:
    ;Y POS, SPRITE ADDRESS, ATTR, X POS
    .byte $40, $10, $0B, $40
    .byte $40, $11, $0B, $48
    .byte $48, $12, $00, $48
    .byte $48, $12, $40, $40
    .byte $50, $13, $01, $40
    .byte $50, $14, $01, $48
    .byte $58, $15, $0A, $40
    .byte $58, $16, $0B, $48
    .byte $60, $17, $0A, $40
    .byte $60, $18, $0A, $48
