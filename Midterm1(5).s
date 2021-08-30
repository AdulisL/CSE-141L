        @  MOV R0, #100      // R0 = a
        @  MOV R1, #25       // R1 = b
         CMP R0, R1
         BLE isLesOrEq
again:   SUB R0, R0, R1
         CMP R0, #55
         BLT again
         SUB R1, R1, #1
isLesOrEq:  ADD R1, R1, #44
halt:      swi 0