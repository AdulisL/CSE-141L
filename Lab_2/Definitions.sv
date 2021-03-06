//This file defines the parameters used in the alu
// CSE141L
package Definitions;
// Instruction map
    // R-type
    const logic [2:0]k_ADD    = 3'b000;
    const logic [2:0]k_XOR    = 3'b001;
    const logic [2:0]k_SHIFT  = 3'b010;
    const logic [2:0]k_AND    = 3'b011;
    // I-type
    const logic [2:0]k_LW     = 3'b100;
	const logic [2:0]k_SW     = 3'b101;
	const logic [2:0]k_BEQ    = 3'b110;
	const logic [2:0]k_STP    = 3'b111;
    
// enum names will appear in timing diagram
    typedef enum logic[2:0] {
        ADD, XOR, SHIFT, AND,
        LW, SW, BEQ, STP} op_mne;
// note: kADD is of type logic[2:0] (3-bit binary)
//   ADD is of type enum -- equiv., but watch casting
//   see ALU.sv for how to handle this   
endpackage // definitions