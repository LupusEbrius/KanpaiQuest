.scope StatusBar
; Create a HUD on the top of the screen to show Point, Timer, Health, Special
; 
    FRAMECOUNTER = $AF
    SECONDCOUNTER = $AE
    MINUTECOUTER = $AD

    .proc init_timer
        lda #60
        sta FRAMECOUNTER
        sta SECONDCOUNTER
        lda #01
        sta MINUTECOUTER
        rts
    .endproc

    .proc count_down
        ldx FRAMECOUNTER
        dex
        cpx #00
        bne save
        ldx #60
        ldy SECONDCOUNTER
        dey
        cpy #00
        bne save:
        ldy #60
        lda MINUTECOUTER
        dec
        cpy #00
        beq end_game
        end_game:
            jsr win_screen
            rts
        save:
        stx FRAMECOUNTER
        sty SECONDCOUNTER

    .endproc

    .proc display_timer
    .endproc

    .proc display_health
        ; $65 for pineapple top
        ; $75 for pineapple body
        
    .endproc
.endscope