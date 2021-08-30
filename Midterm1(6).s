         MOV R0, #40      // R0 = a
         MOV R1, #25      // R1 = b
again:   CMP R0, R1
         BEQ halt
         BLT isLess
         SUB R0, R0, R1
         B again
isLess:  SUB R1, R1, R0
         B again
halt:      swi 0