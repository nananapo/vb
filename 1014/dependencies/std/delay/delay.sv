/// Delay input by configured cycle
module std_delay #(
    /// Clock cycle of delay
    parameter int unsigned DELAY = 1,
    /// Input/output data width
    parameter int unsigned WIDTH = 1,
    /// Input/output data type
    parameter type TYPE = logic [WIDTH-1:0]
) (
    /// Clock
    input logic i_clk,
    /// Reset
    input logic i_rst,
    /// Input
    input TYPE i_d,
    /// Output
    output TYPE o_d
);
    if ((DELAY >= 1)) begin :g_delay
        TYPE delay [0:DELAY-1];

        always_comb o_d = delay[DELAY - 1];
        always_ff @ (posedge i_clk, negedge i_rst) begin
            if (!i_rst) begin
                delay <= '{0};
            end else begin
                delay[0] <= i_d;
                for (int unsigned i = 1; i < DELAY; i++) begin
                    delay[i] <= delay[i - 1];
                end
            end
        end
    end else begin :g_no_delay
        always_comb o_d = i_d;
    end
endmodule
