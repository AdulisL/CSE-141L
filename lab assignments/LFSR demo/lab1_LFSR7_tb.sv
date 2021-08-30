module LFSR7_tb();

// connections to DUT
  logic       clk   = 'b0,
              reset = 1'b1;
  logic [6:0] init  = 7'b0000001,	  // 
              taps[9];	  //   
  wire  [6:0] state[9];
  assign taps[0] = 7'h60;
  assign taps[1] = 7'h48;
  assign taps[2] = 7'h78;
  assign taps[3] = 7'h72;
  assign taps[4] = 7'h6A;
  assign taps[5] = 7'h69;
  assign taps[6] = 7'h5C;
  assign taps[7] = 7'h7E;
  assign taps[8] = 7'h7B;

  integer fl;
// instantiate DUT
  genvar ct;
  generate 
    for(ct=0; ct<9; ct++) 
      LFSR7 L(.clk, .reset, .init, 
     .taps(taps[ct]), .state(state[ct]));
  endgenerate

  always begin
	#5ns clk = 1'b1;
	#5ns clk = 1'b0;
    if(!reset) begin
	  for(int i=0;i<9;i++) $fwrite(fl," %b",state[i]);
	  $fdisplay(fl,"");
	end

  end

  initial begin
    fl = $fopen("LFSR_test.txt","w");
	#20ns reset = 1'b0;
    #1320ns $fclose(fl); 
    $stop;
  end

endmodule