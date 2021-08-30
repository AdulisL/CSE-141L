#include <stdio.h>
#include <iostream>
#include <string.h>
// #include <bits>
using namespace std;

const char taps[] = {0x60, 0x48, 0x78, 0x72, 0x6A, 0x69, 0x5C, 0x7E, 0x7B};

int main() {
    // Initiation of Data
    char DataMem[] = "Mr. Watson, come here. I want to see you.";
    char *Dest;
    int len = sizeof(DataMem) / DataMem[0];
    
    // Encryption
    char *curr_LFSR = DataMem;  // representation of DM[64] starting state
    for (int i = 0; i < len; i++)
    {
        Dest[i] = DataMem[i] ^ (*curr_LFSR);
        *curr_LFSR = (*curr_LFSR << 1) | ((*curr_LFSR & taps[i])^(*curr_LFSR & taps[i]));
    }
    

    // Test for accessing DM
    for (int i = 0; i < len; i++) // sizeof(DataMem)/DataMem[0]
    {
        printf("Check %c", *curr_LFSR);
        curr_LFSR++;
    }
    

    printf("\nTest for reaching this line!\n");
    return 0;
}
