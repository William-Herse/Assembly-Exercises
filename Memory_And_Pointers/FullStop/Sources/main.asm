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

            ORG RAMStart
 ; Insert here your data definition.

string FCC "thIS iS AlSO a VALID input. that WiLL LOOK DIFFERENT when applying these Functions. good LUCK"
Blocker dc.b 10

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
mainLoop:
            
            LDX #string   ; Load x with the pointer to the start of the string
            LDAB #2       ; Load B with the counter flag set to two so the first character is capitalised
            BRA Loop      ; Skip the step that increments the Pointer to the string
innerLoop:
            inx         ; Increment the point to the string to the next character
Loop:            
            LDAA x       ; Load A with the value stored in X memory address
            cmpa #10      ; Check if it is the end of the string
            BEQ Endloop  ;If so end of string end program
            
            SUBB #1 ;Check If Flag was previously Triggered one character before
            BEQ IncFlag ;If so increase flag by one
            ADDB #1     ; Else return the flag to its previous value
            SUBB #2     ; and then substract two to check if its been two characters since it was triggered
            BEQ Cap     ; if so, go to the capitalise function
            LDAB #0  ;Set flag back to zero
            
            SUBA #46 ;Check If Full Stop
            BEQ TriggerFlag ;If so trigger the flag
            
            BRA DeCap ; Go to the decapitalise function
            
            
IncFlag:
            INCB  ; Increase b by one
            INCB  ; Increase b by one
            BRA innerLoop  ; Go to next character
            
DeCap:
            LDAA x  ; Load A with the character
            SUBA #91;Check if its below 91
            BMI DeCap2; if so then Branch to check if higher then
            BRA innerLoop  ; If not go to next character
            
DeCap2:
           LDAA x   ; Load A with the character
           SUBA #64 ;Check if higher then 65
           BGT  DeCap3  ; If so go to the decapitlise method
           BRA innerLoop  ; else go to next character in string
           
DeCap3:   
           LDAA x ; Load A with the character
           ADDA #32 ; make it lower case
           STAA x   ; store the lower case character in the string
           
           BRA innerLoop   ; go to the next character

Cap:
           LDAA x    ; Load A with the character
           SUBA #123 ;Check if its below 123
           BMI Cap2  ;If it is then branch to check if higher then
           BRA innerLoop   ; else go to the next character
            
Cap2:
           LDAA x   ; Load A with the character
           SUBA #97 ;Check if higher then 97
           BGT Cap3   ; If so then branch to the the capitalisation function
           BRA innerLoop

Cap3:           
           LDAA x ;Load a with the charcter
           SUBA #32  ; make it into a capital letter
           STAA x  ; store the new character in the string
           
           BRA innerLoop   ; go to the next character 

            
TriggerFlag:
            LDAB #1 ;If so branch up to start and increment flag   
            BRA innerLoop                        
               
Endloop:                         
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
