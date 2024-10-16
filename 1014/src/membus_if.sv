interface core___membus_if__eei_ILEN__eei_XLEN;
    logic        valid ;
    logic        ready ;
    logic [core_eei::XLEN-1:0] addr  ;
    logic        wen   ;
    logic [core_eei::ILEN-1:0] wdata ;
    logic        rvalid;
    logic [core_eei::ILEN-1:0] rdata ;

    modport master (
        output valid ,
        input  ready ,
        output addr  ,
        output wen   ,
        output wdata ,
        input  rvalid,
        input  rdata 
    );

    modport slave (
        input  valid ,
        output ready ,
        input  addr  ,
        input  wen   ,
        input  wdata ,
        output rvalid,
        output rdata 
    );
endinterface
interface core___membus_if__eei_MEM_DATA_WIDTH__20;
    logic        valid ;
    logic        ready ;
    logic [20-1:0] addr  ;
    logic        wen   ;
    logic [core_eei::MEM_DATA_WIDTH-1:0] wdata ;
    logic        rvalid;
    logic [core_eei::MEM_DATA_WIDTH-1:0] rdata ;

    modport master (
        output valid ,
        input  ready ,
        output addr  ,
        output wen   ,
        output wdata ,
        input  rvalid,
        input  rdata 
    );

    modport slave (
        input  valid ,
        output ready ,
        input  addr  ,
        input  wen   ,
        input  wdata ,
        output rvalid,
        output rdata 
    );
endinterface
