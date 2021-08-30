/*
 * Filename: parseNum.s
 * Author: Meron Asfaw
 * Userid: masfaw
 * Date: 08/1/2021
 * Sources of help: CSE 30 SS1/2020
 */

# tell the assembler what the hardware is
         .arch    armv8                  @ armv6 instruction set
        @  .cpu     cortex-a53             @ cpu type
         .syntax unified                 @ allow modern syntax

# List external functions called and #defines and "magic" numbers
         .extern strtoul
         .global exractParts             @ make parseNum global for linking
         .equ    EXIT_SUCCSS, 0          @ exit successfully
         .equ    FP_OFFSET, 4            @ fp offset in frame
         .equ    S_EXTRACT, 31           @ passing #31
         .equ    BIAS, 127               @ bias for subtraction
         .equ    E_EXTRACT, 24           @ passing #24
         .equ    UNMASK, 0x00400000      @ unmasking hidden bitts
         .equ    NULL, 0                 @ '\0'
        
# Text segment
         .text                           @ start of the text segment
         .type  exractParts, %function   @ define parseNum to be function


 exractParts:
             push {fp, lr}           	@ stack frame register save
             add fp, sp, FP_OFFSET      @ locate frame pointer

             lsr r3, r0, S_EXTRACT

             lsl r2, r0, 1               @ extracting sign
             lsr r2, r2, E_EXTRACT       @ extracting exponent
             sub r2, r2, BIAS            @ subtraction 127

             add r0, r0, UNMASK          @ unmasking the hidden bitts
             str

 done:    
             mov r0, EXIT_SUCCSS         @ set return to exit EXIT_SUCCSS
             sub sp, fp, FP_OFFSET       @ restore stack frame
             pop {fp, lr}	         @ remove stack frame
             bx  lr
 .end