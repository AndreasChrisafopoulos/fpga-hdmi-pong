// TMDS transition minimization module
// Converts 8-bit input to 9-bit output minimizing transitions

module tm_choice (
    input  [7:0] data_in,
    output [8:0] q_m
);

    wire [3:0] ones = data_in[0] + data_in[1] + data_in[2] + data_in[3] + data_in[4] + data_in[5] + data_in[6] + data_in[7];

    wire case2 = (ones > 4) || ((ones == 4) && (data_in[0] == 0));

    wire b0 = data_in[0];
    wire b1 = case2 ? ~(data_in[1] ^ b0) : (data_in[1] ^ b0);
    wire b2 = case2 ? ~(data_in[2] ^ b1) : (data_in[2] ^ b1);
    wire b3 = case2 ? ~(data_in[3] ^ b2) : (data_in[3] ^ b2);
    wire b4 = case2 ? ~(data_in[4] ^ b3) : (data_in[4] ^ b3);
    wire b5 = case2 ? ~(data_in[5] ^ b4) : (data_in[5] ^ b4);
    wire b6 = case2 ? ~(data_in[6] ^ b5) : (data_in[6] ^ b5);
    wire b7 = case2 ? ~(data_in[7] ^ b6) : (data_in[7] ^ b6);

    assign q_m = {~case2, b7, b6, b5, b4, b3, b2, b1, b0};

endmodule



