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

    .proc update
        jsr count_down
        ; jsr display_timer
        rts
    .endproc

    .proc count_down
        dec FRAMECOUNTER
        ldx FRAMECOUNTER
        cpx #00
        bne save
        ldx #60
        stx FRAMECOUNTER
        dec SECONDCOUNTER
        ldy SECONDCOUNTER
        cpy #00
        bne save
        ldy #60
        sty SECONDCOUNTER
        dec MINUTECOUTER
        cpy #00
        beq end_game
        end_game:
            LDA #1
            STA $AC
            rts
        save:
        rts
    .endproc

    .proc display_timer

    .endproc

    .proc display_health
        ; $65 for pineapple top
        ; $75 for pineapple body
        
    .endproc
.endscope