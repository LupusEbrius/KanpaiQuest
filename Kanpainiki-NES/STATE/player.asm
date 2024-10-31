.scope Player
    .include "./graphics/small-sprite.s"
    NUM_SPRITES = 6
    HEALTH        = $30
    targetVelocityX   = $30   ; Signed Fixed Point 4.4
    velocityX         = $31   ; Signed Fixed Point 4.4
    positionX         = $32   ; Signed Fixed Point 12.4
    SpriteX           = $34   ; Unsigned Screen Coordinates
    heading           = $35   ; See `.enum Heading`, below...

    velocityY         = $36   ; Signed Fixed Point 4.4
    positionY         = $37   ; Signed Fixed Point 12.4
    spriteY           = $39   ; Unsigned Screen Coordinates

    motionState       = $3A   ; See `.enum MotionState`, below...
    animationFrame    = $3B
    animationTimer    = $3C
    idleState         = $3D   ; See `.enum IdleState`, below...
    idleTimer         = $3E

    .scope Initial
        SpriteX = 48
        velocityX = 0
        positionX_LO = $00
        positionX_HI = $03
        spriteY = 143
        velocityY = 0
        positionY_LO = $F0
        positionY_HI = $08
    .endscope

    .enum Heading
        Right = 0
        Left = 1
    .endenum

    .enum MotionState
        Still = 0
        Walk = 1
        Pivot = 2
        Airborne = 3
    .endenum

    .enum IdleState
        Still = 0
        Blink1 = 1
        Still2 = 2
        Blink2 = 3
    .endenum

    .scope Jump
        FloorHeight = 143
        InitialVelocity = $C8
        MaxFallSpeed = $40
    .endscope

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
        lda #Initial::spriteY
        sta spriteY
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
        rts
    .endproc
    
; Calculates where the sprites should go based on player inputs
    .scope Movement 
        .proc update
            
        .endproc


    .endscope

; Check if an Enemy Sprite is in contact with Player Sprites
    .scope Collision 

    .endscope

; Calculate Damage taken by player
    .scope Damage

    .endscope

; Handles all rendering of player sprites, animation and location
    .scope Sprite 
        .proc update
            jsr update_animations
            jsr update_tiles
            jsr update_position
        .endproc

        .proc update_animations
            lda motionState
            cmp #MotionState::Walk
            beq @walk
            @walk:
                lda animationFrame 
                asl
                asl
                clc
                tax
                lda SPRITEWALK, x 
                sta $216 + OAM_TILE
                rts
            lda animationFrame 
            tax
            lda TAILWAG, x
            sta $220 + OAM_TILE
            rts
        .endproc

        .proc tail_wag
            ;for each animation frame, change the sprite tail to the next tile in the animation
            
        .endproc

        .proc update_tiles
            lda SpriteX
            sta $200 + OAM_X
            clc
            rts
        .endproc

        .proc update_position
            lda SpriteX
            @loop:
                STA $200 + OAM_X, x
                INX
                CPX #(4 * NUM_SPRITES)
                BNE @loop
            lda spriteY
            @y:
                sta $200 + OAM_Y, x
                inx
                cpx #(4 * NUM_SPRITES)
                bne @y
            
            ; sta $200 + OAM_X
            ; clc
            ; adc #8
            ; sta $204 + OAM_X
            rts
        .endproc
    .endscope

.endscope