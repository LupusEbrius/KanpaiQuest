.scope Enemy
    enemyMoveTimer
    enemyCooldown
    enemyData
    enemyAnimate

    .proc update
        jsr spawn_enemies     
        jsr update_x
        jsr update_y
        jsr reset_move_timer
        jsr check_collision
        rts
    .endproc

    .proc update_x
        ; check Move timer
        ; if zero, adjust the X pos of all active enemies

        rts
    .endproc

    .proc update_y
        ; check Move timer
        ; if zero, adjust the Y pos of all active enemies

        rts
    .endproc

    .proc reset_move_timer
        ; reset move timer

        rts
    .endproc

    .proc spawn_enemies
        ; check cooldown timer
        ; if zero, spawn a new enemy and reset the cooldown timer
        dec enemyCooldown
        lda enemyCooldown
        cmp #00
        bne skip
        lda #10 ; number of player scprites and brick sprites
        ; Add the number of enemy sprites are already displayed
        ; 
        asl
        asl
        tay
        ; Y Pos
        lda #08
        sta $0200, y
        iny
        ; Sprite
        lda #$0E
        sta $0200, y
        iny
        ; Attr
        lda #%00000000
        sta $0200, y
        iny
        ; X Pos
        ; Generate Random number between 0-(247)* 
        ; *Right bound subject to change for final enemy width
        
        lda #00
        sta $0200, y
        lda #10
        sta enemyCooldown
        skip:
        rts
    .endproc

    .proc check_collision

        rts
    .endproc

    .proc update_enemy_animations

        rts
    .endproc
.endscope