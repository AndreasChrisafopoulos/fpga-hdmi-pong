`timescale 1ns/1ps

module video_timing_tb;

  localparam H_ACTIVE = 640;
  localparam H_FP     = 16;
  localparam H_SYNC   = 96;
  localparam H_BP     = 48;
  localparam H_TOTAL  = H_ACTIVE + H_FP + H_SYNC + H_BP;

  localparam V_ACTIVE = 480;
  localparam V_FP     = 10;
  localparam V_SYNC   = 2;
  localparam V_BP     = 33;
  localparam V_TOTAL  = V_ACTIVE + V_FP + V_SYNC + V_BP;

  localparam FRAME_CYCLES = H_TOTAL * V_TOTAL;
  localparam FRAMES_TO_TEST = 2;

  reg clk;
  reg rst;

  wire       activedraw;
  wire       hsync;
  wire       vsync;
  wire       new_frame;
  wire [9:0] hcount;
  wire [9:0] vcount;

  integer cycle;
  integer errors;
  integer active_cycles;
  integer hsync_cycles;
  integer vsync_cycles;
  integer new_frame_pulses;
  integer expected_h;
  integer expected_v;
  reg expected_activedraw;
  reg expected_hsync;
  reg expected_vsync;
  reg expected_new_frame;

  video_timing_FSMs dut (
    .clk(clk),
    .rst(rst),
    .activedraw(activedraw),
    .hsync(hsync),
    .vsync(vsync),
    .new_frame(new_frame),
    .hcount(hcount),
    .vcount(vcount)
  );

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1'b1;
    errors = 0;
    active_cycles = 0;
    hsync_cycles = 0;
    vsync_cycles = 0;
    new_frame_pulses = 0;

    // Keep reset asserted long enough to initialize counters, states,
    // and the registered new_frame output deterministically.
    repeat (4) @(posedge clk);
    @(negedge clk);

    if ((hcount !== 10'd0) || (vcount !== 10'd0)) begin
      $display("RESET FAIL: hcount=%0d vcount=%0d", hcount, vcount);
      errors = errors + 1;
    end

    rst = 1'b0;

    // Sample on falling edges, halfway between DUT state updates.
    // At the first sample after reset release, the counters are (0, 0).
    for (cycle = 0; cycle < FRAMES_TO_TEST * FRAME_CYCLES; cycle = cycle + 1) begin
      expected_h = cycle % H_TOTAL;
      expected_v = (cycle / H_TOTAL) % V_TOTAL;

      expected_activedraw = (expected_h < H_ACTIVE) &&
                            (expected_v < V_ACTIVE);
      expected_hsync = (expected_h >= H_ACTIVE + H_FP) &&
                       (expected_h <  H_ACTIVE + H_FP + H_SYNC);
      expected_vsync = (expected_v >= V_ACTIVE + V_FP) &&
                       (expected_v <  V_ACTIVE + V_FP + V_SYNC);

      // new_frame is registered from the previous pixel position.
      // It is therefore high for one cycle at (640, 479).
      expected_new_frame = (expected_h == H_ACTIVE) &&
                           (expected_v == V_ACTIVE - 1);

      if (hcount !== expected_h) begin
        if (errors < 20)
          $display("HCOUNT FAIL at cycle %0d: expected=%0d got=%0d",
                   cycle, expected_h, hcount);
        errors = errors + 1;
      end

      if (vcount !== expected_v) begin
        if (errors < 20)
          $display("VCOUNT FAIL at cycle %0d: expected=%0d got=%0d",
                   cycle, expected_v, vcount);
        errors = errors + 1;
      end

      if (activedraw !== expected_activedraw) begin
        if (errors < 20)
          $display("ACTIVE FAIL at (%0d,%0d): expected=%b got=%b",
                   expected_h, expected_v, expected_activedraw, activedraw);
        errors = errors + 1;
      end

      if (hsync !== expected_hsync) begin
        if (errors < 20)
          $display("HSYNC FAIL at (%0d,%0d): expected=%b got=%b",
                   expected_h, expected_v, expected_hsync, hsync);
        errors = errors + 1;
      end

      if (vsync !== expected_vsync) begin
        if (errors < 20)
          $display("VSYNC FAIL at (%0d,%0d): expected=%b got=%b",
                   expected_h, expected_v, expected_vsync, vsync);
        errors = errors + 1;
      end

      if (new_frame !== expected_new_frame) begin
        if (errors < 20)
          $display("NEW_FRAME FAIL at (%0d,%0d): expected=%b got=%b",
                   expected_h, expected_v, expected_new_frame, new_frame);
        errors = errors + 1;
      end

      if (activedraw === 1'b1)
        active_cycles = active_cycles + 1;
      if (hsync === 1'b1)
        hsync_cycles = hsync_cycles + 1;
      if (vsync === 1'b1)
        vsync_cycles = vsync_cycles + 1;
      if (new_frame === 1'b1)
        new_frame_pulses = new_frame_pulses + 1;

      @(negedge clk);
    end

    if (active_cycles != FRAMES_TO_TEST * H_ACTIVE * V_ACTIVE) begin
      $display("ACTIVE COUNT FAIL: expected=%0d got=%0d",
               FRAMES_TO_TEST * H_ACTIVE * V_ACTIVE, active_cycles);
      errors = errors + 1;
    end

    if (hsync_cycles != FRAMES_TO_TEST * V_TOTAL * H_SYNC) begin
      $display("HSYNC COUNT FAIL: expected=%0d got=%0d",
               FRAMES_TO_TEST * V_TOTAL * H_SYNC, hsync_cycles);
      errors = errors + 1;
    end

    if (vsync_cycles != FRAMES_TO_TEST * V_SYNC * H_TOTAL) begin
      $display("VSYNC COUNT FAIL: expected=%0d got=%0d",
               FRAMES_TO_TEST * V_SYNC * H_TOTAL, vsync_cycles);
      errors = errors + 1;
    end

    if (new_frame_pulses != FRAMES_TO_TEST) begin
      $display("NEW_FRAME COUNT FAIL: expected=%0d got=%0d",
               FRAMES_TO_TEST, new_frame_pulses);
      errors = errors + 1;
    end

    $display("--------------------------------------------------");
    $display("Cycles checked:      %0d", FRAMES_TO_TEST * FRAME_CYCLES);
    $display("Frames checked:      %0d", FRAMES_TO_TEST);
    $display("Active-video cycles: %0d", active_cycles);
    $display("HSYNC-high cycles:   %0d", hsync_cycles);
    $display("VSYNC-high cycles:   %0d", vsync_cycles);
    $display("new_frame pulses:    %0d", new_frame_pulses);
    $display("--------------------------------------------------");

    if (errors == 0) begin
      $display("VIDEO TIMING TEST: PASS");
      $finish;
    end else begin
      $fatal(1, "VIDEO TIMING TEST: FAIL (%0d errors)", errors);
    end
  end

endmodule
