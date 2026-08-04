// Rectangular sprite rendering module.
// Generates RGB pixel output for a solid-colored rectangular sprite
// based on current screen coordinates and sprite position.
module block_sprite #(
    parameter SPRITE_WIDTH  = 32,
    parameter SPRITE_HEIGHT = 32
)(
    input  [9:0] hcount_in,
    input  [9:0]  vcount_in,
    input  [10:0] sprite_x,
    input  [9:0]  sprite_y,
    output [7:0]  red_out,
    output [7:0]  green_out,
    output [7:0]  blue_out
);
    localparam [7:0] WHITE = 8'hFF;
    localparam [7:0] BLACK = 8'h00;

    wire inside_sprite;

    assign inside_sprite =
        (hcount_in >= sprite_x) &&
        (hcount_in <  sprite_x + SPRITE_WIDTH) &&
        (vcount_in >= sprite_y) &&
        (vcount_in <  sprite_y + SPRITE_HEIGHT);

    assign red_out   = inside_sprite ? WHITE : BLACK;
    assign green_out = inside_sprite ? WHITE : BLACK;
    assign blue_out  = inside_sprite ? WHITE : BLACK;


endmodule
