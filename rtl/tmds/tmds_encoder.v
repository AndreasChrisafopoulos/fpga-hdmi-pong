// TMDS encoder for HDMI/DVI transmission.
// Encodes 8-bit video data or control symbols into 10-bit TMDS words.
// Implements running disparity control to minimize transitions and DC imbalance
module tmds_encoder (
    input         clk_in,
    input         rst_in,
    input   [7:0]  data_in,
    input   [1:0]  control_in,
    input          ve_in,
    output reg  [9:0]  tmds_out
);

    wire [8:0] q_m;

    tm_choice tm_choice_inst (
        .data_in(data_in),
        .q_m(q_m)
    );

    // Count ones/zeros in q_m[7:0]
    wire [3:0] ones_qm = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];

    wire [3:0] zeros_qm = 8 - ones_qm;

    reg signed [4:0] tally;

    always @(posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            tmds_out <= 10'b0000000000;
            tally    <= 0;

        end else begin
            if (!ve_in) begin
                // Control period
                tally <= 0;

                case (control_in)
                    2'b00: tmds_out <= 10'b1101010100;
                    2'b01: tmds_out <= 10'b0010101011;
                    2'b10: tmds_out <= 10'b0101010100;
                    2'b11: tmds_out <= 10'b1010101011;
                endcase

            end else begin
                //           CONDITION 2 
                if ((tally == 0) || (ones_qm == zeros_qm)) begin

                    tmds_out[9]   <= ~q_m[8];
                    tmds_out[8]   <=  q_m[8];
                    tmds_out[7:0] <= (q_m[8] ? q_m[7:0] : ~q_m[7:0]);

                    if (q_m[8])
                        tally <= tally + (ones_qm - zeros_qm);
                    else
                        tally <= tally + (zeros_qm - ones_qm);


                end else begin
                    //       CONDITION 3 
                    if ( (tally > 0 && ones_qm > zeros_qm) || (tally < 0 &&  ones_qm < zeros_qm) ) begin

                        // TRUE branch
                        tmds_out[9]   <= 1'b1;
                        tmds_out[8]   <= q_m[8];
                        tmds_out[7:0] <= ~q_m[7:0];

                        tally <= tally +(q_m[8] << 1) + zeros_qm - ones_qm ;
                    end else begin
                        // FALSE branch
                        tmds_out[9]   <= 1'b0;
                        tmds_out[8]   <= q_m[8];
                        tmds_out[7:0] <=  q_m[7:0];

                        tally <= tally - (!(q_m[8]) << 1) - zeros_qm + ones_qm ;
                    end
                end
            end
        end
    end

endmodule
