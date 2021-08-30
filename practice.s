# tell the assembler what the hardware is
         .arch    armv8                  @ armv6 instruction set
        @  .cpu     cortex-a53             @ cpu type
         .syntax unified                 @ allow modern syntax

# List external functions called and #defines and "magic" numbers
         .extern strtoul
         .global name_function           @ make parseNum global for linking
         .equ    EXIT_SUCCSS, 0          @ exit successfully
         .equ    FP_OFFSET, 4            @ fp offset in frame
         .equ    S_EXTRACT, 31           @ passing #31
         .equ    BIAS, 127               @ bias for subtraction
         .equ    E_EXTRACT, 24           @ passing #24
         .equ    UNMASK, 0x00400000      @ unmasking hidden bitts
         .equ    NULL, 0                 @ '\0'
        
# Text segment
         .text                           @ start of the text segment
         .type  name_function, %function   @ define parseNum to be function


 name_function:
             push {fp, lr}           	@ stack frame register save
             add fp, sp, FP_OFFSET      @ locate frame pointer

# function to be filled ...






 done:    
             mov r0, EXIT_SUCCSS         @ set return to exit EXIT_SUCCSS
             sub sp, fp, FP_OFFSET       @ restore stack frame
             pop {fp, lr}	        	 @ remove stack frame
             bx  lr
 .end