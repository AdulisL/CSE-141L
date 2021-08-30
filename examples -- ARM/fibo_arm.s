/* Fibonacci generator, ARMSIM demo
*/
        .text
        .global _start
        .syntax unified

_start:
        mov r10, 10       /* counter = 10, Compute fib(10) */
        mov r1, 0         /* fib(0) = 0 */
        mov r2, 1         /* fib(1) = 1 */

fib:
        add r3, r1, r2    /* fib(n) = fib(n-1) + fib(n-2) */
        mov r1, r2        /* fib(n-1) = fib(n-2) */
        mov r2, r3        /* fib(n-2) = fib(n)   */
        subs r10, r10, 1  /* R10 = R0 - 1. Suffix 's' sets NZCV flags as well. */
        beq end           /* If 'Z' flag is set, branch to 'end' */
        bal fib           /* Branch always to 'fib' */

end:
        mov r0, r3        /* Final result is in R3 */
        mov r7, 1
        swi 0



/*
   0 1 1 2 3 5 8 13 21 34 55 89
*/