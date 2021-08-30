module LFSR7 (
  input       clk,
              reset,
  input [6:0] init,	  // from data_memory[63]
			  taps,   // from data_memory[62]
  output logic[6:0] state
);

  logic[6:0] next_state;

  always @(posedge clk)
    if(reset)
	  state <= init;
	else
	  state <= next_state;

  always_comb 
    next_state = {state[5:0],^(taps&state)};
//    next_state = (state<<1) | (^(taps&state));

endmodule