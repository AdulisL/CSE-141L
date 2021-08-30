// This file defines the parameters used in the alu
package ALU_def;
    typedef enum logic[2:0]{
	// R-type (bit 8:6 Opcode)
       ADD, // 0_00
	   XOR,	// 0_01
	   SHIFT, // 0_10
	   AND,	// 0_11
	// I-type (bit 8:6 Opcode)
	   LW,	// 1_00
	   SW,	// 1_01
	   BEQ,	// 1_10
	   STP	// 1_11
    } ALU_CTRL;
	

endpackage