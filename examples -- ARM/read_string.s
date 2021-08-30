.equ SWI_PrStr, 0x69 @ Write a null-ending string
.equ SWI_RdStr, 0x6a @ Write a null-ending string
.equ SWI_Open,  0x66 @ Open a file
.equ SWI_Close, 0x68 @ Close a flie
_read:
     ldr  r0, =InFileName
   	 mov  r1,#0
	 swi  SWI_Open
     ldr  r0, =InFileHandle   @r0 points to the input file handle
     ldr  r0, [r0]            @r0 has the input file handle
@     ldr  r1, =String         @r1 points to the input string
     ldr  r2, =128            @r2 has the max size of the input string
     swi  SWI_RdStr           @read a string from the input file
     cmp  r0,#0               @no characters read means EOF
     beq  _exit               @so close and exit

@     ldr  r0, =String
@     mov  r1, r0
charloop:
     ldrb r2, [r0]
     cmp  r2, #0
     beq  endofstring
     cmp  r2, #'z'
     bgt  skip
     cmp  r2, #'a'
     bge  lower
     cmp  r2, #'Z'
     bgt  skip
     cmp  r2, #'A'
     bge  copy
     cmp  r2, #' '
     beq  copy
     bal  skip
 lower:
     sub  r2, r2, #0x20
 copy:
     strb r2, [r1], #1
 skip:
     add  r0, r0, #1
     bal  charloop
 endofstring:
     strb r2, [r1]            @ copy the terminating zero

     ldr  r0, =OutFileHandle  @r0 points to the output file handle
     ldr  r0, [r0]            @r0 has the output file handle
@     ldr  r1, =String         @r1 points to the output string
@     swi  SWI_PrStr           @write the null terminated string
                              @
     ldr  r1, =CRLF           @r1 points to the CRLF string
     swi  SWI_PrStr           @write the null terminated string
                              @
     bal  _read               @read the next line  
_exit:
     BX   lr
InFileHandle: .skip 4
OutFileHandle: .skip 4
CRLF: .asciz "\n"
InFileName: .asciz "whatin.txt"
