
 MOV R0, #40      @ R0 is a
        MOV R1, #25      @ R1 is b
again:   CMP R0, R1
        SUBGT R0, R0, R1
        SUBLT R1, R1, R0
        BNE again
halt:    B halt