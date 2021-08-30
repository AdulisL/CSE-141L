// Create Date:    15:50:22 10/02/2016 
// Design Name: 
// Module Name:    InstROM 
// Project Name:   CSE141L
// Tool versions: 
// Description: Verilog module -- instruction ROM template	
//	 preprogrammed with instruction values (see case statement)
//
// Revision: 
//
module InstROM #(parameter A=10, W=9) (
  input       [A-1:0] InstAddress,
  output logic[W-1:0] InstOut);
	 
// Instruction format: {4bit opcode, 3bit rs or rt, 3bit rt, immediate, or branch target}
	 
//  always_comb 
//	case (InstAddress)
// opcode = 0 add, rd = 0,  rt = 0, rs = 1
//	  0 : InstOut = 'b0_00_000001;  // add r0 and r1 to r0  
// opcode = 1 xor, rd = rs ^ rt 
     
//	  1 : InstOut = 'b0_01_001001;  // r0 = r2 ^ r1
		
// opcode = 2 shift, rs = 0, amount = max-15
//	  2 : InstOut = 'b0_10_00_0001;  // left shift reg 0 by 1
		
// opcode = 3 and, rs = 1, rt = 2
//      3 : InstOut = 'b0_11_001001;  // r0 = r1 & r2
		
// opcode = 7 halt
//	  4 : InstOut = '1;  // equiv to 9'b1_11_111111  halt
//	  default : InstOut = 'b0_00_000000;
//    endcase

// alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
  logic[W-1:0] inst_rom[2**(A)];
  always_comb InstOut = inst_rom[InstAddress];
 
  initial begin		   // load from external text file
  	$readmemb("test.txt", inst_rom);
  end 
  
endmodule
