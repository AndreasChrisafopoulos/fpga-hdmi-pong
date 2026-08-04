// Paddle movement control module.
// Updates the vertical paddle position based on user input,
// movement speed, frame timing, and screen boundary limits.
module paddle_logic#(
    parameter Y_MAX = 479,
    parameter PADDLE_HEIGHT = 100
)(
    input clk,
    input rst,
    input new_game,
    input game_over,
    input up,
    input down,
    input [3:0] paddle_speed,
    input new_frame,
    output reg [9:0] paddle_y

);  
    wire at_top_limit;
    wire at_bottom_limit;

    assign at_bottom_limit = (paddle_y + PADDLE_HEIGHT + paddle_speed > Y_MAX);
    assign at_top_limit = (paddle_y < paddle_speed);

    always @(posedge clk ) begin
        if (rst) 
            paddle_y <= 10'd190;
        else if (new_game)
            paddle_y <= 10'd190;
        else if (new_frame && !game_over) 
        begin
            if (up) 
            begin
                if (at_top_limit)
                    paddle_y <= 0;
                else
                    paddle_y <= paddle_y - paddle_speed;
            end 
            
            if(down)
            begin
                if (at_bottom_limit)
                    paddle_y <= Y_MAX - PADDLE_HEIGHT;
                else
                    paddle_y <= paddle_y + paddle_speed; 
            end
        end
    end

endmodule