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
SCIStart    EQU  $2000
num         EQU  $1

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
Counter     DS.W 1
FiboRes     DS.W 1


            ORG SCIStart
String fcc "This is the string"
Null dc.b 13,10,0




; code section
            ORG   ROMStart
            
            


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
mainLoop:
            movb  #$00,SCI1BDH      ; Configure the serial output
            movb  #156,SCI1BDL
            movb  #$4c,SCI1CR1
            movb  #$0c,SCI1CR2

Start:
            bsr   delay              ; Branches to delay subroutine
            ldx   #SCIStart          ; Load x with the memory address to the start of the string
            ldab  #num
            
ReadMsg:
            ldaa  1,x+               ; load the string by each characters
            beq   CheckNum
            jsr   putcSCI1
            bra   ReadMsg
            
CheckNum:
            pshx                     ;read string and compare it to a newline character
            bsr   delay
            pulx
            LDAA x
            cmpa #13
            dbne  x, ReadMsg
            bra   Start

putcSCI1:
            brclr SCI1SR1,mSCI0SR1_TDRE,putcSCI1    ;
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
