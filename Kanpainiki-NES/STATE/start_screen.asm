.scope StartScreen
    .proc start_screen
        

        lda #BUTTON_START
        and Controller::pressed
        beq start_pressed
        rts
    .endproc

    

    .proc animation
    .endproc

    .proc start_pressed
        
    .endproc
.endscope