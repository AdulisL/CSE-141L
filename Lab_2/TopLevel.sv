// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only	
import Definitions::*;									   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

wire [ 2:0]   OP;
wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        MemWriteEn,	   // data_memory write enable
			RegWrEn,
			LoadInst,	   // reg_file write enable
            BranchEn,	   // to program counter: branch enable
            // Jump,	       // to program counter: jump 
			Zero;		   // ALU output = 0 flag
logic[15:0] CycleCt;	   // standalone; NOT PC!

assign OP = Instruction[8:6];
assign LoadInst     = (Instruction[8:6] == 3'b100);    // load
assign MemWriteEn   = (Instruction[8:6] == 3'b101);    // store
assign RegWrEn      = (Instruction[8:6] != 3'b101);    // all other ops
// branch every time instruction = 9'b110_??????;
assign BranchEn     = (Instruction[8:6] == 3'b110);    // turns BEQ high
assign Ack          = &Instruction;

// Control decoder
  Ctrl Ctrl1 (
	.OP  (OP),
	.Instruction  (Instruction),  // from instr_ROM
	.BranchEn     (BranchEn   )  // to PC
	// .RegWrEn      (RegWrEn    )	,  // register file write enable
	// .MemWrEn      (MemWriteEn ) ,  // data memory write enable
    // .LoadInst     (LoadInst   ) ,  // selects memory vs ALU output as data input to reg_file
    // .PCTarg       (PCTarg     ) ,    
    // .Ack          (Ack        )	   // "done" flag
  );
// Lookup table to handle 10-bit program counter jumps w/ only 2 bits
LUT LUT1(.Addr         (PgmCtr),
         .Target       (PCTarg )
    );
// Fetch = Program Counter + Instruction ROM
// Program Counter
  InstFetch IF1 (
	.Reset       (Reset   ) , 
	.Start       (Start   ) ,  // SystemVerilg shorthand for .halt(halt), 
	.Clk         (Clk     ) ,  // (Clk) is required in Verilog, optional in SystemVerilog
	// .BranchAbs   (Jump    ) ,  // jump enable
	.BranchRelEn (BranchEn) ,  // branch enable
	.ALU_flag	 (Zero    ) ,
    .Target      (PCTarg  ) ,
	.ProgCtr     (PgmCtr  )	   // program count = index to instruction memory
	);					  

//   assign BranchEn = (Instruction[8:6] == 3'b110); // turns BEQ high
// instruction ROM
  InstROM #(.W(9)) IR1(
	.InstAddress   (PgmCtr), 
	.InstOut       (Instruction)
	);

//   assign LoadInst = (Instruction[8:6] == 3'b100);  // calls out load specially
//   assign RegWrEn = (Instruction[8:6] == 3'b100);  // 

// reg file
	RegFile #(.W(8),.D(3)) RF1 (
		.Clk    				,
		.WriteEn   (RegWrEn)    , 
		.RaddrA    (Instruction[5:3]),  //concatenate with 0 to give us 4 bits
		.RaddrB    (Instruction[2:0]), 
		.Waddr     (Instruction[5:3]),  // mux above
		.DataIn    (RegWriteValue), 
		.DataOutA  (ReadA        ), 
		.DataOutB  (ReadB		 )
	);
// one pointer, two adjacent read accesses: (optional approach)
//	.raddrA ({Instruction[5:3],1'b0});
//	.raddrB ({Instruction[5:3],1'b1});

    assign InA = ReadA;	      // connect RF out to ALU in
	assign InB = ReadB;
	// assign MemWriteEn = (Instruction[8:6] == 3'b101); // mem_store command
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
	
    
	ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .OP  (Instruction[8:6]),
	  .Out     (ALU_out),	//regWriteValue),
	  .Zero(Zero)
	  );
  
	assign MemWriteValue = ALU_out;  // 2:1 switch into reg_file
	DataMem DM1(
		.DataAddress  (ReadA)    , 
		.WriteEn      (MemWriteEn), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue), 
		.Clk          (Clk),
		.Reset		  (Reset)
	);
	

op_mne op_emum;		// type enum: used for convenient waveform 
always_comb
    op_emum = op_mne'(OP);	// displays operation name in 

// count number of instructions executed
always_ff @(posedge Clk)
  if (Start == 1)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt + 16'b1;

endmodule