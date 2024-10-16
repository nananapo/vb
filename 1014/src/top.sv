

module core_top
    import core_eei::*;
 (
    input logic  clk          ,
    input logic  rst          ,
    input string MEM_FILE_PATH
);

    // アドレスをメモリのデータ単位でのアドレスに変換する
    function automatic logic [20-1:0]             addr_to_memaddr(
        input logic [core_eei::XLEN-1:0] addr
    ) ;
        return addr[20 + $clog2(core_eei::MEM_DATA_WIDTH / 8) - 1:$clog2(core_eei::MEM_DATA_WIDTH / 8)];
    endfunction

    core___membus_if__eei_MEM_DATA_WIDTH__20 membus      ();
    core___membus_if__eei_ILEN__eei_XLEN membus_core ();

    always_comb begin
        membus.valid      = membus_core.valid;
        membus_core.ready = membus.ready;
        // アドレスをデータ幅単位のアドレスに変換する
        membus.addr        = addr_to_memaddr(membus_core.addr);
        membus.wen         = 0; // 命令フェッチは常に読み込み
        membus.wdata       = 'x;
        membus_core.rvalid = membus.rvalid;
        membus_core.rdata  = membus.rdata;
    end

    core___memory__eei_MEM_DATA_WIDTH__20 mem (
        .clk       (clk          ),
        .rst       (rst          ),
        .membus    (membus       ),
        .FILE_PATH (MEM_FILE_PATH)
    );

    core_core c (
        .clk    (clk        ),
        .rst    (rst        ),
        .membus (membus_core)
    );
endmodule
