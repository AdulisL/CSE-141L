// CSE141L
import definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input[ 8:0] Instruction,	   // machine code
  output logic BranchAbs,
               BranchRel,
			   RegWrEn  ,	   // write to reg_file (common)
			   MemWrEn  ,	   // write to mem (store only)
			   LoadInst	,	   // mem or ALU to reg_file ?
			   Ack		,      // "done w/ program"
  output logic[1:0] PCTarg   
  );

assign MemWrEn   = Instruction[8:6]==3'b110;	  // store
assign RegWrEn   = Instruction[8:6]!=3'b110;	  // all other ops
assign LoadInst  = Instruction[8:6]==3'b111;
// reserve instruction = 9'b111111111; for Ack

// jump on right shift that generates a zero

// branch every time instruction = 9'b101??????;
// assign BranchRel = Instruction[8:6]==3'b101;

// route data memory --> reg_file for loads
//   whenever instruction = 9'b110??????; 
assign PCTarg  = Instruction[3:2];
assign Ack = &Instruction;

endmodule

