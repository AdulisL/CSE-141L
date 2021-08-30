import Definitions::*;
// control decoder (combinational, not clocked)
// inputs from instrROM, ALU flags
// outputs to program_counter (fetch unit)
module Ctrl (
  input [2:0] OP,
  input[8:0] Instruction,	 // machine code
  output logic BranchEn
              //  RegWrEn,	 // write to reg_file (common)
			        //  MemWrEn, // write to mem (store only)
			        //  LoadInst, // mem or ALU to reg_file ?
			        //  Ack      // "done w/ program"
  // output logic[9:0] PCTarg  
  );
  
op_mne op_mnemonic;		// type enum: used for convenient waveform 

// assign LoadInst  = (OP == 3'b100);    // load
// assign MemWrEn   = (OP == 3'b101);	  // store
// assign RegWrEn   = (OP != 3'b101);	  // all other ops
// // branch every time instruction = 9'b110_??????;
assign BranchEn  = (OP == 3'b110);    // turns BEQ high
// assign PCTarg    = OP;

// jump on right shift that generates a zero
// always_comb
//   if(Instruction[2:0] ==  kBEQ)
//     Jump = 1;
//   else
//     Jump = 0;

// branch every time ALU result LSB = 0 (even)
// assign BranchEn = &OP;
assign Ack = &Instruction;
always_comb
    op_mnemonic = op_mne'(OP);			 // displays operation name in waveform viewer

endmodule