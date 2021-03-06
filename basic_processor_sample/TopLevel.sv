// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input        Reset,	   // init/reset, active high
			     Start,    // start next program
	             Clk,	   // clock -- posedge used inside design
    output logic Ack	   // done flag from DUT
    );

wire [ 9:0] PgmCtr,        // program counter
			PCTarg;
wire [ 1:0] TargSel;       // which of 4 jump/branch options?
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] RegWriteValue, // data in to reg file
            MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
wire        MemWrite,	   // data_memory write enable
			RegWrEn,	   // reg_file write enable
			Zero,		   // ALU output = 0 flag
			Odd,           // ALU output[0] 
			Parity,        // parity of ALU output 
            Jump,	       // to program counter: jump 
            BranchEn;	   // to program counter: branch enable
logic[15:0] CycleCt;	   // standalone; NOT PC!

// Fetch stage = Program Counter + Instruction ROM
  ProgCtr PC1 (		             // this is the program counter module
	.Reset        (Reset   ) ,   // reset to 0
	.Start        (Start   ) ,   // SystemVerilog shorthand for .grape(grape) is just .grape 
	.Clk          (Clk     ) ,   //    here, (Clk) is required in Verilog, optional in SystemVerilog
	.BranchAbs    (BranchAbs) ,  // jump enable
	.BranchRel    (Odd     ) ,  // branch enable
    .Target       (PCTarg  ) ,   // "where to?" or "how far?" during a jump or branch
	.ProgCtr      (PgmCtr  )	 // program count = index to instruction memory
	);					  

// Lookup table to handle 10-bit program counter jumps w/ only 2 bits
LUT LUT1(.Addr         (TargSel ) ,
         .Target       (PCTarg  )
    );

// instruction memory -- holds the machine code pointed to by program counter
  InstROM #(.W(9)) IR1(
	.InstAddress  (PgmCtr     ) , 
	.InstOut      (Instruction)
	);

// Decode stage = Control Decoder + Reg_file
// Control decoder
  Ctrl Ctrl1 (
	.Instruction  (Instruction) ,  // from instr_ROM
	.BranchAbs    (BranchAbs  ) ,  // to PC to handle jump/branch instructions
	.BranchRel    (BranchRel  )	,  // to PC
	.RegWrEn      (RegWrEn    )	,  // register file write enable
	.MemWrEn      (MemWrite   ) ,  // data memory write enable
    .LoadInst     (LoadInst   ) ,  // selects memory vs ALU output as data input to reg_file
    .PCTarg       (TargSel    ) ,    
    .Ack          (Ack        )	   // "done" flag
  );

// reg file
	RegFile #(.W(8),.A(3)) RF1 (			  // D(3) makes this 8 elements deep
 	  .Clk    				  ,
	  .WriteEn   (RegWrEn)    , 
	  .RaddrA    (Instruction[5:3]),        //concatenate with 0 to give us 4 bits
	  .RaddrB    (Instruction[2:0]), 
	  .Waddr     (Instruction[5:3]), 	      // mux above
	  .DataIn    (RegWriteValue) , 
	  .DataOutA  (ReadA        ) , 
	  .DataOutB  (ReadB		 )
	);
/* one pointer, two adjacent read accesses: 
  (sample optional approach)
	.raddrA ({Instruction[5:3],1'b0});
	.raddrB ({Instruction[5:3],1'b1});
*/
    assign InA = ReadA;						  // connect RF out to ALU in
	assign InB = ReadB;	          			  // interject switch/mux if needed/desired
// controlled by Ctrl1 -- must be high for load from data_mem; otherwise usually low
	assign RegWriteValue = LoadInst? MemReadValue : ALU_out;  // 2:1 switch into reg_file
    ALU ALU1  (
	  .InputA  (InA),
	  .InputB  (InB), 
	  .SC_in   (1'b1),
	  .OP      (Instruction[8:6]),
	  .Out     (ALU_out),                    //regWriteValue),
	  .Zero	   (Zero),                       // status flag; may have others, if desired
      .Odd     (Odd),
	  .Parity  (Parity)
	  );
  
	DataMem DM1(
		.DataAddress  (ReadA)    , 
		.WriteEn      (MemWrite), 
		.DataIn       (MemWriteValue), 
		.DataOut      (MemReadValue), 
		.Clk 		  		     ,
		.Reset		  (Reset)
	);
	
/* count number of instructions executed
      not part of main design, potentially useful
      This one halts when Ack is high  
*/
always_ff @(posedge Clk)
  if (Reset)	   // if(start)
  	CycleCt <= 0;
  else if(Ack == 0)   // if(!halt)
  	CycleCt <= CycleCt+16'b1;

endmodule