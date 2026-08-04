// Menu screen text rendering module.
// Renders a centered "MENU" title and selectable game mode options
// using geometric letter primitives, enabled by a control signal.
module display_menu(
    input  [9:0] hcount,
    input  [9:0] vcount,
    input        enable,
    output [7:0] red_out,
    output [7:0] green_out,
    output [7:0] blue_out
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

    //  BASIC SIZES 
    localparam LW = 28;   // letter width
    localparam LH = 48;   // letter height
    localparam T  = 5;    // thickness
    localparam S  = 10;   // space

    //  POSITIONS
    localparam MENU_X = (640 - (4*LW + 3*S)) / 2;
    localparam MENU_Y = 80;

    localparam OPT_X  = (640 - (2*LW + S)) / 2;
    localparam P1_Y   = 230;
    localparam P2_Y   = 300;
    localparam BR_W = 10;   // width of "["
    localparam GAP  = 6;

    localparam BTN_X = OPT_X + 2*LW + 2*S;  // next to "1 P"



    // ===== MENU =====
    wire M =
        inside_rect(hcount,vcount,MENU_X, MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+LW-T, MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+8, MENU_Y+8, T, LH-8) ||
        inside_rect(hcount,vcount,MENU_X+12, MENU_Y+8, T, LH-8);

    wire E =
        inside_rect(hcount,vcount,MENU_X+(LW+S), MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+(LW+S), MENU_Y, LW, T) ||
        inside_rect(hcount,vcount,MENU_X+(LW+S), MENU_Y+LH/2, LW-8, T) ||
        inside_rect(hcount,vcount,MENU_X+(LW+S), MENU_Y+LH-T, LW, T);

    wire N =
        inside_rect(hcount,vcount,MENU_X+2*(LW+S), MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+2*(LW+S)+LW-T, MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+2*(LW+S)+12, MENU_Y+8, T, LH-8);

    wire U =
        inside_rect(hcount,vcount,MENU_X+3*(LW+S), MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+3*(LW+S)+LW-T, MENU_Y, T, LH) ||
        inside_rect(hcount,vcount,MENU_X+3*(LW+S), MENU_Y+LH-T, LW, T);

  //  1 P 
    wire ONE_P =
        // 1
        inside_rect(hcount,vcount,OPT_X, P1_Y, T, LH) ||

        // P
        inside_rect(hcount,vcount,OPT_X+LW+S, P1_Y, T, LH) ||
        inside_rect(hcount,vcount,OPT_X+LW+S+LW-T, P1_Y, T, LH/2) ||
        inside_rect(hcount,vcount,OPT_X+LW+S, P1_Y, LW, T) ||
        inside_rect(hcount,vcount,OPT_X+LW+S, P1_Y+LH/2-T, LW, T)||

        // [ 
        inside_rect(hcount,vcount, BTN_X, P1_Y, T, LH) ||
        inside_rect(hcount,vcount, BTN_X, P1_Y, BR_W, T) ||
        inside_rect(hcount,vcount, BTN_X, P1_Y+LH-T, BR_W, T) ||

        // b (lowercase)
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P1_Y, T, LH) ||   // |        
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P1_Y+LH-T, LW/2, T) ||         
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P1_Y+LH/2-T, LW/2, T) ||  
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2-T, P1_Y+LH/2, T, LH/2)||    


        // 1
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2+GAP, P1_Y, T, LH) ||


        // ]
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP, P1_Y, T, LH) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP-BR_W, P1_Y, BR_W, T) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP-BR_W, P1_Y+LH-T, BR_W, T);




    //  2 P 
    wire TWO_P =
        // 2
        inside_rect(hcount,vcount,OPT_X, P2_Y, LW, T) ||
        inside_rect(hcount,vcount,OPT_X+LW-T, P2_Y, T, LH/2) ||
        inside_rect(hcount,vcount,OPT_X, P2_Y+LH/2-T, LW, T) ||
        inside_rect(hcount,vcount,OPT_X, P2_Y+LH/2, T, LH/2) ||
        inside_rect(hcount,vcount,OPT_X, P2_Y+LH-T, LW, T) ||

        // P
        inside_rect(hcount,vcount,OPT_X+LW+S, P2_Y, T, LH) ||
        inside_rect(hcount,vcount,OPT_X+LW+S+LW-T, P2_Y, T, LH/2) ||
        inside_rect(hcount,vcount,OPT_X+LW+S, P2_Y, LW, T) ||
        inside_rect(hcount,vcount,OPT_X+LW+S, P2_Y+LH/2-T, LW, T)||

         // [ 
        inside_rect(hcount,vcount, BTN_X, P2_Y, T, LH) ||
        inside_rect(hcount,vcount, BTN_X, P2_Y, BR_W, T) ||
        inside_rect(hcount,vcount, BTN_X, P2_Y+LH-T, BR_W, T) ||

        // b (lowercase)
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P2_Y, T, LH) ||           
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P2_Y+LH-T, LW/2, T) ||         
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP, P2_Y+LH/2-T, LW/2, T) ||  
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2-T, P2_Y+LH/2, T, LH/2)||    


        // 3
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2+GAP, P2_Y, LW/2, T) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2+GAP, P2_Y+LH/2-T, LW/2, T) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2+GAP, P2_Y+LH-T, LW/2, T) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW/2+GAP+LW/2-T, P2_Y, T, LH) ||

        // ]
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP, P2_Y, T, LH) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP-BR_W, P2_Y, BR_W, T) ||
        inside_rect(hcount,vcount, BTN_X+BR_W+GAP+LW+2*GAP-BR_W, P2_Y+LH-T, BR_W, T);

    wire pixel_on = enable && (M||E||N||U || ONE_P || TWO_P);

    assign red_out   = pixel_on ? 8'hFF : 8'h00;
    assign green_out = pixel_on ? 8'hFF : 8'h00;
    assign blue_out  = pixel_on ? 8'hFF : 8'h00;

endmodule
