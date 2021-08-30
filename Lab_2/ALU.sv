import Definitions::*;
module ALU(
  // input cin,
  input [2:0] OP,
  input [7:0] InputA, InputB,
  // input clk,
  output logic [7:0] Out,
  // output logic cout,
  output logic Zero
);

 op_mne op_mnemonic;		// type enum: used for convenient waveform 

  always_comb begin
    unique case (OP)
      k_ADD:    Out = InputA +  InputB;
      k_XOR:    Out = InputA ^  InputB;
      k_SHIFT:  Out = InputA << 1;
      k_AND:    Out = InputA &  InputB;
    default:  Out = 0;
    endcase
    // Zero = Out == 0;
  end
  always_comb							  // assign Zero = !Out;
    case(Out)
      'b0   : Zero = 1'b1;
	  default : Zero = 1'b0;
    endcase

  always_comb
    op_mnemonic = op_mne'(OP);			 // displays operation name in waveform viewer
endmodule