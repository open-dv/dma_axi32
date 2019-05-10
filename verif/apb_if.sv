  
interface apb_if(
   input								PCLK,							
   input								PRESETn,
   input                                PSEL,
   input                                PENABLE,
   input [`ADDR_WIDTH-1:0]              PADDR,
   input                                PWRITE,
   input [`DATA_WIDTH-1:0]              PWDATA,
   input[`DATA_WIDTH-1:0]             PRDATA,
   input                              PSLVERR,
   input                              PREADY);
 
    // clocking block declarations
    clocking cb @(posedge PCLK);
        default input #1ns output #1ns;  // default delay skew
        output  PSEL;
        output  PENABLE;
        output  PWRITE;
        output  PADDR;
        output  PWDATA;
        input   PREADY;
        input   PRDATA;
        input   PSLVERR;
    endclocking: cb
    
    // modport declarations
    modport dut(output PRESETn, clocking cb);
    
    ///////////////////////////////////// property check assertions ////////////////////////////////////
    // apb_read transfer seq check
    property apb_read_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && !PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty    
    
    // apb_write transfer seq check
    property apb_write_seq_prop;
        @(posedge PCLK) disable iff(!PRESETn)
        PSEL && PWRITE && PADDR!='bx |=> PENABLE ##[1:$] PREADY ##1 !PENABLE |-> !PSEL;
    endproperty
    
    // property check assertions
    assert property(apb_read_seq_prop); 
    assert property(apb_write_seq_prop);
    
	logic rst;
	logic psel;
	logic pen;
	logic pwrite;

    assign PRESETn = !rst;
	assign PSEL = psel;
	assign PENABLE = pen;
	assign PWRITE =  pwrite;

    ///////////////////////////////////// Interface Tasks /////////////////////////////////////////////
    // interface reset task
    task reset_intf();
	    $display("applying reset");
        rst = 0;  // trigger Reset
        psel = 0;
        pen = 0;
        pwrite = 0;
        repeat(10) 
            @(posedge PCLK);
        rst = 1;  // back to normal operation
        @(posedge PCLK);
		$display("removed reset");
    endtask
 
 
endinterface   