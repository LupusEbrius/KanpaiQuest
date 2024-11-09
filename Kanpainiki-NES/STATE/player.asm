.scope Player
    .include "./graphics/small-sprite.s"
    NUM_SPRITES = 6
    HEALTH            = $40
    DAMAGE            = $41
    targetVelocityX   = $30   ; Signed Fixed Point 4.4
    velocityX         = $31   ; Signed Fixed Point 4.4
    positionX         = $32   ; Signed Fixed Point 12.4
    SpriteX           = $34   ; Unsigned Screen Coordinates
    
    ; heading           = $34   ; See `.enum Heading`, below...

    targetVelocityY   = $35
    velocityY         = $36   ; Signed Fixed Point 4.4
    positionY         = $37   ; Signed Fixed Point 12.4
    SpriteY           = $39   ; Unsigned Screen Coordinates

    ; motionState       = $39   ; See `.enum MotionState`, below...
    anmFrameBody      = $3A
    anmFrameTail      = $3B
    anmFrameEar       = $3C
    animationTimer    = $3D
    idleState         = $3E   ; See `.enum IdleState`, below...
    idleTimer         = $3F

    ProjectileNum     = $43
    PlayerSprites     = $44

    .scope Initial
        SpriteX = 0
        velocityX = 0
        positionX_LO = $70
        positionX_HI = $07
        SpriteY = 0
        velocityY = 0
        positionY_LO = $A0
        positionY_HI = $08
        anmFrameTail = 0
        animationTimer = 0
    .endscope

    .enum Heading
        Right = 0
        Left = 1
    .endenum

    .enum MotionState
        Still = 0
        Walk = 1
        Pivot = 2
    .endenum

    .enum IdleState
        Still = 0
        Blink1 = 1
        Still2 = 2
        Blink2 = 3
    .endenum
    
    .proc init
        jsr init_x
        jsr init_y
        jsr init_sprites
    .endproc

    .proc init_x
        ; Set the initial x-position to 48 ($0300 in 12.4 fixed point)
        lda #Initial::SpriteX
        sta SpriteX
        lda #Initial::positionX_LO
        sta positionX
        lda #Initial::positionX_HI
        sta positionX + 1
        ; Initialize the velocity and target velocity
        lda Initial::velocityX
        sta targetVelocityX
        sta velocityX
        rts
    .endproc

    .proc init_y
        ; Set the initial y-position
        lda #Initial::SpriteY
        sta SpriteY
        lda #Initial::positionY_LO
        sta positionY
        lda #Initial::positionY_HI
        sta positionY + 1
        ; Initialize the velocity and target velocity
        lda #Initial::velocityY
        sta velocityY
        rts
    .endproc

    .proc init_sprites
        ldx #0
        @loop:
            lda SPRITENEW, x
            sta $0200, x
            inx
            cpx #(4 * NUM_SPRITES)
            bne @loop
            lda sprite_num
            clc
            adc #6
            sta sprite_num
            sta PlayerSprites
            rts
    .endproc
    
; Calculates where the sprites should go based on player inputs
    .scope Movement 
        .proc update
            jsr set_target_x_velocity
            jsr accelerate_x
            jsr apply_velocity_x
            jsr bound_position_x
            jsr set_target_y_velocity
            jsr accelerate_y
            jsr apply_velocity_y
            jsr bound_position_y
            rts
        .endproc

        .proc set_target_x_velocity
            ; Check if the B button is being pressed and save the state in the X
            ; register
            ldx #0
            lda #BUTTON_B
            and Controller::down
            beq @check_right
            inx
            @check_right:
            ; Check if the right d-pad is down and if so set the target velocity by
            ; using the lookup table at the end of the routine. This is why we set x
            ; to either 0 or 1, so we could use the table to set the "walk right" or
            ; "run right" velocity.
                lda #BUTTON_RIGHT
                and Controller::down
                beq @check_left
                lda right_velocity, x
                sta targetVelocityX
                rts
            @check_left:
            ; Similar to `@check_right` above, but for the left direction
                lda #BUTTON_LEFT
                and Controller::down
                beq @no_direction
                lda left_velocity, x
                sta targetVelocityX
                rts
            @no_direction:
            ; If the player isn't pressing left or right the horizontal velocity is 0
                lda #0
                sta targetVelocityX
                rts
            ; The velocities are stored in signed 4.4 fixed point, just like in SMB3.
            ; The idea is that the left 4 bits are the "whole" part of the number and
            ; the right four bits are the "fractional" part.
            right_velocity:
                .byte $19, $29
            left_velocity:
                .byte $E9, $D9
        .endproc

        .proc accelerate_x
            ; Subtract the current velocity from the target velocity to compare the
            ; two values.
            ;
            ; If V - T == 0:
            ;   Then the current velocity is at the target and we are done.
            ; If V - T < 0:
            ;   Then the velocity is greater than the target and should be decreased.
            ; Otherwise, if V - T > 0:
            ;   Then the velocity is less than the target and should be increased.
            ;
            ; I'm pretty sure SMB3 uses a lookup table to handle the acceleration
            ; values, but I just keep things simple and use inc/dec to increase the
            ; value by a maximum of 1 each frame (which gives the effect of a constant
            ; acceleration).
            lda velocityX
            sec
            sbc targetVelocityX
            bne @check_greater
            rts
            @check_greater:
                bmi @lesser
                dec velocityX
                rts
            @lesser:
                inc velocityX
                rts
        .endproc

        .proc apply_velocity_x
            ; Check to see if we're moving to the right (positive) or the left (negative)
            lda velocityX
            bmi @negative
            @positive:
                ; Positive velocity is easy: just add the 4.4 fixed point velocity to the
                ; 12.4 fixed point position.
                clc
                adc positionX
                sta positionX
                lda #0
                adc positionX + 1
                sta positionX + 1
                rts
            @negative:
                ; There's probably a really clever way to do this just with ADC but I am
                ; lazy and conceptually it made things easier in my head to invert the
                ; negative velocity and use SBC.
                lda #0
                sec
                sbc velocityX
                sta $00
                lda positionX
                sec
                sbc $00
                sta positionX
                lda positionX+1
                sbc #0
                sta positionX+1
                rts
        .endproc

        .proc bound_position_x
            ; Convert the fixed point position coordinate into screen coordinates
            lda positionX
            sta $00
            lda positionX + 1
            sta $01
            lsr $01
            ror $00
            lsr $01
            ror $00
            lsr $01
            ror $00
            lsr $01
            ror $00
            ; Assume that everything is fine and save the sprite position
            lda $00
            sta SpriteX
            ; Check if we are moving left or right (negative or positive respectively)
            lda velocityX
            bmi @negative
            @positive:
                lda $01
                bne @bound_upper
                lda $00
                cmp #239
                bcs @bound_upper
                rts
            @bound_upper:
                ; $EF = 239 = 255 - 16, this is the right bound since the screen is 256 pixels
                ; wide and the character is 16 pixels wide.
                lda #$EF
                sta SpriteX
                lda #$0E
                sta positionX+1
                lda #$F0
                sta positionX
                ; Finally, set the velocity to 0 since the player is being "stopped"
                lda #0
                sta velocityX
                rts
            @negative:
                ; The negative case is really simple, just check if the high order byte of the
                ; 12.4 fixed point position is negative. If so bound everything to 0.
                lda positionX+1
                bmi @bound_lower
                rts
            @bound_lower:
                lda #0
                sta positionX
                sta positionX + 1
                sta SpriteX
                sta velocityX
                rts
        .endproc

        .proc set_target_y_velocity
            ; Check if the B button is being pressed and save the state in the X
            ; register
            ldx #0
            lda #BUTTON_B
            and Controller::down
            beq @check_up
            inx
            @check_up:
                ; Check if the right d-pad is down and if so set the target velocity by
                ; using the lookup table at the end of the routine. This is why we set x
                ; to either 0 or 1, so we could use the table to set the "walk right" or
                ; "run right" velocity.
                lda #BUTTON_DOWN
                and Controller::down
                beq @check_down
                lda up_velocity, x
                sta targetVelocityY
                rts
            @check_down:
                ; Similar to `@check_right` above, but for the left direction
                lda #BUTTON_UP
                and Controller::down
                beq @no_direction
                lda down_velocity, x
                sta targetVelocityY
                rts
            @no_direction:
                ; If the player isn't pressing left or right the horizontal velocity is 0
                lda #0
                sta targetVelocityY
                rts
                ; The velocities are stored in signed 4.4 fixed point, just like in SMB3.
                ; The idea is that the left 4 bits are the "whole" part of the number and
                ; the right four bits are the "fractional" part.
            up_velocity:
                .byte $19, $29
            down_velocity:
                .byte $E9, $D9
        .endproc

        .proc accelerate_y
            ; Subtract the current velocity from the target velocity to compare the
            ; two values.
            ;
            ; If V - T == 0:
            ;   Then the current velocity is at the target and we are done.
            ; If V - T < 0:
            ;   Then the velocity is greater than the target and should be decreased.
            ; Otherwise, if V - T > 0:
            ;   Then the velocity is less than the target and should be increased.
            ;
            ; I'm pretty sure SMB3 uses a lookup table to handle the acceleration
            ; values, but I just keep things simple and use inc/dec to increase the
            ; value by a maximum of 1 each frame (which gives the effect of a constant
            ; acceleration).
            lda velocityY
            sec
            sbc targetVelocityY
            bne @check_greater
            rts
            @check_greater:
                bmi @lesser
                dec velocityY
                rts
            @lesser:
                inc velocityY
                rts
        .endproc

        .proc apply_velocity_y
            ; Check to see if we're moving to down (positive) or up (negative)
            lda velocityY
            bmi @negative
            @positive:
                ; Positive velocity is easy: just add the 4.4 fixed point velocity to the
                ; 12.4 fixed point position.
                clc
                adc positionY
                sta positionY
                lda #0
                adc positionY + 1
                sta positionY + 1
                rts
            @negative:
                ; There's probably a really clever way to do this just with ADC but I am
                ; lazy and conceptually it made things easier in my head to invert the
                ; negative velocity and use SBC.
                lda #0
                sec
                sbc velocityY
                sta $04
                lda positionY
                sec
                sbc $04
                sta positionY
                lda positionY+1
                sbc #0
                sta positionY+1
                rts
        .endproc

        .proc bound_position_y
            ; Convert the fixed point position coordinate into screen coordinates
            lda positionY
            sta $04
            lda positionY + 1
            sta $05
            lsr $05
            ror $04
            lsr $05
            ror $04
            lsr $05
            ror $04
            lsr $05
            ror $04
            ; Assume that everything is fine and save the sprite position
            lda $04
            sta SpriteY
            ; Check if we are moving up or down (negative or positive respectively)
            lda velocityY
            bmi @negative
            @positive:
                lda $05
                bne @bound_upper
                lda $04
                cmp #$9F
                bcs @bound_upper
                rts
            @bound_upper:
                ; $EF = 239 = 255 - 16, this is the right bound since the screen is 256 pixels
                ; wide and the character is 16 pixels wide.
                lda #$9F
                sta SpriteY
                lda #$09
                sta positionY+1
                lda #$F0
                sta positionY
                ; Finally, set the velocity to 0 since the player is being "stopped"
                lda #0
                sta velocityY
                rts
            @negative:
                ; The negative case is really simple, just check if the high order byte of the
                ; 12.4 fixed point position is negative. If so bound everything to 0.
                lda $04
                ; lda positionY+1
                cmp #7
                bcc @bound_lower
                rts
            @bound_lower:
                lda #$07
                sta SpriteY
                lda #$00 
                sta positionY + 1
                lda #$70
                sta positionY
                lda #0
                sta velocityY
                rts
        .endproc
    .endscope

; Check if an Enemy Sprite is in contact with Player Sprites
    .scope Collision 

    .endscope

; Calculate Damage taken by player
    .scope Damage

    .endscope

    .scope Attack

        .proc update
            ldx #0
            lda #BUTTON_A
            and Controller::pressed
            bne @check_brick_limit
            rts
            @check_brick_limit:
                lda ProjectileNum
                cmp #04
                bne @spawn_brick
                rts
            ; Create a Brick Sprite that moves in a straight line until address $000F
            ; has a non Zero value for every time player presses A
            @spawn_brick: 
                clc
                adc #1
                sta ProjectileNum
                tay
                dey
                ldx #04
                stx $0C, y
                lda sprite_num
                asl
                asl
                tay
                lda SpriteY
                sta $0200, y
                iny
                lda BRICK
                sta $0200, y
                iny
                lda #$02
                sta $0200, y
                iny
                lda SpriteX
                sta $0200, y
                lda sprite_num
                clc
                adc #1
                sta sprite_num
            rts
        .endproc
    .endscope
; Handles all rendering of player sprites, animation and location
    .scope Sprite 
        .proc update
            jsr update_animations
            jsr update_tiles
            jsr update_sprite_position
            jsr update_thrown_bricks
            jsr check_brick_collision
            rts
        .endproc

        .proc update_animations
            jsr tail_wag
            rts
        .endproc

        .proc tail_wag
            ;for each animation frame, change the sprite tail to the next tile in the animation
            inc animationTimer
            lda animationTimer
            and #31
            sta animationTimer
            cmp #30
            bne @pause
            ldx anmFrameTail
            inx
            cpx #3
            bne @save
            ldx #0
            @save:
                stx anmFrameTail
            @pause:
                ldx anmFrameTail
                rts
            rts
        .endproc
 
        .proc update_tiles 
            ; update what the tile values should be
            lda TAIL, x
            sta $0200 + (4 * ( NUM_SPRITES - 1 )) + OAM_TILE

            rts
        .endproc 
 
        .proc update_sprite_position            
            lda SpriteX
            clc
            sta $0217
            adc #01
            sta $0203
            sta $020F
            lda SpriteX
            clc
            adc #09
            sta $0207
            sta $020B
            lda SpriteX
            clc
            adc #05
            sta $0213
            lda SpriteY
            clc
            sta $0200
            sta $0204
            adc #08
            sta $0208
            sta $020C
            clc
            adc #08
            sta $0210
            sec
            sbc #01
            sta $0214
            rts
            X_REL:
                .byte 1, 9, 9, 1, 5, 0
            Y_REL:
                .byte 0, 0, 8, 8, 10, 15
        .endproc 
 
        .proc update_thrown_bricks 

            ; check if projectile is active
            ldy #0
            ldx #0
            loop:
              lda $0C, x
              cmp #4
              beq movebrick
              inx
              cpx #4
              bne loop
              rts           
              movebrick:
                  lda PlayerSprites
                  clc
                  stx $0A
                  adc $0A
                  asl
                  asl
                  tay
                  lda $0200, y
                  sec
                  sbc #4
                  sta $0200, y         
                  inx
                  cpx #4
                  bne loop

            rts

        .endproc

        .proc check_brick_collision
            loop:
            lda $0C, x
            cmp #4
            beq checkbrick
            inx
            cpx #4
            bne loop
            rts           
            checkbrick:
                lda PlayerSprites
                clc
                stx $0A
                adc $0A
                asl
                asl
                tay
                lda $0200, y
                cmp #4
                bcc @despawn
                inx
                cpx #4
                bne loop
                rts
                @despawn:
                    lda #$FF
                    sta $0200, y
                    lda #$00
                    sta $0C, x
                    dec ProjectileNum
                    dec sprite_num     
                    inx
                    cpx #4
                    bne loop
            rts
        .endproc   
    .endscope

.endscope
