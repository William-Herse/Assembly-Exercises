;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data
SCIStart    equ  $2000
IN_ON       equ  $01
IN_OFF      equ  $00

; variable/data section

            ORG SCIStart
String FCC "ThIs"
             
            
            
            ORG RAMStart
 ; Insert here your data definition.
FiboRes     DS.W 1


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
mainLoop:
            movb  #$00,SCI1BDH
            movb  #156,SCI1BDL
            movb  #$4c,SCI1CR1
            movb  #$0c,SCI1CR2
            
            ldaa #00
            staa DDRH

Start:
            
            ldx #String
            
            
LoadMsg:
            jsr getcSCI1
            cmpa #13
            beq Init
            staa 1, x+
            bra LoadMsg     
            
getcSCI1:   
            brclr SCI1SR1,mSCI1SR1_RDRF, getcSCI1
            
            ldaa SCI1DRL
            
            rts
            
;Determine State of Button            
Init:      
            STAA x
            
            
            LDAB #IN_ON
inner:      CMPB PTH
            
            BEQ SpaceFollow
            
            JSR CapSub
         
            BRA Skip

SpaceFollow:
           
            JSR SpaceSub            
            
Skip:            
; Output                       
            jsr   delay
            ldx   #SCIStart
            
            
ReadMsg:
            ldaa  1,x+
            cmpa #13
            beq   CheckNum
            jsr   putcSCI1
            bra   ReadMsg
            
CheckNum:
            
            LDAA  #13
            jsr   putcSCI1
            
            pshx
            jsr   delay
            pulx
            bra   Start
             
                    

SpaceSub:

            LDX #String
            LDAB #1
            BRA Loop
innerLoop:
            inx
Loop:            
            LDAA x
            
            CMPA #13
            
            BEQ EndLoop ;If end of string end program
            
            SUBB #1 ;Check If Flag was previously Triggered
            BEQ Capitalise;If so Capitalise the letter
            LDAB #0  ;Set flag back to zero
            
            SUBA #32 ;Check If Empty Space
            BEQ TriggerFlag ;If so trigger the flag
            
            LDAA x
            SUBA #97 ;Check if already Caps
            BMI LowerFunc

            LDAA x
            SUBA #123
            BGT LowerFunc
            
            BRA innerLoop
            
            
Capitalise:            
            SUBA #97 ;Check if already Caps
            BMI innerLoop

            LDAA x
            SUBA #123
            BGT innerLoop
            
            LDAA x ;If not Capitalise the Letter
            SUBA #32 
            STAA x
            
            BRA innerLoop ;Move to next character in string
            
LowerFunc:
            LDAA x ;If not Capitalise the Letter
            ADDA #32 
            STAA x
            BRA innerLoop

            
TriggerFlag:
            LDAB #1 ;If so branch up to start and increment flag   
            BRA innerLoop                        
               
EndLoop:    
            RTS

CapSub:
            
            LDX #String
            BRA Loop1
innerLoop1:
            inx

Loop1:
            LDAA x
            
            BEQ EndLoop1
            
            SUBA #97 ;Check if already Caps
            BMI innerLoop1

            LDAA x
            SUBA #123
            BGT innerLoop1
            
            LDAA x ;If not Capitalise the Letter
            SUBA #32 
            STAA x
            
            BRA innerLoop1 ;Move to next character in string
EndLoop1:            
            RTS

putcSCI1:
            brclr SCI1SR1,mSCI0SR1_TDRE,putcSCI1
            staa  SCI1DRL
            rts
            
delay:
            ldy   #50
            ldx   #65535
            
delayloop:
            psha
            pula
            dbne  x, delayloop
            ldx   #60000
            dbne  y, delayloop
            
            rts                  


;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
