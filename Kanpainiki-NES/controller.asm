;-------------------------------------------------------------------------------
; [$21-$22] Controller State
;-------------------------------------------------------------------------------
; The state for the controller is stored across two bytes, each of which is a
; bitmask where each bit corresponds to a single button on the controller. This
; demo only uses the first controller.
;
; The bits in each mask are mapped as such:
;
; [AB-+^.<>]
;  ||||||||
;  |||||||+--------> Bit 0: D-PAD Right
;  ||||||+---------> Bit 1: D-PAD Left
;  |||||+----------> Bit 2: D-PAD Down
;  ||||+-----------> Bit 3: D-PAD Up
;  |||+------------> Bit 4: Start
;  ||+-------------> Bit 5: Select
;  |+--------------> Bit 6: B
;  +---------------> Bit 7: A
;
;-------------------------------------------------------------------------------

; Controller port addresses
JOYPAD1 = $4016
JOYPAD2 = $4017

; Button mask bits
BUTTON_A      = 1 << 7
BUTTON_B      = 1 << 6
BUTTON_SELECT = 1 << 5
BUTTON_START  = 1 << 4
BUTTON_UP     = 1 << 3
BUTTON_DOWN   = 1 << 2
BUTTON_LEFT   = 1 << 1
BUTTON_RIGHT  = 1 << 0

.scope Controller
    .proc update
      
    .endproc
.endscope

.scope old
  LatchController:
      LDA #$01
      STA $4016
      LDA #$00
      STA $4016     ; tell both the controllers to latch buttons


  ReadA: 
    LDA $4016       ; player 1 - A
    AND #%00000001  ; only look at bit 0
    BEQ ReadADone   ; branch to ReadADone if button is NOT pressed (0)
                    ; add instructions here to do something when button IS pressed (1)
    
  ReadADone:        ; handling this button is done

  ReadB: 
    LDA $4016       ; player 1 - B
    AND #%00000001  ; only look at bit 0
    BEQ ReadBDone   ; branch to ReadBDone if button is NOT pressed (0)
                    ; add instructions here to do something when button IS pressed (1)
    ; Generate a Brick and have it move

  ReadBDone:        ; handling this button is done

  ReadSelect: 
    LDA $4016           ; player 1 - A
    AND #%00000001      ; only look at bit 0
    BEQ ReadSelectDone  ; branch to ReadADone if button is NOT pressed (0)

  ReadSelectDone:

  ReadStart: 
    LDA $4016          ; player 1 - A
    AND #%00000001     ; only look at bit 0
    BEQ ReadStartDone  ; branch to ReadADone if button is NOT pressed (0)

  ReadStartDone:

  ReadUp:
    LDA $4016       ; player 1 - A
    AND #%00000001  ; only look at bit 0
    BEQ ReadUpDone  ; branch to ReadADone if button is NOT pressed (0)

    LDA $0200       ; load sprite X position
    SEC            ; make sure carry flag is set
    SBC #$01       ; A = A - 1
    STA $0200       ; save sprite X position
    LDA $0204       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0204       ; save sprite X position
    LDA $0208       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0208       ; save sprite X position
    LDA $020C       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $020C       ; save sprite X position
    LDA $0210       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0210       ; save sprite X position
    LDA $0214       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0214       ; save sprite X position
    LDA $0218       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0218       ; save sprite X position
    LDA $021C       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $021C       ; save sprite X position
    LDA $0220       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0220       ; save sprite X position
    LDA $0224       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0224       ; save sprite X position
    
  ; MoveSpriteUpLoop:
  ;   lda YPOS, x     ; load sprite X position
  ;   inx
  ;   SEC             ; make sure carry flag is set
  ;   SBC #$01        ; A = A - 1
  ;   STA $0200, x    ; save sprite X position
  ;   cpx #$28
  ;   bne MoveSpriteUpLoop
  ReadUpDone:

  ReadDown: 
    LDA $4016         ; player 1 - A
    AND #%00000001    ; only look at bit 0
    BEQ ReadDownDone  ; branch to ReadADone if button is NOT pressed (0)

    LDA $0200       ; load sprite X position
    CLC            ; make sure carry flag is set
    ADC #$01       ; A = A - 1
    STA $0200       ; save sprite X position
    LDA $0204       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0204       ; save sprite X position
    LDA $0208       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0208       ; save sprite X position
    LDA $020C       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $020C       ; save sprite X position
    LDA $0210       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0210       ; save sprite X position
    LDA $0214       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0214       ; save sprite X position
    LDA $0218       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0218       ; save sprite X position
    LDA $021C       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $021C       ; save sprite X position
    LDA $0220       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0220       ; save sprite X position
    LDA $0224       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0224       ; save sprite X position

  ; MoveSpriteDownLoop:
  ;   lda $0200, x     ; load sprite X position
  ;   inx
  ;   CLC             ; make sure carry flag is set
  ;   ADC #$01        ; A = A + 1
  ;   STA $0200, x    ; save sprite X position
  ;   CPX #$28
  ;   bne MoveSpriteDownLoop
  ReadDownDone:

  ReadLeft: 
    LDA $4016         ; player 1 - A
    AND #%00000001    ; only look at bit 0
    BEQ ReadLeftDone  ; branch to ReadADone if button is NOT pressed (0)

    LDA $0203       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0203       ; save sprite X position
    LDA $0207       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0207       ; save sprite X position
    LDA $020B       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $020B       ; save sprite X position
    LDA $020F       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $020F       ; save sprite X position
    LDA $0213       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0213       ; save sprite X position
    LDA $0217       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0217       ; save sprite X position
    LDA $021B       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $021B       ; save sprite X position
    LDA $021F       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $021F       ; save sprite X position
    LDA $0223       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0223       ; save sprite X position
    LDA $0227       ; load sprite X position
    SEC             ; make sure carry flag is set
    SBC #$01        ; A = A - 1
    STA $0227       ; save sprite X position

  ; MoveSpriteLeftLoop:
  ;   lda XPOS, x     ; load sprite X position
  ;   inx
  ;   SEC             ; make sure carry flag is set
  ;   SBC #$01        ; A = A - 1
  ;   STA $0200, x    ; save sprite X position
  ;   cpx #$28
  ;   bne MoveSpriteLeftLoop
  ReadLeftDone:

  ReadRight: 
    LDA $4016          ; player 1 - A
    AND #%00000001     ; only look at bit 0
    BEQ ReadRightDone  ; branch to ReadADone if button is NOT pressed (0)

    LDA $0203       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0203       ; save sprite X position
    LDA $0207       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0207       ; save sprite X position
    LDA $020B       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $020B       ; save sprite X position
    LDA $020F       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $020F       ; save sprite X position
    LDA $0213       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0213       ; save sprite X position
    LDA $0217       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0217       ; save sprite X position
    LDA $021B       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $021B       ; save sprite X position
    LDA $021F       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $021F       ; save sprite X position
    LDA $0223       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0223       ; save sprite X position
    LDA $0227       ; load sprite X position
    CLC             ; make sure carry flag is set
    ADC #$01        ; A = A - 1
    STA $0227       ; save sprite X position

  ; MoveSpriteRightLoop:
  ;   lda XPOS, x     ; load sprite X position
  ;   inx
  ;   CLC             ; make sure carry flag is set
  ;   ADC #$01        ; A = A + 1
  ;   STA $0200, x    ; save sprite X position
  ;   cpx #$28
  ;   bne MoveSpriteRightLoop  

  ReadRightDone:



  ; ; Joypad State controller
  ; .scope Joypad
  ;   down    = $21     ; Button "down" bitmaks, 1 means down & 0 means up.
  ;   pressed = $22     ; Button "pressed" bitmask, 1 means pressed this frame.
  ;   downTiles = $600  ; Holds tile values for the controlller state in the BG

  ;   .proc update
  ;     jsr read_joypad1
  ;     .ifndef VIDEO_DEMO_MODE
  ;       jsr compute_button_tiles
  ;     .endif
  ;     rts
  ;   .endproc

  ;   .proc read_joypad1
  ;     lda down
  ;     tay
  ;     lda #1
  ;     sta JOYPAD1
  ;     sta down
  ;     lsr
  ;     sta JOYPAD1
  ;   @loop:
  ;     lda JOYPAD1
  ;     lsr
  ;     rol down
  ;     bcc @loop
  ;     tya
  ;     eor down
  ;     and down
  ;     sta pressed
  ;     rts
  ;   .endproc

  ;   .proc compute_button_tiles
  ;     ldx #7
  ;     ldy down
  ;   @loop:
  ;     tya
  ;     lsr
  ;     tay
  ;     lda #$29
  ;     adc #0
  ;     sta downTiles, x
  ;     dex
  ;     bpl @loop
  ;     rts
  ;   .endproc
  ; .endscope
.endscope