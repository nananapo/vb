interface core___membus_if__eei_MEM_DATA_WIDTH__20;
    logic [20-1:0] addr ;
    logic [core_eei::MEM_DATA_WIDTH-1:0] wdata;
    logic [core_eei::MEM_DATA_WIDTH-1:0] rdata;

    modport master (
        output addr ,
        output wdata,
        input  rdata
    );

    modport slave (
        input  addr ,
        input  wdata,
        output rdata
    );
endinterface
