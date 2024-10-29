.segment "HEADER"
    .byte "NES", $1A ;IDENTIFICATION STRING
    .byte $02   ;PRG ROM 16K UNITS
    .byte $01   ;CHR ROM 8K UNITS
    .byte $00   ;MAPPER AND MIRROR
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00


.segment "ZEROPAGE"
buttons: .res 1


.segment "STARTUP"
JOYPAD1 = $4016
JOYPAD2 = $4017

RESET:
    sei     ;disables interupts
    cld     ;turn off decimal mode

    ldx #%10000000   ;disables sound IRQ 
    stx $4017
    ldx #$00
    stx $4010      ;disables PCM

    ;init stack register
    ldx #$FF
    txs     ;transfer x to the stack

    ;Clear PPU registers
    ldx #$00
    stx $2000
    stx $2001

    ;wait for  VBLANK
:
    bit $2002
    bpl :-

    ;CLEARING 2K MEMORY
    txa 
CLEARMEMORY:
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$FF
    sta $0200, x
    lda #$00
    inx
    cpx #$00
    bne CLEARMEMORY

:
    bit $2002
    bpl :-

    ;SETTING SPRITE RANGE
    lda #$02
    sta $4014
    nop 

    lda #$3F
    sta $2006
    lda #$00
    sta $2006

    ldx #$00

LOADPALETTES:
    lda PALETTEDATA, x
    sta $2007
    inx
    cpx #$20
    bne LOADPALETTES

    lda #$3f
    sta $2006
    lda #$00
    sta $2006
    lda #$01
    sta $2007

    ldx #$00

LOADSPRITES:
    lda SPRITE, x
    sta $0200, x
    inx
    cpx #$28
    bne LOADSPRITES

;ENABLE INTERUPTS
    cli

    lda #%10010000
    sta $2000

    lda #%00011110
    sta $2001


    INFLOOP:
        jmp INFLOOP
NMI:
    LDA #$00
    STA $2003       ; set the low byte (00) of the RAM address
    lda #$02 
    sta $4014

    .include "./STATE/controller.s"
; GAMELOOP:
  
;   ; READKEYS
;   ; CHECK ENEMY HIT PLAYER
;   ;   IF YES - PLAYER DMG
;   ;       CHECK DEFEAT
;   ;         IF YES - DISPLAY GAME OVER SCREEN
;   ; CHECK PLAYER BRICK HIT ENEMY
;   ;   IF YES - ENEMY DMG
;   ; CHECK TIMER
;   ;   IF 0 - DISPLAY WIN SCREEN

;   JMP GAMELOOP
rti

.include "./graphics/palette.s"
;.include "./graphics/player-sprite.s"
.include "./graphics/small-sprite.s"

.segment "VECTORS"
    .WORD NMI
    .WORD RESET

.segment "CHARS"
    .INCBIN "GRAPHICS.CHR"
