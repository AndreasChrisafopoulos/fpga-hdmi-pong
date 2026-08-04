module synchronizer(
  input clk,
  input in,
  output reg out
);

  reg temp;

    // synchronise reset
    always @(posedge clk) begin         
        temp <= in;         
        out <= temp;       
    end

endmodule