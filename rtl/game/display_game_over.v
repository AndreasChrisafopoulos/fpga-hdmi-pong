// "Game Over" text rendering module.
// Generates centered RGB pixel output for a "GAME OVER" message
// using geometric letter primitives, enabled by a control signal.
module display_game_over(
    input [9:0] hcount,
    input [9:0] vcount,
    input enable,
    output [7:0]  red_out,
    output [7:0]  green_out,
    output [7:0]  blue_out
);

    function automatic inside_rect;
        input [9:0] x, y;
        input [9:0] rx, ry, rw, rh;
        begin
            inside_rect =
                (x >= rx) && (x < rx + rw) &&
                (y >= ry) && (y < ry + rh);
        end
    endfunction

    localparam LETTER_W = 24;
    localparam LETTER_H = 40;
    localparam THICK    = 4;
    localparam SPACE    = 8;

    localparam TEXT_W = 8*LETTER_W + 7*SPACE; // "GAMEOVER"
    localparam START_X = (640 - TEXT_W) / 2;
    localparam START_Y = (480 - LETTER_H) / 2;

    wire pixel_on;


     //  G 
    wire G =
        inside_rect(hcount, vcount, START_X+0, START_Y, THICK, LETTER_H) ||
        inside_rect(hcount,vcount,START_X+0,START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+0,START_Y+LETTER_H-THICK,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+LETTER_W-THICK,START_Y+20,THICK,20) ||
        inside_rect(hcount,vcount,START_X+12,START_Y+20,12,THICK);

    // ---- A ----
    wire A =
        inside_rect(hcount,vcount,START_X+1*(LETTER_W+SPACE)+0,START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+1*(LETTER_W+SPACE)+LETTER_W-THICK,START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+1*(LETTER_W+SPACE),START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+1*(LETTER_W+SPACE),START_Y+20,LETTER_W,THICK);

    // ---- M ----
    wire M =
        inside_rect(hcount,vcount,START_X+2*(LETTER_W+SPACE),START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+2*(LETTER_W+SPACE)+LETTER_W-THICK,START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+2*(LETTER_W+SPACE)+8,START_Y+8,THICK,32) ||
        inside_rect(hcount,vcount,START_X+2*(LETTER_W+SPACE)+12,START_Y+8,THICK,32);

    // ---- E ----
    wire E =
        inside_rect(hcount,vcount,START_X+3*(LETTER_W+SPACE),START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+3*(LETTER_W+SPACE),START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+3*(LETTER_W+SPACE),START_Y+18,20,THICK) ||
        inside_rect(hcount,vcount,START_X+3*(LETTER_W+SPACE),START_Y+LETTER_H-THICK,LETTER_W,THICK);

    // ---- O ----
    wire O =
        inside_rect(hcount,vcount,START_X+4*(LETTER_W+SPACE),START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+4*(LETTER_W+SPACE)+LETTER_W-THICK,START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+4*(LETTER_W+SPACE),START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+4*(LETTER_W+SPACE),START_Y+LETTER_H-THICK,LETTER_W,THICK);

    // ---- V ----
    wire V =
        inside_rect(hcount,vcount,START_X+5*(LETTER_W+SPACE),START_Y,THICK,36) ||
        inside_rect(hcount,vcount,START_X+5*(LETTER_W+SPACE)+LETTER_W-THICK,START_Y,THICK,36) ||
        inside_rect(hcount,vcount,START_X+5*(LETTER_W+SPACE)+8,START_Y+36,8,THICK);

    // ---- E ----
    wire E2 =
        inside_rect(hcount,vcount,START_X+6*(LETTER_W+SPACE),START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+6*(LETTER_W+SPACE),START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+6*(LETTER_W+SPACE),START_Y+18,20,THICK) ||
        inside_rect(hcount,vcount,START_X+6*(LETTER_W+SPACE),START_Y+LETTER_H-THICK,LETTER_W,THICK);

    // ---- R ----
    wire R =
        inside_rect(hcount,vcount,START_X+7*(LETTER_W+SPACE),START_Y,THICK,LETTER_H) ||
        inside_rect(hcount,vcount,START_X+7*(LETTER_W+SPACE),START_Y,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+7*(LETTER_W+SPACE)+LETTER_W-THICK,START_Y,THICK,20) ||
        inside_rect(hcount,vcount,START_X+7*(LETTER_W+SPACE),START_Y+20,LETTER_W,THICK) ||
        inside_rect(hcount,vcount,START_X+7*(LETTER_W+SPACE)+12,START_Y+24,THICK,16);

    assign pixel_on = enable && (G||A||M||E||O||V||E2||R);

    assign red_out   = pixel_on ? 8'hFF : 8'h00;
    assign green_out = pixel_on ? 8'hFF : 8'h00;
    assign blue_out  = pixel_on ? 8'hFF : 8'h00;

endmodule