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
string FCC "This is a valid string. There is a space after the full stop" ;string is defined here
Blocker dc.b 10

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
mainLoop:
            

            LDX #string   ; Load x with the pointer for the string
            LDAB #1       ; Set b to the flag that represents if the previous character was a space 
            BRA Loop      ; skip first incrementation
innerLoop:
            inx           ; Increment x pointer on string
Loop:            
            LDAA x        ; Load A with the memory stored at x
            
            cmpa #10   ; Check if end of string (optional)
            BEQ Endloop ;If end of string end program
            
            SUBB #1  ;Check If Flag was previously Triggered
            BEQ Capitalise ;If so Capitalise the letter
            LDAB #0  ;Set flag back to zero
            
            SUBA #32 ;Check If Empty Space
            BEQ TriggerFlag ;If so trigger the flag
            
            LDAA x    ; Refresh A with character at x
            SUBA #65 ;Check if character is less then 65 and thus not a capital
            BMI innerLoop  ; go to next character if so

            LDAA x     ; Refresh A with character at x
            SUBA #90   ; Check if character is more then 90 and thus not a capital
            BGT innerLoop ; go to next character if so
            
            BRA LowerFunc  ; if character is a capital when it shouldnt be make it lower case
            
            
Capitalise:            
            SUBA #97  ; Check if  not lowercase
            BMI innerLoop   ; if so go to next character

            LDAA x  ; load a with character at x again
            SUBA #123 ; check if not lowercase
            BGT innerLoop  ; if so go to next character
            
            LDAA x  ;If is a lower case
            SUBA #32  ; Capitalise the letter
            STAA x    ;Store  new letter at to the string
            
            BRA innerLoop ;Move to next character in string
            
LowerFunc:
            LDAA x ; Load A with the value in memory point x
            ADDA #32  ; Increase the characters ascii value by 32 to make it lower case 
            STAA x    ; Store the new lowercase letter to the string
            BRA innerLoop  ; go to next character in string

            
TriggerFlag:
            LDAB #1 ;If so branch up to start and increment flag   
            BRA innerLoop   ; Go to next character in string                   
               
Endloop:                          
            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
