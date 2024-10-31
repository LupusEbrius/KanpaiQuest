.segment "HEADER"
    .byte "NES", $1A ;IDENTIFICATION STRING
    .byte $02   ;PRG ROM 16K UNITS
    .byte $01   ;CHR ROM 8K UNITS
    .byte $00   ;MAPPER AND MIRROR
    .byte $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00

.segment "ZEROPAGE"

.segment "VECTORS"
    .addr nmi
    .addr reset
    .addr 0

.segment "STARTUP"

.segment "CODE"
    .include "./graphics/palette.s"
    .include "./graphics/small-sprite.s"
    .include "./STATE/ppu.asm"
    .include "./STATE/player.asm"
    .include "./STATE/game.asm"

    .proc reset
        sei     ;disables interupts
        cld     ;turn off decimal mode
        ;init stack register
        ldx #$FF
        txs     ;transfer x to the stack
        ; Clear PPU registers
        ldx #$00
        stx PPU_CTRL
        stx PPU_MASK
        stx $4010   ; disables PCM
        ldx #%10000000 ; disables sound IRQ 
        stx $4017
        bit PPU_STATUS
        VblankWait
        ldx #0
        lda #0
        @ram_reset_loop:
            sta $0000, x
            sta $0100, x
            sta $0200, x
            sta $0300, x
            sta $0400, x
            sta $0500, x
            sta $0600, x
            sta $0700, x
            inx
            bne @ram_reset_loop
        lda #%11101111
        @sprite_reset_loop:
            sta $0200, x
            inx
            bne @sprite_reset_loop
        lda #$00
        sta OAM_ADDR
        lda #$02
        sta OAM_DMA
        VblankWait
        bit PPU_STATUS
        lda #$3F
        sta PPU_ADDR
        lda #$00
        sta PPU_ADDR
        lda #$0F
        ldx #$20
        @resetPalettesLoop:
        sta PPU_DATA
        dex
        bne @resetPalettesLoop
        jmp main
    .endproc

    ;-------------------------------------------------------------------------------
    ; The main routine for the program. This sets up and handles the execution of
    ; the game loop and controls memory flags that indicate to the rendering loop
    ; if the game logic has finished processing.
    ;
    ; For the most part if you're emodifying or playing with the code, you shouldn't
    ; have to make edits here. Instead make changes to `init_game` and `game_loop`
    ; below...
    ;-------------------------------------------------------------------------------
    .proc main
        jsr init_game
        loop:
            jsr game_loop
            SetRenderFlag
        @wait_for_render:
            bit Game::flags
            bmi @wait_for_render
            jmp loop
    .endproc

    ;-------------------------------------------------------------------------------
    ; Non-maskable Interrupt Handler. This interrupt is executed at the end of each
    ; PPU rendering frame during the Vertical Blanking Interval (VBLANK). This
    ; interval lasts rougly 2273 CPU cycles, and to avoid graphical glitches all
    ; drawing in the "rendering_loop" should be completed within that timeframe.
    ;
    ; For the most part if you're modifying or playing with the code, you shouldn't
    ; have to touch the nmi directly. To change how the game renders update the
    ; `render_loop` routine below...
    ;-------------------------------------------------------------------------------
    .proc nmi
        bit Game::flags
        bpl @return
        jsr render_loop
        UnsetRenderFlag
        @return:
            rti
    .endproc

    ;-------------------------------------------------------------------------------
    ; Initializes the game on reset before the main loop begins to run
    ;-------------------------------------------------------------------------------
    .proc init_game
        ; Initialize the game state
        jsr Game::init
        jsr Player::init

        ; Enable rendering and NMI
        lda #%10010000
        sta PPU_CTRL
        lda #%00011110
        sta PPU_MASK
        rts
    .endproc

    ;-------------------------------------------------------------------------------
    ; Main game loop logic that runs every tick
    ;-------------------------------------------------------------------------------
    .proc game_loop
        ; jsr Joypad::update
        ; jsr Player::Movement::update
        ; jsr Player::Sprite::update
        rts
    .endproc


    .proc render_loop
        ; Transfer Sprites via OAM
        lda #$00
        sta OAM_ADDR
        lda #$02
        sta OAM_DMA

        ; .include "./STATE/controller.s"
        
        ; Reset the VRAM address
        VramReset

        rts
    .endproc

.segment "CHARS"
    .incbin "graphics.chr"