// CSE141L
// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
//  in general, Output = f(Input);
import LUT_def::*; 
module LUT(
  input       [ 9:0] Addr,
  output logic[ 9:0] Target
  );

always_comb 
  case(Addr)		   //-16'd30;
	// LUT_ADD:    Target = 10'h3ff;  // -1
	// LUT_XOR:	  Target = 10'h003;
	// LUT_SHIFT:	Target = 10'h007;
  //...;
	default: Target = 10'h001;
  endcase

endmodule