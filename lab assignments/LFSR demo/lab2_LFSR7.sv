/* Linear Feedback Shift Register hardware accelerator
CSE141L
You may incorporate this into your hardware design
instead of doing this operation in software in your
main ALU. Either appraoch is acceptable.
*/
module lab2_LFSR7 (
  input       clk,
// controls -- likely from Ctrl.sv or similar instruction decoding block
              load_state,   // initialize to desired starting state       
			  load_taps,    // set feedback tap pattern (9 to choose from)
			  enable_adv,   // run/pause
  input [6:0] state0,       // from data_memory[63]	-- starting state
			  taps,         // from data_memory[62]	-- feedback pattern
  output logic[6:0] state	// output, to ALU perhaps?
);

  logic[6:0] next_state;
  logic[6:0] tapsq;         // working feedback tap value

  always @(posedge clk)
    if(load_state)			// initialize LFSR
	  state <= state0;	    // read from data_mem[63] in program 1
	else if(enable_adv)
	  state <= next_state;	// no-op or halt if enable_adv = 0
  always @(posedge clk)
    if(load_taps)		    // update or initialize taps
	  tapq <= taps;			// read from data mem[62] in program 1

  always_comb 
    next_state = {state[5:0],^(tapsq&state)};
//    next_state = (state<<1) | (^(taps&state));

endmodule