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
String DS.W 100
Null dc.b 13,10,0





; code section
            ORG   ROMStart
            
            


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts

mainLoop:

            movb #$00,SCI1BDH      ;set up the configuration of baud rate
            movb #156,SCI1BDL
            movb #$4c,SCI1CR1      ;8bits, enable address mark wake up
            movb #$0c,SCI1CR2      ;enable transitter and receiver
            
Start:            
            
            ldx #String             ;load string
            
            
LoadMsg:
            jsr getcSCI1
            cmpa #13                ;compare to a newline character and wait for the new input
            beq endPro
            staa 1, x+
            bra LoadMsg     
            
getcSCI1:   
            brclr SCI1SR1,mSCI1SR1_RDRF, getcSCI1      ;check if RDRF bit is set
            
            ldaa SCI1DRL                               ;load input value to a 
            
            rts 

delay:
            ldy #50                                     ;set delay function
            ldx #65535
            
delayloop:
            psha
            pula
            
            dbne x, delayloop
            ldx #60000
            dbne y,delayloop
            
            rts
            
endPro:
           
            ldx   #SCIStart
            ldab  #num
            
ReadMsg:
            ldaa  1,x+
            beq   Start                                ;load input string
            jsr   putcSCI1
            bra   ReadMsg
             

putcSCI1:
            brclr SCI1SR1,mSCI0SR1_TDRE,putcSCI1               ;check if TDRE bit is set
            staa  SCI1DRL                                      ;store input to a 
            rts
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
