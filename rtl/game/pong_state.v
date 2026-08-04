// Pong game state control module.
// Finite state machine that controls menu display and
// one-player or two-player mode selection.
module pong_state(
    input clk,
    input rst,
    input btn1,
    input btn3,
    output reg menu,
    output reg one_player,
    output reg two_players
);
    localparam MENU = 2'b00;
    localparam MODE_ONE = 2'b01;
    localparam MODE_TWO = 2'b10;

    reg [1:0] curr_st, next_st;

    always @(posedge clk) begin
        if(rst)
            curr_st <= MENU;
        else
            curr_st <= next_st;
    end

    always @(*) begin
        next_st = curr_st;   
        case (curr_st)
            MENU: 
            begin
                if (btn1)
                    next_st = MODE_ONE;
                else if (btn3)
                    next_st = MODE_TWO;
                else
                    next_st = MENU;
            end
            MODE_ONE:
            begin
                next_st = curr_st;
            end
            MODE_TWO:
            begin
                next_st = curr_st;
            end
        endcase
    end

   always @(*) 
   begin
        case (curr_st)
            MENU: begin
                one_player = 0;
                two_players = 0;
                menu = 1;
            end
            MODE_ONE: begin
                menu = 0;
                one_player = 1;
                two_players = 0;
            end
            MODE_TWO: begin
                menu = 0;
                one_player = 0;
                two_players = 1;
            end
            default: begin
                menu = 0;
                one_player = 0;
                two_players = 0;
            end
        endcase
   end
            

            

endmodule