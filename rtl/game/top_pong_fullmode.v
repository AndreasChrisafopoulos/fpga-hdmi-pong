module top_pong_fullmode (
    input clk, // pixel clock //
    input rst,
    input up,
    input down,
    input up_2,
    input down_2,
    input [3:0] paddle_speed,
    input new_frame,
    input [9:0] hcount,
    input [9:0] vcount,
    input [3:0] puck_speed,
    input new_game,
    output [7:0] red,
    output [7:0] green,
    output [7:0] blue,
    output reg [7:0] score
);

    localparam PADDLE_X1 = 0;
    localparam PADDLE_X2 = 629;
    localparam PADDLE_HEIGHT = 100;
    localparam PADDLE_WIDTH = 10;
    localparam PUCK_SIZE = 32;
    localparam Y_MAX = 479;
    localparam X_MAX = 639;

    wire [9:0] paddle_y1;
    wire [9:0] paddle_y2;
    
    reg [9:0] puck_y;
    reg [10:0] puck_x;

    // Game state
    reg game_over;
    reg move_right, move_up;

    // Collision flags
    reg hit_up, hit_down;
    reg hit_right, hit_paddle;
    reg will_game_over;

    wire menu, one_player, two_players;

    //LEFT PADDLE    PLAYER 1
    paddle_logic left_paddle(
        .clk(clk),
        .rst(rst),
        .new_game(new_game),
        .game_over(game_over),
        .up(up),
        .down(down),
        .paddle_speed(paddle_speed),
        .new_frame(new_frame),

        .paddle_y(paddle_y1)
    );

    //RIGHT PADDLE    PLAYER 2
    paddle_logic right_paddle(
        .clk(clk),
        .rst(rst),
        .new_game(new_game),
        .game_over(game_over),
        .up(up_2),
        .down(down_2),
        .paddle_speed(paddle_speed),
        .new_frame(new_frame),

        .paddle_y(paddle_y2)
    );

    //GAME FSM
    pong_state inst_pong_state(
        .clk(clk),
        .rst(rst),
        .btn1(up),
        .btn3(down),
        .menu(menu),
        .one_player(one_player),
        .two_players(two_players)
    );

// --------------------------------------------------------PUCK LOGIC-----------------------------------------------------------------------------
    wire hit_right_paddle;
    wire hit_right_wall;
    wire player_one_losses;
    wire player_two_losses;

    assign hit_right_paddle  = (move_right && (puck_x + PUCK_SIZE + puck_speed >= PADDLE_X2) && puck_y + PUCK_SIZE > paddle_y2 && puck_y < paddle_y2 + PADDLE_HEIGHT);
    assign hit_right_wall    = (puck_x + PUCK_SIZE + puck_speed >= X_MAX && move_right);
    assign player_one_losses = (puck_x <= puck_speed + PADDLE_X1 + PADDLE_WIDTH - 5);
    assign player_two_losses = (puck_x + PUCK_SIZE + puck_speed >= PADDLE_X2 + 5 );

    // COLLISION DETECTION (combinational)
    always @(*) begin
        hit_right      = 0;
        hit_up         = 0;
        hit_down       = 0;
        hit_paddle     = 0;
        will_game_over = 0;

        if (!game_over) 
        begin
            if ((hit_right_wall && one_player) || (hit_right_paddle && two_players))  
                hit_right = 1;

            else if (
                !move_right &&
                puck_x   <= PADDLE_X1 + PADDLE_WIDTH +puck_speed &&
                puck_y + PUCK_SIZE > paddle_y1 &&
                puck_y < paddle_y1 + PADDLE_HEIGHT
            )
                hit_paddle = 1;

            else if ( ( player_one_losses && one_player ) || ( player_two_losses && two_players ) || (player_one_losses && two_players) ) 
                will_game_over = 1;

            if (puck_y <= puck_speed && move_up)
                hit_up = 1;
            else if (puck_y + PUCK_SIZE + puck_speed >= Y_MAX && !move_up)
                hit_down = 1;
        end
    end

    // FIND DIRECTION
    always @(posedge clk) begin
        if (rst ) begin
            move_right <= hcount[0];
            move_up    <= hcount[1];
            game_over  <= 1'b0;
        end else if (new_game) begin
            move_right <= hcount[0];
            move_up    <= hcount[1];
            game_over  <= 1'b0;
        end
        else if (new_frame) 
        begin
            if (!game_over) 
            begin
                if (hit_right)       
                    move_right <= 0;
                else if (hit_paddle) 
                    move_right <= 1;

                if (hit_up)          
                    move_up <= 0;
                else if (hit_down)   
                    move_up <= 1;

                if (will_game_over)
                    game_over <= 1'b1;
            end
        end
    end

    // FIND X,Y
    always @(posedge clk /*or posedge rst*/) begin
        if (rst) begin
            puck_x <= 11'd304;
            puck_y <= 10'd224;
        end else if (new_game) begin
            puck_x <= 11'd304;
            puck_y <= 10'd224;
        end else if (new_frame && !game_over) 
        begin
            // X
            if (will_game_over && !move_right)
                puck_x <= 0;
            else if (will_game_over && move_right)
                puck_x <= X_MAX - PUCK_SIZE;
            else if (hit_right && one_player)
                puck_x <= X_MAX - PUCK_SIZE;
            else if (hit_right && two_players)
                puck_x <= PADDLE_X2 - PUCK_SIZE;
            else if (hit_paddle)
                puck_x <= PADDLE_X1 + PADDLE_WIDTH;
            else if (move_right)
                puck_x <= puck_x + puck_speed;
            else if(!move_right)
                puck_x <= puck_x - puck_speed;

            // Y
            if (hit_up)
                puck_y <= 0;
            else if (hit_down)
                puck_y <= Y_MAX - PUCK_SIZE;
            else if (move_up)
                puck_y <= puck_y - puck_speed;
            else if(!move_up)
                puck_y <= puck_y + puck_speed;
        end
    end
//------------------------------------------------------------end of puck logic -----------------------------------------------------------

// RENDERING & DISPLAY LOGIC
// Generates RGB signals for paddles, puck, menu and game over

    wire [7:0] menu_red, menu_green, menu_blue;
    wire [7:0] paddle_red, paddle_green, paddle_blue;
    wire [7:0] paddle_2_red, paddle_2_green, paddle_2_blue;
    wire [7:0] puck_red,   puck_green,   puck_blue;
    wire [7:0] game_over_red, game_over_green, game_over_blue;

    // LEFT PADDLE SPRITE
    block_sprite #(
        .SPRITE_WIDTH(PADDLE_WIDTH),
        .SPRITE_HEIGHT(PADDLE_HEIGHT)
    ) left_paddle_sprite (
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(PADDLE_X1),
        .sprite_y(paddle_y1),

        .red_out(paddle_red),
        .green_out(paddle_green),
        .blue_out(paddle_blue)
    );

    // RIGHT PADDLE SPRITE
    block_sprite #(
        .SPRITE_WIDTH(PADDLE_WIDTH),
        .SPRITE_HEIGHT(PADDLE_HEIGHT)
    ) right_paddle_sprite (
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(PADDLE_X2),
        .sprite_y(paddle_y2),

        .red_out(paddle_2_red),
        .green_out(paddle_2_green),
        .blue_out(paddle_2_blue)
    );

    // PUCK SPRITE
    block_sprite #(
        .SPRITE_WIDTH(PUCK_SIZE),
        .SPRITE_HEIGHT(PUCK_SIZE)
    ) puck_sprite (
        .hcount_in(hcount),
        .vcount_in(vcount),
        .sprite_x(puck_x),
        .sprite_y(puck_y),

        .red_out(puck_red),
        .green_out(puck_green),
        .blue_out(puck_blue)
    );

    // DISPLAY MESSAGE GAMEOVER
    display_game_over inst_disp_game_over(
        .hcount(hcount),
        .vcount(vcount),
        .enable(game_over),
        .red_out(game_over_red),
        .green_out(game_over_green),
        .blue_out(game_over_blue)
    );

    // DISPLAY MENU SCREEN
    display_menu menu_screen (
        .hcount(hcount),
        .vcount(vcount),
        .enable(menu),
        .red_out(menu_red),
        .green_out(menu_green),
        .blue_out(menu_blue)
    );


// OUTPUTS
    
    // SCORE COUNTER
    always @(posedge clk) begin
        if (rst) 
            score <= 0;
        else if(new_game)
            score <= 0;
        else if(new_frame && hit_paddle && one_player)
            score <= score + 1;
        else if(two_players)
            score <= 0;
    end


    // RGB
    assign red =
        menu      ? menu_red :
        one_player ? (puck_red | paddle_red | game_over_red) :
                    (puck_red | paddle_red | paddle_2_red | game_over_red);

    assign green =
        menu      ? menu_green : 
        one_player ? (puck_green | paddle_green | game_over_green) :
                    (puck_green | paddle_green | paddle_2_green | game_over_green);

    assign blue =
        menu      ? menu_blue :
        one_player ? (puck_blue | paddle_blue | game_over_blue) :
                    (puck_blue | paddle_blue | paddle_2_blue | game_over_blue);

endmodule