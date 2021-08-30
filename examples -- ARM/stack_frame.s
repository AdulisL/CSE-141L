/* Stack frame from Lec 01_ISA_Part2_ARM
translated into ARM
*/
mov r0, #0
mov r3, #0
sub fp, sp, #1024     // arbitrarily set frame pointer 256 words below stack pointer
sub sp, sp, #32	      // allocate frame
str fp, [sp, #24]	  // save frame pointer into frame
mov fp, sp			  // copy sp to fp
str r0, [fp, #8]      // write 0 into fp+8
mov r0, #1            // r0 = 1
str r0, [fp, #12] 
mov r0, #2
str r0, [fp, #16]
ldr r3, [fp, #12]
str r0, [fp, #16]                
add r0, r0, r3
str r0, [fp, #8]
ldr r0, [fp, #8]
mov sp, fp
ldr fp, [sp, #24]
add sp, sp, #32
swi 0