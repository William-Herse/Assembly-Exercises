# Exercise 1

Set the string in the variable section at the top of the code to change the output. All testing includes changing the base string into different combinations to ensure proper edge testing of the functions, which allowed us to identify bugs in the code. 

Set the string in the variable section at the top of the code to change the output.

## Task 1:

The pointer to the start of the string is loaded into memory, inner loop is used to increment the memory position. Within loop the letters are lowered in case. First the value at the memory position is loaded, if it is the end of string or capital letter the program is ended or moved along respectively. The letter is then lowered and stored back in the same memory position, and the program moves along.

## Task 2:

The pointer to the start of the string is loaded into memory, inner loop is used to increment the memory position. Within loop the letters are capitalised. First the value at the memory position is loaded, if it is the end of string or lowercase letter the program is ended or moved along respectively. The letter is then capitalised and stored back in the same memory position, and the program moves along.

## Task 3:

The pointer to the start of the string is loaded into memory, b is used to determine if previous character is a space, innerloop is used to increment memory position. In loop the value of the memory position is loaded, it is then checked if it is end of string (ends program), if the flag is triggered (then checked if lowercase, sent to capitalise to set to higher case), if empty space (trigger flag). If the character is an uppercase when it should not be it is sent to lowerfunc where it is lowered in case.

## Task 3:

Mainloop loads the pointer to the start of the string, b is used as a flag for capitalising. Innerloop is used to increment memory. Loop is used to check for end of string and the value of the flag to determine what action to take. Incflag increments the flag, decap1/2/3 checks if the character can be lowered if so it is, cap1/2/3 checks if the character can be capitalised if so it is. Triggerflag is used to set the flag to 1.


# Exercise 2

Testing included setting different numbers, whilst for task 5 changing the length of the string to longer and shorter variations to ensure the program is functioning to spec.

## Task 3:

At startup the 7-seg and button is configured. Mainloop, checks if the button is pressed, then turns on the first led if pressed, checks again then flips the second led if pressed and so on for the third and fourth led. It then restarts after the 4th press. Init and later functions are used to determine if the button is pushed or not, it includes a delay sub routine.

## Task 4:

The input string can be changed at the variable definition at the start of the code. Mainloop, the 7-seg is configured and the string pointer is loaded into memory. Convert, function converts all the ascii values to the appropriate 7-seg display values. Loop is the start of the display functions. It loads the seg value then displays the number, runs delay function then moves to the next character. This is looped infinitely.

## Task 5:

The input string can be changed at the variable definition at the start of the code. Mainloop configures the leds and sets the value for the string length. Convert takes the ascii values and converts them to their appropriate 7-seg display values. Loop is the start of the display functions. The pointer to the display values is looped through only looking at 4 values after all have been displayed the pointer is incremented to display the last 3 plus the next letter in the string. This continues until all letters are displayed.

# Exercise 3:

Testing included changing the string to includes the full range of ascii characters to ensure it can receive and display each one. Tested string length and the result of overflow.

## Task 1:

The input string can be changed at variable definition at the start of the code. Mainloop, the serial output is configured. The pointer to the string is loaded and the message is read to the output. The delay function is used to ensure the message is sent once every second. 

## Task 2/3:

Mainloop, the serial output is configured. The delay function is run, the pointer to the string is loaded. Loadmsg, if input is clear loops until finds character and stores at the memory. The loadmsg function is continually looped until it receives a return character at which point it stops.

## Task 4:

Mainloop, the serial output is configured. Loadmsg is run checking terminal until it receives an input storing it in memory. Once a return character is received it moves to readmsg, the values at the memory location are sent to the display until a return character is received at which point the whole program is run again in a continuous loop.

# Exercise 4:

Testing included changing the input to a wide range of inputs, such that absolute edge cases were tested to ensure the code functions to spec. issues were encountered with memory overflow when the input was too large.

Mainloop, the serial output is configured. Loadmsg is run checking terminal until it receives an input storing it in memory. Once a return character is received the program moves to init, this is used to determine the state of the button. If it on it moves to spacefollow, which converts all letters following a space to uppercase, it not it moves to capsub which capitalises all letters. Spacefollow leads to spacesub which uses exercise 1 to find if each letter needs to be capitilised (if it followed a space). Capsub leads to capitalise which again uses exercise 1 to capitalise each letter. After the required functions are run the display functions are run. The values at the memory location are sent to the display until a return character is received at which point the whole program is run again in a continuous loop.
