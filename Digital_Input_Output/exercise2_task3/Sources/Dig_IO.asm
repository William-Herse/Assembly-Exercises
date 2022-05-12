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
ZERO        equ  $3F    ; 7 Segment Display look up table in hex
ONE         equ  $06
TWO         equ  $5B
THREE       equ  $4F
FOUR        equ  $66
FIVE        equ  $6D
SIX         equ  $7D
SEVEN       equ  $07
EIGHT       equ  $7F
NINE        equ  $6F
Seg1On      equ  $0E
Seg2On      equ  $0D
Seg3On      equ  $0B
Seg4On      equ  $07
IN_ON       equ  $00
IN_OFF      equ $01



; variable/data section

 ifdef _HCS12_SERIALMON
            ORG $3FFF - (RAMEnd - RAMStart)
 else
            ORG RAMStart
 endif
 ; Insert here your data definition.
Counter     DS.W 1
FiboRes     DS.W 1
input_string fcc "4271"



; code section
            ORG   ROMStart


Entry:
_Startup



            ; remap the RAM &amp; EEPROM here. See EB386.pdf
 ifdef _HCS12_SERIALMON
            ; set registers at $0000
            CLR   $11                  ; INITRG= $0
            ; set ram to end at $3FFF
            LDAB  #$39
            STAB  $10                  ; INITRM= $39

            ; set eeprom to end at $0FFF
            LDAA  #$9
            STAA  $12                  ; INITEE= $9


            LDS   #$3FFF+1        ; See EB386.pdf, initialize the stack pointer
 else
            LDS   #RAMEnd+1       ; initialize the stack pointer
 endif

            CLI                     ; enable interrupts
            
            ldaa #$FF     ;Configure 7-segments and button registers
            staa DDRB
            staa DDRJ
            staa DDRP
            ldaa #00
            staa PTJ
            staa DDRH
            
            
           
                        
mainLoop:
             

            BSR Init         ; Branch to the sub routine that is constantly checking if the button is pressed
                 
            ldaa #Seg1On     ; Load the configuration to turn the first 7-seg on
            staa PTP         ; store that in the register
            ldaa #FOUR       ; load the configuration to set the LEDs to four
            staa PORTB       ; store in the register
            
            BSR Init         ; Branch to the sub routine that is constantly checking if the button is pressed
            
            
            ldaa #Seg2On     ; Load the configuration to turn the second 7-seg on
            staa PTP         ; store that in the register
            ldaa #TWO        ; load the configuration to set the LEDs to two
            staa PORTB       ; store in the register
            
            BSR Init         ; Branch to the sub routine that is constantly checking if the button is pressed
            
            
            ldaa #Seg3On     ; Load the configuration to turn the third 7-seg on
            staa PTP         ; store that in the register
            ldaa #SEVEN      ; load the configuration to set the LEDs to seven
            staa PORTB       ; store in the register
            
            BSR Init         ; Branch to the sub routine that is constantly checking if the button is pressed
            
            
            ldaa #Seg4On     ; Load the configuration to turn the fourth 7-seg on
            staa PTP         ; store that in the register
            ldaa #ONE        ; load the configuration to set the LEDs to one
            staa PORTB       ; store in the register
            
            BSR Init
                             ; Branch to the sub routine that is constantly checking if the button is pressed
            
            ldaa #00         ; load configuration to turn everything off
            staa PTP         ; Store in both registers
            staa PORTB
            
            BRA mainLoop     ; Return to start of the loop 

Init:      
            
            LDAB #IN_ON       ; Load b with the configuration to see if the button is on
inner:      CMPB PTH          ; Compare to the button input register
            BNE  inner        ; If not, compare again
            BSR DELAY         ; Else, run a delay subroutine
            BSR But_Off       ; Then run the sub routine to check that the button is no longer pressed
            RTS               ; Go to next number

But_Off:    
            LDAB #IN_OFF      ; Load b with the configuration to see if the button is off
inner2:     CMPB PTH          ; compare to the input register
            BNE  inner2       ; If not keep comparing
            RTS               ; else return to the main init sub routine

DELAY:                        ; simple delay function subroutine
            LDY #$FF
XDelay:     LDX #$FF
            
SubDelay:   DEX 
            BNE SubDelay
            DEY
            BNE XDelay
              
            RTS
                  

             
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
