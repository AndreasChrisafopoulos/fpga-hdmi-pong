// Top-level HDMI transmitter module.
// Generates pixel and serialization clocks, produces VGA timing and RGB data,
// and encodes/serializes them into TMDS signals for HDMI output.
module TOP_hdmi_pong_multiplayer (
    input clk,
    input rst,

    input up_btn,
    input down_btn,
    input up_btn2,
    input down_btn2,
    input [3:0] paddle_speed,
    input [3:0] puck_speed,
    input new_game_btn,

    output [2:0] hdmi_tx_p,
    output [2:0] hdmi_tx_n,
    output       hdmi_clk_p,
    output       hdmi_clk_n,

    output reg new_frame_LED,

    output an3, an2, an1, an0, 
    output a, b, c, d, e, f, g, dp

);
    wire rst_sync;
    wire pixel_clk, pixel_clk_x5; // 25.1785, 125.8928
    wire activedraw, hsync, vsync, new_frame;
    wire [9:0] hcount;
    wire [9:0] vcount;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    wire [9:0] tmds_10b [2:0];
    wire       tmds_signal [2:0];
    wire [7:0] score;

    
    // Clock generation (MMCM) 
    mmcm inst_mmcm(
        .clk(clk),
        .pixel_clk(pixel_clk),
        .pixel_clk_x5(pixel_clk_x5)
    );   

    synchronizer sync_rst(
        .clk(pixel_clk),
        .in(rst),
        .out(rst_sync)
    );

    // Video timing 
    video_timing_FSMs FSMs_inst(
        .clk(pixel_clk),
        .rst(rst_sync),
        .activedraw(activedraw),
        .hsync(hsync),
        .vsync(vsync),
        .new_frame(new_frame),
        .hcount(hcount),
        .vcount(vcount)
    );

    reg [5:0] frame_counter;

    always @(posedge pixel_clk) begin
        if (rst_sync) begin
            frame_counter <= 0;
            new_frame_LED <= 0;
        end else if (new_frame) begin
            if (frame_counter == 6'd59) begin
                frame_counter <= 0;
                new_frame_LED <= ~new_frame_LED;  // toggle
            end else begin
                frame_counter <= frame_counter + 1;
            end
        end
    end



    top_pong_fullmode top_pong_inst(
        .clk(pixel_clk),
        .rst(rst_sync),
        .up(up_btn),
        .down(down_btn),
        .up_2(up_btn2),
        .down_2(down_btn2),
        .paddle_speed(paddle_speed),
        .new_frame(new_frame),
        .hcount(hcount),
        .vcount(vcount),
        .puck_speed(puck_speed),
        .new_game(new_game_btn),

        .red(red),
        .green(green),
        .blue(blue),
        .score(score)
    );

    FourDigitLEDdriver display_score(
        .clk(clk),
        .reset(rst),
        .score(score),
        .mode(1'b1),
        .an1(an1),
        .an0(an0),
        .an2(an2),
        .an3(an3),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .dp(dp)
    );


   // TMDS encoding
    tmds_encoder tmds_red(
        .clk_in(pixel_clk), // your pixel clock
        .rst_in(rst_sync),// system reset
        .data_in(red),// 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2

        .tmds_out(tmds_10b[2])
    );

    tmds_encoder tmds_green(
        .clk_in(pixel_clk), // your pixel clock
        .rst_in(rst_sync),// system reset
        .data_in(green),// 8-bit value
        .control_in(2'b0),
        .ve_in(activedraw), // from part2

        .tmds_out(tmds_10b[1])
    );

    tmds_encoder tmds_blue(
        .clk_in(pixel_clk), // your pixel clock
        .rst_in(rst_sync), // system reset
        .data_in(blue), // 8-bit value
        .control_in({vsync, hsync}), // from part2
        .ve_in(activedraw), // from part2

        .tmds_out(tmds_10b[0])
    );


    // TMDS serialization & output buffers
    tmds_serializer red_ser(
        .clk_pixel_in(pixel_clk), // your pixel clock
        .clk_5x_in(pixel_clk_x5), //your x5 clock
        .rst_in(rst_sync), // system reset
        .tmds_in(tmds_10b[2]),

        .tmds_out(tmds_signal[2])
    );
    
    tmds_serializer green_ser(
        .clk_pixel_in(pixel_clk), // your pixel clock
        .clk_5x_in(pixel_clk_x5), //your x5 clock
        .rst_in(rst_sync), // system reset
        .tmds_in(tmds_10b[1]),

        .tmds_out(tmds_signal[1])
    );
    
    
    tmds_serializer blue_ser(
        .clk_pixel_in(pixel_clk), // your pixel clock
        .clk_5x_in(pixel_clk_x5), //your x5 clock
        .rst_in(rst_sync), // system reset
        .tmds_in(tmds_10b[0]),

        .tmds_out(tmds_signal[0])
    );

    OBUFDS OBUFDS_blue (.I(tmds_signal[0]), .O(hdmi_tx_p[0]), .OB(hdmi_tx_n[0]));
    OBUFDS OBUFDS_green(.I(tmds_signal[1]), .O(hdmi_tx_p[1]), .OB(hdmi_tx_n[1]));
    OBUFDS OBUFDS_red (.I(tmds_signal[2]), .O(hdmi_tx_p[2]), .OB(hdmi_tx_n[2]));
    OBUFDS OBUFDS_clock(.I(pixel_clk), .O(hdmi_clk_p),.OB(hdmi_clk_n));

endmodule