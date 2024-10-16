package core_eei;
    localparam int unsigned XLEN = 32;
    localparam int unsigned ILEN = 32;

    typedef logic [XLEN-1:0] UIntX ;
    typedef logic [32-1:0]   UInt32;
    typedef logic [64-1:0]   UInt64;
    typedef logic [ILEN-1:0] Inst  ;
    typedef logic [XLEN-1:0] Addr  ;

    // メモリのデータ幅
    localparam int unsigned MEM_DATA_WIDTH = 32;
endpackage
