/// Edge detector
module std_edge_detector #(
    /// Data width
    parameter int unsigned WIDTH = 1,
    /// Initial value of internal FF
    parameter bit [WIDTH-1:0] INITIAL_VALUE = '0
) (
    /// Clock
    input logic i_clk,
    /// Reset
    input logic i_rst,
    /// Clear
    input logic i_clear,
    /// Data
    input logic [WIDTH-1:0] i_data,
    /// Both edges
    output logic [WIDTH-1:0] o_edge,
    /// Positive edge
    output logic [WIDTH-1:0] o_posedge,
    /// Negative edge
    output logic [WIDTH-1:0] o_negedge
);
    logic [WIDTH-1:0] data;

    always_comb o_edge    = (i_data) ^ (data) & (~i_clear);
    always_comb o_posedge = (i_data) & (~data) & (~i_clear);
    always_comb o_negedge = (~i_data) & (data) & (~i_clear);

    always_ff @ (posedge i_clk, negedge i_rst) begin
        if (!i_rst) begin
            data <= INITIAL_VALUE;
        end else if (i_clear) begin
            data <= INITIAL_VALUE;
        end else begin
            data <= i_data;
        end
    end
endmodule
