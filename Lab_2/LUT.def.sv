
package LUT_def;
    // LUT index
    typedef enum {
        LUT_ADD = 0,
        LUT_XOR = 1,
        LUT_SHIFT = 2,
        LUT_AND = 3,
        LUT_LW = 4,
        LUT_SW = 5,
        LUT_BEQ = 6,
        LUT_STP = 7
    } LUT_TYPE;

    // LUT[opcode][imm] => value
    const logic[7:0] kLookupTable[2:0][4:0]; 

endpackage
