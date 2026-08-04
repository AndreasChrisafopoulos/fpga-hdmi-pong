`timescale 1ns/1ps

module tmds_encoder_tb;

  reg clk;
  reg rst;
  reg [7:0] data_in;
  reg [1:0] control_in;
  reg ve_in;
  wire [9:0] tmds_out;

  // parameters for sets //
  localparam SET_1_START = 0;
  localparam SET_2_START = 200;
  localparam SET_3_START = 399;
  localparam SET_4_START = 599;
  localparam SET_5_START = 799;
  localparam TOTAL_VECTORS = 999;

  // dut instantiation //
  tmds_encoder dut (
    .clk_in(clk),
    .rst_in(rst),
    .data_in(data_in),
    .control_in(control_in),
    .ve_in(ve_in),
    .tmds_out(tmds_out)
  );

  // instantiate vector module //
  tmds_vectors V();

  integer i;

  integer pass;
  integer fail;
  integer control_pass;
  integer control_fail;
  real rate;

  initial begin

    pass = 0; fail = 0; control_pass = 0; control_fail = 0;
    rst = 1; ve_in = 0; data_in = 0; control_in = 0;
    #20 rst = 0;

    // set 1 //

    @(negedge clk);
    ve_in = 1;

    for (i = SET_1_START; i < SET_2_START; i = i + 1) begin

        data_in = V.input_vec[i];

        @(negedge clk);

        if (tmds_out === V.output_vec[i]) begin
          $display("PASS: input=%h output=%h", V.input_vec[i], tmds_out);
          pass = pass + 1;
        end else begin
          $display("FAIL: input=%h expected=%h got=%h", V.input_vec[i], V.output_vec[i], tmds_out);
          fail = fail + 1;
        end
    end

    // ctrl 00 //

    ve_in = 0; 
    control_in = 2'b00; 
    data_in = 8'b0;

    @(negedge clk); 
    if (tmds_out == V.control_output_vec[0]) begin
      $display("Control 00: PASS");
      control_pass = control_pass + 1;
    end else begin
      $display("Control 00: FAIL");
      control_fail = control_fail + 1;
    end

    #1000; 

    // set 2 //

    @(negedge clk);
    ve_in = 1;

    for (i = SET_2_START; i < SET_3_START; i = i + 1) begin
        data_in = V.input_vec[i];

        @(negedge clk);

        if (tmds_out === V.output_vec[i]) begin
          $display("PASS: input=%h output=%h", V.input_vec[i], tmds_out);
          pass = pass + 1;
        end else begin
          $display("FAIL: input=%h expected=%h got=%h", V.input_vec[i], V.output_vec[i], tmds_out);
          fail = fail + 1;
        end
    end    

    // ctrl 01 //
    
    ve_in = 0; 
    control_in = 2'b01;
    data_in = 8'b0; 

    @(negedge clk); 
    if (tmds_out == V.control_output_vec[1]) begin
      $display("Control 01: PASS");
      control_pass = control_pass + 1;
    end else begin
      $display("Control 01: FAIL");
      control_fail = control_fail + 1;
    end

    #1000; 

    // set 3 //

    @(negedge clk);
    ve_in = 1;

    for (i = SET_3_START; i < SET_4_START; i = i + 1) begin
        data_in = V.input_vec[i];

        @(negedge clk);

        if (tmds_out === V.output_vec[i]) begin
          $display("PASS: input=%h output=%h", V.input_vec[i], tmds_out);
          pass = pass + 1;
        end else begin
          $display("FAIL: input=%h expected=%h got=%h", V.input_vec[i], V.output_vec[i], tmds_out);
          fail = fail + 1;
        end
    end    

    // ctrl 10 //

    ve_in = 0; 
    control_in = 2'b10;
    data_in = 8'b0;

    @(negedge clk); 
    if (tmds_out == V.control_output_vec[2]) begin
      $display("Control 10: PASS");
      control_pass = control_pass + 1;
    end else begin
      $display("Control 10: FAIL");
      control_fail = control_fail + 1;
    end

    #1000; 

    // set 4 //

    @(negedge clk);
    ve_in = 1;

    for (i = SET_4_START; i < SET_5_START; i = i + 1) begin
        data_in = V.input_vec[i];

        @(negedge clk);

        if (tmds_out === V.output_vec[i]) begin
          $display("PASS: input=%h output=%h", V.input_vec[i], tmds_out);
          pass = pass + 1;
        end else begin
          $display("FAIL: input=%h expected=%h got=%h", V.input_vec[i], V.output_vec[i], tmds_out);
          fail = fail + 1;
        end
    end    

    // ctrl 11 //

    ve_in = 0; 
    control_in = 2'b11;
    data_in = 8'b0;

    @(negedge clk); 
    if (tmds_out == V.control_output_vec[3]) begin
      $display("Control 11: PASS");
      control_pass = control_pass + 1;
    end else begin
      $display("Control 11: FAIL");
      control_fail = control_fail + 1;
    end

    #1000;          

    // set 5 //

    @(negedge clk);
    ve_in = 1;

    for (i = SET_5_START; i < TOTAL_VECTORS; i = i + 1) begin
        data_in = V.input_vec[i];

        @(negedge clk);

        if (tmds_out === V.output_vec[i]) begin
          $display("PASS: input=%h output=%h", V.input_vec[i], tmds_out);
          pass = pass + 1;
        end else begin
          $display("FAIL: input=%h expected=%h got=%h",
                     V.input_vec[i], V.output_vec[i], tmds_out);
          fail = fail + 1;
        end
    end    

    // print results //
    // a successful implementation should have ZERO fails //

    rate = (pass * 100.0/TOTAL_VECTORS);
    $display ("Pass: %0d out of %0d (%0.2f%% PASS rate)", pass, TOTAL_VECTORS, rate);
    $display ("Control Pass: %0d out of %0d", control_pass, 4);

    if ((fail == 0) && (control_fail == 0)) begin
      $display("TMDS ENCODER TEST: PASS");
      $finish;
    end else begin
      $fatal(1, "TMDS ENCODER TEST: FAIL (%0d data failures, %0d control failures)", fail, control_fail);
    end

  end

initial begin
  clk = 0;
  forever #5 clk = ~clk; // 100MHz;
end

endmodule

