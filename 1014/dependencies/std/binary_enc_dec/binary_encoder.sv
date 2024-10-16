/// A binary encoder.
///
/// Transforms a unary encoded value into a binary encoding.
module std_binary_encoder #(
    /// Width of the input unary vector
    parameter int unsigned UNARY_WIDTH = 256,
    /// Width of the output binary vector
    localparam int unsigned BIN_WIDTH = $clog2(UNARY_WIDTH)
) (
    /// Enable Signal.  Dynamic power is minimzed when not enabled.
    input logic i_en,
    /// Unary encoded input.
    input logic [UNARY_WIDTH-1:0] i_unary,
    /// Binary encoded output.
    output logic [BIN_WIDTH-1:0] o_bin
);
    logic [UNARY_WIDTH-1:0] unary_masked;
    always_comb unary_masked = ((i_en) ? (
        i_unary
    ) : (
        {'0, 1'b1}
    ));

    std__binary_encoder #(
        .UNARY_WIDTH (UNARY_WIDTH)
    ) u_binary_encoder (
        .i_unary (unary_masked),
        .o_bin   (o_bin            ),
        .o_valid ()
    );
endmodule

module std__binary_encoder #(
    parameter  int unsigned UNARY_WIDTH = 256                ,
    localparam int unsigned BIN_WIDTH   = $clog2(UNARY_WIDTH)
) (
    input  logic [UNARY_WIDTH-1:0] i_unary,
    output logic [BIN_WIDTH-1:0]   o_bin  ,
    output logic                   o_valid
);

    if (UNARY_WIDTH == 2) begin
        // We assume overall i_unary is onehot, thus OR is fine.
     :g_base_case2

        always_comb o_valid = |i_unary;
        always_comb o_bin   = i_unary[1];
    end else if (UNARY_WIDTH == 3) begin :g_base_case3
        always_comb o_valid = |i_unary;
        always_comb o_bin   = (((i_unary) ==? (3'b001)) ? (
            2'b00
        ) : ((i_unary) ==? (3'b010)) ? (
            2'b01
        ) : ((i_unary) ==? (3'b100)) ? (
            2'b10
        ) : (
            2'bxx
        ));
    end else begin :g_recursive_case
        localparam int unsigned REC_UNARY_WIDTH_BOT = UNARY_WIDTH / 2;
        localparam int unsigned REC_UNARY_WIDTH_TOP = UNARY_WIDTH - REC_UNARY_WIDTH_BOT;
        localparam int unsigned REC_BIN_WIDTH       = BIN_WIDTH - 1;

        logic [REC_UNARY_WIDTH_BOT-1:0] r_unary_bot;
        always_comb r_unary_bot = i_unary[REC_UNARY_WIDTH_BOT - 1:0];
        logic [REC_UNARY_WIDTH_TOP-1:0] r_unary_top;
        always_comb r_unary_top = i_unary[UNARY_WIDTH - 1:REC_UNARY_WIDTH_BOT];
        logic                           r_valid_bot;
        logic                           r_valid_top;
        logic [REC_BIN_WIDTH-1:0]       r_bin_bot  ;
        logic [REC_BIN_WIDTH-1:0]       r_bin_top  ;

        std__binary_encoder #(
            .UNARY_WIDTH (REC_UNARY_WIDTH_BOT)
        ) u_rec_bot (
            .i_unary (r_unary_bot),
            .o_bin   (r_bin_bot  ),
            .o_valid (r_valid_bot)
        );

        std__binary_encoder #(
            .UNARY_WIDTH (REC_UNARY_WIDTH_TOP)
        ) u_rec_top (
            .i_unary (r_unary_top),
            .o_bin   (r_bin_top  ),
            .o_valid (r_valid_top)
        );

        always_comb o_valid = r_valid_bot | r_valid_top;
        always_comb o_bin   = {r_valid_top, ((r_valid_top) ? (
            r_bin_top
        ) : (
            r_bin_bot
        ))};
    end

endmodule

`ifdef __veryl_test_core_test_binary_encoder__
    `ifdef __veryl_wavedump_core_test_binary_encoder__
        module __veryl_wavedump;
            initial begin
                $dumpfile("test_binary_encoder.vcd");
                $dumpvars();
            end
        endmodule
    `endif

module test_binary_encoder;

  parameter BIN_WIDTH = 8;
  parameter UNARY_WIDTH = 1 << BIN_WIDTH;

  logic i_en;
  logic [BIN_WIDTH-1:0] o_bin;
  logic [UNARY_WIDTH-1:0] i_unary;

  std_binary_encoder #(UNARY_WIDTH) dut (.*);

  initial begin
    i_en = 1'b1;

    for (longint i = 0; i < UNARY_WIDTH; ++i) begin
      #1 i_unary = 1 << i;
      #1 assert(i_unary[o_bin] == 1'b1) else $error("error detected");
    end
  end
endmodule
`endif
