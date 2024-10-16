

module core_core
    import core_eei::*;
 (
    input logic                                        clk   ,
    input logic                                        rst   ,
    core___membus_if__eei_ILEN__eei_XLEN::master membus
);

    Addr  if_pc          ;
    logic if_is_requested; // フェッチ中かどうか
    Addr  if_pc_requested; // 要求したアドレス

    Addr if_pc_next;
    always_comb if_pc_next = if_pc + 4;

    // 命令フェッチ処理
    always_comb begin
        membus.valid = 1;
        membus.addr  = if_pc;
        membus.wen   = 0;
        membus.wdata = 'x; // wdataは使用しない
    end

    always_ff @ (posedge clk, negedge rst) begin
        if (!rst) begin
            if_pc           <= 0;
            if_is_requested <= 0;
            if_pc_requested <= 0;
        end else begin
            if (if_is_requested) begin
                if (membus.rvalid) begin
                    if_is_requested <= membus.ready;
                    if (membus.ready) begin
                        if_pc           <= if_pc_next;
                        if_pc_requested <= if_pc;
                    end
                end
            end else begin
                if (membus.ready) begin
                    if_is_requested <= 1;
                    if_pc           <= if_pc_next;
                    if_pc_requested <= if_pc;
                end
            end
        end
    end

    always_ff @ (posedge clk) begin
        if (if_is_requested && membus.rvalid) begin
            $display("%h : %h", if_pc_requested, membus.rdata);
        end
    end
endmodule
