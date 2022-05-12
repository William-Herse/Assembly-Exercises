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

string     FCC  "This is a valid string. There is a space after the full stop"
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
            
            LDX #string    ; load register x with pointer to the start of the string
            BRA Loop       ; Skip the incrementation of x
innerLoop:
            inx            ; increment x to the next character in the string
Loop:            
            LDAA x         ; load a with the memory at x
            
            cmpa #10      ; check if end of string
            BEQ Endloop    ; end program
            
            SUBA #97       ; check if less then 97 and thus not a lower case character
            BMI innerLoop  ; go to next charcter if so

            LDAA x         ; reset a to character at x
            SUBA #123      ; chcek if more then 123 and thus not a lower case character
            BGT innerLoop  ; go to next character if so
            
            LDAA x         ; Refresh a with the character at x
            SUBA #32       ; make it upper case
            STAA x         ; Store the upper case character in memory
            bra innerLoop  ; go to next character
                  
Endloop:               

            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
