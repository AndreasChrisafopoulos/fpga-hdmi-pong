// VGA timing controller based on horizontal and vertical FSMs.
// Generates HSYNC, VSYNC and active drawing signals for 640x480 resolution.
// Also computes VRAM addresses with 5× horizontal and vertical pixel replication.
module video_timing_FSMs(
    input            clk,
    input            rst,
    output wire      activedraw,
    output wire      hsync,
    output wire      vsync,
    output reg       new_frame,
    output reg [9:0] hcount,
    output reg [9:0] vcount
);


    // Horizontal timings
    localparam H_ACTIVE = 640;
    localparam H_FP     = 16;
    localparam H_SYNC   = 96;
    localparam H_BP     = 48;
    localparam H_TOTAL  = H_ACTIVE + H_FP + H_SYNC + H_BP;

    // Vertical timings
    localparam V_ACTIVE = 480;
    localparam V_FP     = 10;
    localparam V_SYNC   = 2;
    localparam V_BP     = 33;
    localparam V_TOTAL  = V_ACTIVE + V_FP + V_SYNC + V_BP;


    // FSM STATES (LOCALPARAMS)

    // Horizontal FSM states
    localparam HST_ACTIVE = 2'd0;
    localparam HST_FP     = 2'd1;
    localparam HST_SYNC   = 2'd2;
    localparam HST_BP     = 2'd3;

    // Vertical FSM states
    localparam VST_ACTIVE = 2'd0;
    localparam VST_FP     = 2'd1;
    localparam VST_SYNC   = 2'd2;
    localparam VST_BP     = 2'd3;

    
    // REGISTERS

    reg [1:0] hstate, hnext;
    reg [1:0] vstate, vnext;

    reg hsync_r, vsync_r, act_r;

    // 1) SEQUENTIAL STATE UPDATE
    always @(posedge clk ) begin
        if (rst) begin
            hstate <= HST_ACTIVE;
            vstate <= VST_ACTIVE;
        end else begin
            hstate <= hnext;
            vstate <= vnext;
        end
    end


    // 2) NEXT STATE LOGIC (NO ternary at all)
    always @(*) begin
        // default keep same state
        hnext = hstate;
        vnext = vstate;

        //       Horizontal FSM 
        case (hstate)

            HST_ACTIVE: begin
                if (hcount == H_ACTIVE-1)
                    hnext = HST_FP;
            end

            HST_FP: begin
                if (hcount == H_ACTIVE + H_FP - 1)
                    hnext = HST_SYNC;
            end

            HST_SYNC: begin
                if (hcount == H_ACTIVE + H_FP + H_SYNC - 1)
                    hnext = HST_BP;
            end

            HST_BP: begin
                if (hcount == H_TOTAL - 1)
                    hnext = HST_ACTIVE;
            end
        endcase

        //           Vertical FSM 
        if (hcount == H_TOTAL-1) begin   // advance vertical only at end-of-line
            case (vstate)

                VST_ACTIVE: begin
                    if (vcount == V_ACTIVE-1)
                        vnext = VST_FP;
                end

                VST_FP: begin
                    if (vcount == V_ACTIVE + V_FP - 1)
                        vnext = VST_SYNC;
                end

                VST_SYNC: begin
                    if (vcount == V_ACTIVE + V_FP + V_SYNC - 1)
                        vnext = VST_BP;
                end

                VST_BP: begin
                    if (vcount == V_TOTAL - 1)
                        vnext = VST_ACTIVE;
                end

            endcase
        end
    end

    // 3) COUNTERS
    always @(posedge clk ) begin
        if (rst) begin
            hcount <= 0;
            vcount <= 0;
        end else begin

            if (hcount == H_TOTAL-1) begin
                hcount <= 0;

                if (vcount == V_TOTAL-1)
                    vcount <= 0;
                else
                    vcount <= vcount + 1;

            end else begin
                hcount <= hcount + 1;
            end

        end
    end 


    // OUTPUT LOGIC (Moore FSM, no ternary)

    always @(*) begin

        // Horizontal sync (active high)
        if (hstate == HST_SYNC)
            hsync_r = 1;
        else
            hsync_r = 0;

        // Vertical sync (active high)
        if (vstate == VST_SYNC)
            vsync_r = 1;
        else
            vsync_r = 0;

        // Active drawing when both active
        if (hstate == HST_ACTIVE && vstate == VST_ACTIVE)
            act_r = 1;
        else
            act_r = 0;

    end


    always @(posedge clk) begin
        if(hcount == H_ACTIVE -1 && vcount == V_ACTIVE -1) 
            new_frame <=  1;
        else
            new_frame <= 0;
    end


    


    assign hsync = hsync_r;
    assign vsync = vsync_r;
    assign activedraw = act_r;

endmodule