// Create Date:    2017.01.25
// Design Name:
// Module Name:    DataMem
// single address pointer for both read and write
// CSE141L
module DataMem #(parameter W=8, A=8)  (
  input                 Clk,
                        Reset,
                        WriteEn,
  input       [A-1:0]   DataAddress, // A-bit-wide pointer to 256-deep memory
  input       [W-1:0]   DataIn,		 // W-bit-wide data path, also
  output logic[W-1:0]   DataOut);

  logic [W-1:0] Core[2**A];			 // 8x256 two-dimensional array -- the memory itself
									 
  always_comb                        // reads are combinational and continuous
    DataOut = Core[DataAddress];

  always_ff @ (posedge Clk)		     // writes are sequential and conditional
    if(WriteEn) 
      Core[DataAddress] <= DataIn;

endmodule
