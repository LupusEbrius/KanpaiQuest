;-------------------------------------------------------------------------------
; [$20-$2F] Core Game State
;-------------------------------------------------------------------------------
.scope Game
  ; Holds major flags for the game. Bit 7 indicates to the NMI handler that
  ; state update are complete and the VRAM can be updated. Bits 0-6 are unused.
  flags = $20
  .include "./graphics/palette.s"

  .proc init
    jsr init_palettes
    jsr init_nametable
    rts
  .endproc

  .proc init_palettes
    bit PPU_STATUS
    @loop:
        lda PALETTEDATA, x
        sta PPU_DATA
        inx
        cpx #$20
        bne @loop
    lda #$3F
    sta PPU_ADDR
    lda #$00
    sta PPU_ADDR
    lda #$01
    sta PPU_DATA
    ldx #0
    rts
;   palettes:
;     .byte $0F, $17, $18, $07    ; Grass / Dirt
;     .byte $0F, $00, $10, $30    ; Gray Stone
;     .byte $0F, $0F, $0F, $0F
;     .byte $0F, $0F, $0F, $0F
;     .byte $0F, $0B, $14, $35    ; Character
;     .byte $0F, $0F, $0F, $0F
;     .byte $0F, $0F, $0F, $0F
;     .byte $0F, $0F, $0F, $0F
  .endproc

  .proc init_nametable
    ; jsr draw_ground
    jsr draw_start_screen
    VramReset
    rts
  .endproc

  .proc draw_ground
    VramColRow 0, 25, NAMETABLE_A
    lda #$60
    jsr ppu_full_line
    lda #$61
    jsr ppu_full_line
    lda #$60
    jsr ppu_full_line
    rts
  .endproc
  
  .proc draw_start_screen
    VramColRow 0, 23, NAMETABLE_A
    lda #$45
    jsr ppu_full_line
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #$40
    sta PPU_DATA
    lda #$41
    sta PPU_DATA
    lda #$42
    sta PPU_DATA
    lda #$43
    sta PPU_DATA
    lda #$44
    sta PPU_DATA
    lda #$55
    sta PPU_DATA
    lda #$45
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #$50
    sta PPU_DATA
    lda #$51
    sta PPU_DATA
    lda #$52
    sta PPU_DATA    
    lda #$53
    sta PPU_DATA
    lda #$41
    sta PPU_DATA
    lda #$45
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #$54
    sta PPU_DATA
    lda #$46
    sta PPU_DATA
    lda #$47
    sta PPU_DATA
    lda #$41
    sta PPU_DATA
    lda #$45 
    ldx #5
    jsr ppu_fill_line
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA
    lda #$45
    ldx #28
    jsr ppu_fill_line
    lda #$45
    jsr ppu_full_line
    lda #$45
    jsr ppu_full_line
    lda #$45
    jsr ppu_full_line
    rts
  .endproc

  .proc draw_win_screen


  .endproc

.endscope

.macro SetRenderFlag
  lda #%10000000
  ora Game::flags
  sta Game::flags
.endmacro

.macro UnsetRenderFlag
  lda #%01111111
  and Game::flags
  sta Game::flags
.endmacro