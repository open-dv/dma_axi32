import uvm_pkg::*;    

interface dma_harness();

	apb_if apb_if_inst(
		.PCLK(dma_axi64.clk),
		.PRESETn(dma_axi64.reset),
		.PSEL(dma_axi64.psel),
		.PENABLE(dma_axi64.penable),
		.PADDR(dma_axi64.paddr),
		.PWRITE(dma_axi64.pwrite),
		.PWDATA(dma_axi64.pwdata),
		.PRDATA(dma_axi64.prdata),
		.PSLVERR(dma_axi64.pslverr),
		.PREADY(dma_axi64.pready)
		);
		
	function void set_vif(string path);
	    uvm_config_db#(virtual apb_if)::set(null, path, "APB_INTF", apb_if_inst);
	endfunction

	
endinterface