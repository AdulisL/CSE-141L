// Create Date:    2017.01.25
// Edited:         2020.07.31
// Design Name:    data memory
// Module Name:    data_mem

module data_mem(
  input              CLK,
  input [7:0]        DataAddress,   // address pointer
  input              WriteEnMem,
  input [7:0]        DataIn,
  output logic[7:0]  DataOut);

  logic [7:0] Core [256];            // memory core

  always_comb
    DataOut = Core[DataAddress];

  always_ff @ (posedge CLK)
    if(WriteEnMem) 
      Core[DataAddress] <= DataIn;

endmodule