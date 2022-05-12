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
input_string FCC "531917"  ;set the input value string
segvalues fcb ZERO, ONE,TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE ;set the checklist to check every ascii value
Stringlength fcb  $06     ;determines how many times it is gonna convert, for four 7 seg display.
seg_on      FCB   $0E,$0D,$0B,$07  ; set the lookup table for 7 Seg display on from left to right






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
            staa DDRB    ; configure portb as output
            staa DDRJ    ; Port J as output to enable LED
            staa DDRP    ; configure portP as output
            ldaa #00
            staa PTJ     ;to enable LEDS
            staa PTP     ;enable 7 seg
            

            
            LDAA #0       ;set a counter
            STAA Counter
            
            LDAA Stringlength  ; load the string length
            SUBA #4            ; subtract from 4 to check whether its gonna scroll to next
            STAA MaxVal        ; store in the max value counter
            
            
            
            LDX #input_string              ;convert the input_letter to the ascii
            ;assign A value to non ACSII
            ;increment through segvalues by A times
            
            LDAA Stringlength
convert:            
            LDY # segvalues  ;run through the checklist table to convert them into ASCII value
            LDAB x
            SUBB #$30   ; we find the difference between the ASCII value and the number itself is 30, so subtract from 30
            ABY
            
            LDAB y
             
            STAB x
            
            INX         ;move to the next checklist character to keep check
            dbne A,convert
            
               

                        
loop:
            
            LDX #input_string
            LDAB Counter        ; load the counter
            ABX
            LDD #1
            STD loopCounter 
        
            
Start:            
            LDY #seg_on        ;enable 7 seg on
            LDAB #04

sub_loop:
            LDAA X             ; load the address of input_string to a
            STAA PORTB         ; store it to portB
            LDAA Y             ; load the address of 7 seg on
            STAA PTP           ; store to portP
            
            
            
            INX                ;move to the next character
            INY                ;move to the bext 7 seg
            PSHY               ;save y's value in the stack
            PSHX               ;save x's value in the stack
            
            ldy #60000          
            ldx #50            ; set the delay time to 0.5 sec, to scroll it slowly
            bsr delay
            
            PULX               ;pull the x,y value out the stack
            PULY               
            
            dbne B,sub_loop    ;run the subloop again
            
            
            LDD loopCounter 
            DBNE d,Start
            
            JSR cmpsub
            
delay:                        ; delay function
            psha              ; 4 cycles needed
            pula              ; 4*60000*50*41 = 0.5 sec
            
            dbne y,delay
            
            dbne x, delay
            beq finish
            
            
            
finish:     
            rts

cmpsub:
            LDAA Counter      ;compare the counter to the maxvalue. does it reach the end of the string.
            CMPA MaxVal
            
            beq ProEnd        ; if yes, stop it.
            
            inc Counter       ; if not increment the counter
            bra loop          ; branch to the loop
ProEnd:     
            stop
 
         
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
