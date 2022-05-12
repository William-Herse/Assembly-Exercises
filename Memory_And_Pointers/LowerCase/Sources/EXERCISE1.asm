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

; variable/data section

 ifdef _HCS12_SERIALMON
            ORG $3FFF - (RAMEnd - RAMStart)
 else
            ORG RAMStart

 endif
 ; Insert here your data definition.
string FCC  "thIS iS AlSO a VALID input. that WiLL LOOK DIFFERENT when applying these Functions. good LUCK"
Blocker dc.b 10
    


; code section
            ORG   ROMStart


Entry:
_Startup:
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
            
            LDX #string       ; load into register x the pointer to the start of the string    ;
            BRA Loop          ; skip the increment line
innerLoop:
            inx
Loop:            
            LDAA x            ; load into a the value stored at memory location x
            
            cmpa #10         ; check to see if end of string
            BEQ Endloop       ; if it is not part of the string, end the function
            
            SUBA #65          ; check if less then 65 and thus not a capital letter
            BMI innerLoop     ; if so go to next letter

            LDAA x            ; reset A to the value stored at x
            SUBA #91          ; check if more then 91 and thus not a capital letter
            BGT innerLoop     ; If so go to next letter
            
            LDAA x            ; now that we have established that it is a capital letter, refresh A
            ADDA #32          ; Make the letter lowercase
            STAA x            ; store it in the memory location
            bra innerLoop     ; go to next letter
            
               
Endloop:               
         
            
            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
