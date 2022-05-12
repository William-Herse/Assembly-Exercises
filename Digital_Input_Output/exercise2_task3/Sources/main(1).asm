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
ZERO        equ  $3F
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
            
            ldaa #$FF
            staa DDRB
            staa DDRJ
            staa DDRP
            ldaa #00
            staa PTJ
           
            
mainLoop:
                 
            ldaa #Seg1On
            staa PTP
            ldaa #FOUR
            staa PORTB
            
            BSR DELAY
            
            ldaa #Seg2On
            staa PTP
            ldaa #TWO
            staa PORTB
            
            BSR DELAY
            
            ldaa #Seg3On
            staa PTP
            ldaa #SEVEN
            staa PORTB
            
            BSR DELAY
            
            ldaa #Seg4On
            staa PTP
            ldaa #ONE
            staa PORTB
            
            BSR DELAY
            
            BRA mainLoop

START:                  
            BRA START

DELAY:
            LDX #$FF
            
SubDelay:   DEX 
            BNE SubDelay  
            RTS
                  

             
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
