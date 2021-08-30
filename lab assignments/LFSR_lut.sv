module LFSR_lut(
  input       [3:0] address,
  output logic[6:0] LFSR_taps
  );

// assumes test bench provides only 0 through 8 in data_mem[62]  
always_comb case(address)
  0: LFSR_taps = 7'h60;	
  1: LFSR_taps = 7'h48;
  2: LFSR_taps = 7'h78;
  3: LFSR_taps = 7'h72;
  4: LFSR_taps = 7'h6A;
  5: LFSR_taps = 7'h69;
  6: LFSR_taps = 7'h5C;
  7: LFSR_taps = 7'h7E;
  8: LFSR_taps = 7'h7B;
// error conditon -- should never occur, needed for completeness of always_comb
  default: LFSR_taps = 7'h0;   // or 8'hx, if you like
endcase
  
endmodule 



module lab_2_alg;

logic[6:0] LFSR_state[9][10], LFSR_taps;
logic[3:0] address;

LFSR_lut l1(.address, .LFSR_taps);

initial begin
  for(int l=0; l<9; l++)
    LFSR_state[l][0] = 7'b000_0001;   // put any nonzero value here
  for(int i=0; i<9; i++)  begin
    address = i; 
    for(int j=0; j<9; j++) begin
	   LFSR_state[i][j+1] = {LFSR_state[i][j]<<1,^(LFSR_taps & LFSR_state[i][j])};
       $displayb(LFSR_state[i][j+1]);
	end
	$display;
  end
end

endmodule