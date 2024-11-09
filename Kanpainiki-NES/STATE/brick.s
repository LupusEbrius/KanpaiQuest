.scope Brick

    .proc Sprite
        .proc spawn_bricks
        ldx #0
        @loop:
            lda BRICKS, x
            sta $0218, x
            inx
            cpx #(16)
            bne @loop
            rts
        .endproc

        .proc apply_velocity

        .endproc

        .proc brick_spin
            ;for each animation frame, change the sprite tail to the next tile in the animation
            ; inc animationTimer
            ; lda animationTimer
            ; and #31
            ; sta animationTimer
            ; cmp #30
            ; bne @pause
            ; ldx anmFrame
            ; inx
            ; cpx #3
            ; bne @save
            ; ldx #0
            ; @save:
            ;     stx anmFrame
            ; @pause:
            ;     ldx anmFrame
            ;     rts
            ; rts
        .endproc

        .proc update_tiles
            ; update what the tile values should be
            lda BRICK, x
            sta $0200 + OAM_TILE
            inx
            STA $0200 + OAM_ATTR
            rts
        .endproc

        .proc update_position
            ldx sprite_num
            
            lda $34
            ; sta $0200 + OAM_X
            ; lda SpriteY
            ; sta $0200 + OAM_Y

        .endproc


    .endproc
.endscope