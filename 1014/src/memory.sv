module core___memory__eei_MEM_DATA_WIDTH__20 (
    input logic                clk      ,
    input logic                rst      ,
    core___membus_if__eei_MEM_DATA_WIDTH__20::slave membus   ,
    input string               FILE_PATH // メモリの初期値が格納されたファイルのパス
);
    typedef logic [core_eei::MEM_DATA_WIDTH-1:0] DataType;

    DataType mem [0:2 ** 20-1];

    initial begin
        // memをFILE_PATHに格納されているデータで初期化
        if (FILE_PATH != "") begin
            $readmemh(FILE_PATH, mem);
        end
    end

    always_comb begin
        membus.ready = 1;
    end

    always_ff @ (posedge clk) begin
        membus.rvalid <= membus.valid;
        membus.rdata  <= mem[membus.addr[20 - 1:0]];
        if (membus.valid && membus.wen) begin
            mem[membus.addr[20 - 1:0]] <= membus.wdata;
        end
    end
endmodule
