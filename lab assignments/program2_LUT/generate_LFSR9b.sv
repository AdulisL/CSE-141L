/*
  CSE141L  Spring 2021
  This code generates values for lookup table for Programs 2 and 3
  Easy-to-use version accepts data_memory stored values directly, takes care of ^0x20 for you
  Address/pointer input = content of data_mem[64] * 16
  Data output = expected content of mem[73]
  
  Usage: connect data_memory data_out[6:0] to LUT address[10:4], followed by 4'b0 
  Compare output directly against content of data_mem[73], bits [6:0]
  If they match, the LFSR_tap pattern is LFSR_taps[0] = 7'h60	   // break
  If they don't, increment LUT address by 1 and repeat 			   // continue
     i.e., use {data_mem_data_out, 4'b0001} this time
  If these match, LFSR tap pattern = LFSR_taps[1] = 7'h48		   // break
  Etc.
  Notice there are 2048 lines (128 LFSR starting patterns, including the illegal 7'h0 ^ 7'h20
  There are 16 lines per starting pattern, of which only the first 9 represent real LFSR tap patterns    
*/
module LFSR9b;

logic[6:0] LFSRstart;
logic[6:0] LFSR_taps[9];
logic[6:0] LFSR_9[9];
int m;
initial begin
  m = $fopen("lut9.txt");
  LFSR_taps[0] = 7'h60;
  LFSR_taps[1] = 7'h48;
  LFSR_taps[2] = 7'h78;
  LFSR_taps[3] = 7'h72;
  LFSR_taps[4] = 7'h6A;
  LFSR_taps[5] = 7'h69;
  LFSR_taps[6] = 7'h5C;
  LFSR_taps[7] = 7'h7E;
  LFSR_taps[8] = 7'h7B;
			   
for(int k=0; k<128; k++) begin	  // starting LFSR state
  LFSRstart = k^7'h20;
  for(int i=0; i<16; i++) begin    // LFSR tap pattern number
    LFSR_9[i] = LFSRstart;
//	$writeb(LFSR_9[i]," ");
    for(int j=0; j<9; j++) begin	  // advance LFSR 9 transitions
	  #1 LFSR_9[i] = (^(LFSR_9[i] & LFSR_taps[i])) | (LFSR_9[i]<<1); 
    end
	  #1 $fwriteb(3,7'h20^LFSR_9[i]," ");
//    $displayb("");
//	$displayb(LFSR_9[i]);
	$fdisplayb(3,"");
  end
end
$fclose(m);
end
endmodule