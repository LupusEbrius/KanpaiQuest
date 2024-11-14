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
    lda #$0F
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
    VramColRow 0, 0, NAMETABLE_B
   

    TOPBLANK:
      lda #$45
      jsr ppu_full_line
      jsr ppu_full_line
      jsr ppu_full_line
      jsr ppu_full_line
      
    ldx #$00
    loop:
      lda KANPAI, x
      sta PPU_DATA
      inx
      cpx #160
      bne loop

    lda #$45
    jsr ppu_full_line
    jsr ppu_full_line
    ldx #$00
    questloop:
      lda QUEST, x
      sta PPU_DATA
      inx
      cpx #160
      bne questloop

    lda #$45
    jsr ppu_full_line

    ; GET SMASHED GET BRICKED
    LDX #00
    splashloop:
      lda SPLASHTEXT, x
      sta PPU_DATA
      inx
      cpx #32
      bne splashloop
    
    
    lda #$45
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    ;jsr ppu_full_line
    ldx #24
    jsr ppu_fill_line
    lda #$30
    ldx #6
    jsr ppu_fill_line
    lda #$45
    ldx #2
    jsr ppu_fill_line

    ldx #$00
    logoloop:
      lda LOGOS, x
      sta PPU_DATA
      inx
      cpx #96
      bne logoloop
    ; BLANK SPACE
    BOTTOMBLANKBF:
      lda #$45
      jsr ppu_full_line
      jsr ppu_full_line


    ; LOAD ATTRIBUTES
    lda PPU_STATUS
    ldx #00
    attributeloop:
      lda attribute, x 
      sta PPU_DATA
      inx
      cpx #64
      bne attributeloop
    rts
    KANPAI:	
      .byte $08,$08,$2B,$09,$08,$1D,$1A,$0E,$1D,$09,$09,$1C,$0B,$18,$0C,$08
      .byte $09,$0A,$09,$09,$09,$18,$0C,$1D,$09,$09,$1C,$08,$09,$2C,$08,$08
      .byte $08,$08,$2B,$09,$1D,$1A,$0E,$08,$09,$2C,$2B,$09,$0B,$09,$18,$0C
      .byte $09,$0A,$09,$2C,$08,$09,$0A,$09,$2C,$2B,$09,$08,$09,$2C,$08,$08
      .byte $08,$08,$2B,$09,$09,$2A,$08,$08,$09,$09,$09,$09,$0B,$09,$1B,$18
      .byte $09,$0A,$09,$2C,$08,$09,$0A,$09,$09,$09,$09,$08,$09,$2C,$08,$08
      .byte $08,$08,$2B,$09,$1F,$18,$0C,$08,$09,$2C,$2B,$09,$0B,$09,$0F,$1B
      .byte $09,$0A,$09,$09,$09,$1A,$0E,$09,$2C,$2B,$09,$08,$09,$2C,$08,$08
      .byte $08,$08,$2B,$09,$08,$1F,$18,$0C,$09,$2C,$2B,$09,$0B,$09,$08,$0F
      .byte $1B,$0A,$09,$2C,$08,$08,$08,$09,$2C,$2B,$09,$08,$09,$2C,$08,$08
    QUEST:
      .byte $08,$08,$08,$08,$08,$1D,$09,$09,$1C,$0B,$0A,$08,$0B,$0A,$1D,$09
      .byte $09,$1E,$1D,$09,$09,$1C,$1F,$09,$09,$09,$1E,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$09,$08,$08,$09,$0B,$0A,$08,$0B,$0A,$09,$08
      .byte $08,$08,$09,$08,$08,$08,$08,$08,$09,$08,$08,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$09,$08,$08,$09,$0B,$0A,$08,$0B,$0A,$09,$09
      .byte $09,$08,$1F,$09,$09,$1C,$08,$08,$09,$08,$08,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$09,$08,$1C,$09,$0B,$0A,$08,$0B,$0A,$09,$08
      .byte $08,$08,$08,$08,$08,$09,$08,$08,$09,$08,$08,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$1F,$09,$09,$28,$0F,$1B,$09,$1A,$0E,$1F,$09
      .byte $09,$1C,$1F,$09,$09,$1E,$08,$08,$09,$08,$08,$08,$08,$08,$08,$08
    SPLASHTEXT:
    	.byte $08,$08,$08,$08,$60,$41,$65,$08,$50,$47,$42,$50,$40,$41,$61,$08
	    .byte $08,$60,$41,$65,$08,$62,$53,$46,$51,$63,$41,$61,$08,$08,$08,$08
    LOGOS:
      .byte $08,$08,$08,$08,$08,$1F,$1C,$08,$08,$08,$08,$08,$2D,$08,$50,$65
      .byte $42,$53,$65,$08,$08,$08,$08,$08,$30,$3B,$4C,$4D,$3A,$30,$08,$08
      .byte $08,$08,$08,$08,$08,$1D,$1E,$08,$08,$08,$08,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$08,$08,$08,$30,$3C,$3D,$3E,$3F,$30,$08,$08
      .byte $08,$08,$08,$1D,$1E,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08
      .byte $08,$08,$08,$08,$08,$08,$08,$08,$30,$39,$4E,$4F,$38,$30,$08,$08
    attribute:
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %11111111, %00110011
      .byte %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .endproc
  
  .proc draw_game_screen
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
    VramColRow 0, 0, NAMETABLE_B
    lda #$45
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    jsr ppu_full_line
    ; jsr ppu_full_line
    ; jsr ppu_full_line
    VramReset
    rts
  .endproc

  .proc check_state
    lda $AC
    cmp #0
    beq game
    cmp #1
    beq win
    cmp #2
    beq lose
    ; else
    start:
    
      rts
    game:
    
      rts
    win:

      rts
    lose:

      rts
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