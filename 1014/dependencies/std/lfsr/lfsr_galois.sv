module std_lfsr_galois #(
    /// Size of the LFSR in bits
    parameter  int unsigned SIZE     = 64              ,
    localparam type         TAPVEC_T = logic [SIZE-1:0],
    /// Bit-vector representing the taps of the LFSR.
    /// Default values provided for `SIZE` in range [2, 64]
    parameter TAPVEC_T TAPVEC = (((SIZE) ==? (2)) ? (
        2'h3
    ) : ((SIZE) ==? (3)) ? (
        3'h5
    ) : ((SIZE) ==? (4)) ? (
        4'h9
    ) : ((SIZE) ==? (5)) ? (
        5'h12
    ) : ((SIZE) ==? (6)) ? (
        6'h21
    ) : ((SIZE) ==? (7)) ? (
        7'h41
    ) : ((SIZE) ==? (8)) ? (
        8'h8e
    ) : ((SIZE) ==? (9)) ? (
        9'h108
    ) : ((SIZE) ==? (10)) ? (
        10'h204
    ) : ((SIZE) ==? (11)) ? (
        11'h402
    ) : ((SIZE) ==? (12)) ? (
        12'h829
    ) : ((SIZE) ==? (13)) ? (
        13'h100d
    ) : ((SIZE) ==? (14)) ? (
        14'h2015
    ) : ((SIZE) ==? (15)) ? (
        15'h4001
    ) : ((SIZE) ==? (16)) ? (
        16'h8016
    ) : ((SIZE) ==? (17)) ? (
        17'h10004
    ) : ((SIZE) ==? (18)) ? (
        18'h20013
    ) : ((SIZE) ==? (19)) ? (
        19'h40013
    ) : ((SIZE) ==? (20)) ? (
        20'h80004
    ) : ((SIZE) ==? (21)) ? (
        21'h100002
    ) : ((SIZE) ==? (22)) ? (
        22'h200001
    ) : ((SIZE) ==? (23)) ? (
        23'h400010
    ) : ((SIZE) ==? (24)) ? (
        24'h80000d
    ) : ((SIZE) ==? (25)) ? (
        25'h1000004
    ) : ((SIZE) ==? (26)) ? (
        26'h2000023
    ) : ((SIZE) ==? (27)) ? (
        27'h4000013
    ) : ((SIZE) ==? (28)) ? (
        28'h8000004
    ) : ((SIZE) ==? (29)) ? (
        29'h10000002
    ) : ((SIZE) ==? (30)) ? (
        30'h20000029
    ) : ((SIZE) ==? (31)) ? (
        31'h40000004
    ) : ((SIZE) ==? (32)) ? (
        32'h80000057
    ) : ((SIZE) ==? (33)) ? (
        33'h100000029
    ) : ((SIZE) ==? (34)) ? (
        34'h200000073
    ) : ((SIZE) ==? (35)) ? (
        35'h400000002
    ) : ((SIZE) ==? (36)) ? (
        36'h80000003b
    ) : ((SIZE) ==? (37)) ? (
        37'h100000001f
    ) : ((SIZE) ==? (38)) ? (
        38'h2000000031
    ) : ((SIZE) ==? (39)) ? (
        39'h4000000008
    ) : ((SIZE) ==? (40)) ? (
        40'h800000001c
    ) : ((SIZE) ==? (41)) ? (
        41'h10000000004
    ) : ((SIZE) ==? (42)) ? (
        42'h2000000001f
    ) : ((SIZE) ==? (43)) ? (
        43'h4000000002c
    ) : ((SIZE) ==? (44)) ? (
        44'h80000000032
    ) : ((SIZE) ==? (45)) ? (
        45'h10000000000d
    ) : ((SIZE) ==? (46)) ? (
        46'h200000000097
    ) : ((SIZE) ==? (47)) ? (
        47'h400000000010
    ) : ((SIZE) ==? (48)) ? (
        48'h80000000005b
    ) : ((SIZE) ==? (49)) ? (
        49'h1000000000038
    ) : ((SIZE) ==? (50)) ? (
        50'h200000000000e
    ) : ((SIZE) ==? (51)) ? (
        51'h4000000000025
    ) : ((SIZE) ==? (52)) ? (
        52'h8000000000004
    ) : ((SIZE) ==? (53)) ? (
        53'h10000000000023
    ) : ((SIZE) ==? (54)) ? (
        54'h2000000000003e
    ) : ((SIZE) ==? (55)) ? (
        55'h40000000000023
    ) : ((SIZE) ==? (56)) ? (
        56'h8000000000004a
    ) : ((SIZE) ==? (57)) ? (
        57'h100000000000016
    ) : ((SIZE) ==? (58)) ? (
        58'h200000000000031
    ) : ((SIZE) ==? (59)) ? (
        59'h40000000000003d
    ) : ((SIZE) ==? (60)) ? (
        60'h800000000000001
    ) : ((SIZE) ==? (61)) ? (
        61'h1000000000000013
    ) : ((SIZE) ==? (62)) ? (
        62'h2000000000000034
    ) : ((SIZE) ==? (63)) ? (
        63'h4000000000000001
    ) : ((SIZE) ==? (64)) ? (
        64'h800000000000000d
    ) : (
        '0
    ))

) (
    /// Clock
    input logic i_clk,
    /// Enable - LFSR shifts only when enabled.  Active high.
    input logic i_en,
    /// Flag to set value of LFSR.  Active High.
    input logic i_set,
    /// Value which LFSR is set to when `i_set` is set.
    input logic [SIZE-1:0] i_setval,
    /// LFSR value.
    output logic [SIZE-1:0] o_val
);

    logic [SIZE-1:0] val_next;

    always_comb val_next[SIZE - 1] = o_val[0];
    for (genvar i = 0; i < (SIZE - 1); i++) begin :g_taps
        localparam int unsigned K = SIZE - 2 - i;
        if (TAPVEC[K]) begin :g_tap
            always_comb val_next[K] = ((i_set) ? (
                i_setval[K]
            ) : (
                o_val[K + 1] ^ o_val[0]
            ));
        end else begin :g_notap
            always_comb val_next[K] = ((i_set) ? (
                i_setval[K]
            ) : (
                o_val[K + 1]
            ));
        end
    end

    always_ff @ (posedge i_clk) begin
        if (i_en) begin
            o_val <= val_next;
        end
    end
endmodule

`ifdef __veryl_test_core_test_lfsr_galois__
    `ifdef __veryl_wavedump_core_test_lfsr_galois__
        module __veryl_wavedump;
            initial begin
                $dumpfile("test_lfsr_galois.vcd");
                $dumpvars();
            end
        endmodule
    `endif

module test_lfsr_galois;
    parameter MAXSIZE = 24;
    parameter MINSIZE = 2;

    logic [MAXSIZE-1:MINSIZE] done;
    logic [MAXSIZE-1:MINSIZE] working;
    logic i_clk;

    for (genvar i = MINSIZE; i < MAXSIZE; ++i) begin
        initial $info("Spawning LFSR of Size %d", i);
        lfsr_galois_bench #(.SIZE(i)) u_lfsr(.i_clk, .done(done[i]), .working(working[i]));
    end
    default clocking
      @(posedge i_clk);
    endclocking

    initial forever begin
        ##4
        if (&done) begin
            if (|working) begin
                $info("Finishing Simulations with \033[32m100%% Success\033[0m");
            end else begin
                $error("Finishing Simulations with \033[31mErrors\033[0m");
            end
            $finish;
        end
    end

  initial begin
    i_clk = 1'b0;
    forever #5 i_clk = ~i_clk;
  end
endmodule

module lfsr_galois_bench #(parameter SIZE=64) (input i_clk, output logic done, output logic working);
  logic [SIZE:0] limit;


  logic i_en, i_set;
  logic [SIZE-1:0] i_setval;
  logic [SIZE-1:0] o_val;

  std_lfsr_galois #(.SIZE(SIZE)) dut (.*);


  default clocking
    @(posedge i_clk);
  endclocking


  initial begin
    int outvecs [logic[SIZE-1:0]];
    working = 1'b1;
    $info("Begining LFSR of Size %d", SIZE);
    done = 1'b0;
    i_en = 1'b1;
    i_set = 1'b1;
    i_setval = 16'h0001;

    ##2;

    i_set = 1'b0;
    limit = '1;
    limit[0] = 1'b0; 
    limit[SIZE] = 1'b0;

    for (int i = 0; i < limit; i += 1) begin
      ##1;
      assert(0 == outvecs.exists(o_val));
      working &= !outvecs.exists(o_val);
      outvecs[o_val] = 1'b1;
    end

    done = 1'b1;

    if (working) 
        $info("Succesfully Ending LFSR of Size %0d", SIZE);
    else
        $error("Failure Detecing in LFSR of size %0d", SIZE);
  end

endmodule
`endif
