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
IN_ON       equ  $00
IN_OFF      equ  $01



; variable/data section

 ifdef _HCS12_SERIALMON
            ORG $3FFF - (RAMEnd - RAMStart)
 else
            ORG RAMStart
 endif
 ; Insert here your data definition.
Counter     DS.W 1
MaxVal     DS.W 1
loopCounter DS.W 1
input_string FCC "531917"
segvalues fcb ZERO, ONE,TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE
Stringlength fcb  $06 
seg_on      FCB   $0E,$0D,$0B,$07






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
            
mainLoop:
            
            ldaa #$FF
            staa DDRB
            staa DDRJ
            staa DDRP
            ldaa #00
            staa PTJ
            staa PTP
            
            ;convert the input_letter to the ascii
            ;assign A value to non ACSII
            ;increment through segvalues by A times
            
            LDAA #0
            STAA Counter
            
            LDAA Stringlength
            SUBA #4
            STAA MaxVal
            
            
            
            LDX #input_string 
            
            LDAA Stringlength
convert:            
            LDY # segvalues
            LDAB x
            SUBB #$30
            ABY
            
            LDAB y
             
            STAB x
            
            INX
            dbne A,convert
            
               

                        
loop:
            
            LDX #input_string
            LDAB Counter
            ABX
            LDD #1
            STD loopCounter 
        
            
Start:            
            LDY #seg_on
            LDAB #04

sub_loop:
            LDAA X
            STAA PORTB
            LDAA Y
            STAA PTP
            
            
            
            INX
            INY
            PSHY
            PSHX
            
            ldy #60000  
            ldx #50
            bsr delay
            
            PULX
            PULY
            
            dbne B,sub_loop
            
            
            LDD loopCounter 
            DBNE d,Start
            
            JSR cmpsub
            
delay: 
            psha
            pula
            
            dbne y,delay
            
            dbne x, delay
            beq finish
            
            
            
finish:     
            rts

cmpsub:
            LDAA Counter
            CMPA MaxVal
            
            beq ProEnd
            
            inc Counter
            bra loop
ProEnd:     stop
 
         
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
