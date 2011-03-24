`include "or1200_defines.v"

module or1200_module (
	// System
	clk_i, rst_i,

	// Instruction WISHBONE INTERFACE
	iwb_clk_i, iwb_rst_i, iwb_ack_i, iwb_err_i, iwb_rty_i, iwb_dat_i,
	iwb_cyc_o, iwb_adr_o, iwb_stb_o, iwb_we_o, iwb_sel_o, iwb_dat_o,
`ifdef OR1200_WB_CAB
	iwb_cab_o,
`endif
`ifdef OR1200_WB_B3
	iwb_cti_o, iwb_bte_o,
`endif
	// Data WISHBONE INTERFACE
`ifdef OR1200_WB_CAB
	dwb_cab_o,
`endif
`ifdef OR1200_WB_B3
	dwb_cti_o, dwb_bte_o,
`endif

`ifdef OR1200_DC_INVALID_COHERENCE
	snooped_adr_i, snooped_we_i, snooped_ack_i,
`elsif OR1200_DC_UPDATE_COHERENCE
	snooped_adr_i, snooped_we_i, snooped_ack_i, snooped_dat_i, snooped_sel_i,
`endif
	dwb_clk_i, dwb_rst_i, dwb_ack_i, dwb_err_i, dwb_rty_i, dwb_dat_i,
	dwb_cyc_o, dwb_adr_o, dwb_stb_o, dwb_we_o, dwb_sel_o, dwb_dat_o,
	
	// External Debug Interface
	dbg_stall_i, dbg_ewt_i,	dbg_lss_o, dbg_is_o, dbg_wp_o, dbg_bp_o,
	dbg_stb_i, dbg_we_i, dbg_adr_i, dbg_dat_i, dbg_dat_o, dbg_ack_o
);

parameter dw = `OR1200_OPERAND_WIDTH;
parameter aw = `OR1200_OPERAND_WIDTH;

parameter id = 0;

input			clk_i;
input			rst_i;

//
// Instruction WISHBONE interface
//
input			iwb_clk_i;	// clock input
input			iwb_rst_i;	// reset input
input			iwb_ack_i;	// normal termination
input			iwb_err_i;	// termination w/ error
input			iwb_rty_i;	// termination w/ retry
input	[dw-1:0]	iwb_dat_i;	// input data bus
output			iwb_cyc_o;	// cycle valid output
output	[aw-1:0]	iwb_adr_o;	// address bus outputs
output			iwb_stb_o;	// strobe output
output			iwb_we_o;	// indicates write transfer
output	[3:0]		iwb_sel_o;	// byte select outputs
output	[dw-1:0]	iwb_dat_o;	// output data bus
`ifdef OR1200_WB_CAB
output			iwb_cab_o;	// indicates consecutive address burst
`endif
`ifdef OR1200_WB_B3
output	[2:0]		iwb_cti_o;	// cycle type identifier
output	[1:0]		iwb_bte_o;	// burst type extension
`endif

//
// Data WISHBONE interface
//
input			dwb_clk_i;	// clock input
input			dwb_rst_i;	// reset input
input			dwb_ack_i;	// normal termination
input			dwb_err_i;	// termination w/ error
input			dwb_rty_i;	// termination w/ retry
input	[dw-1:0]	dwb_dat_i;	// input data bus
output			dwb_cyc_o;	// cycle valid output
output	[aw-1:0]	dwb_adr_o;	// address bus outputs
output			dwb_stb_o;	// strobe output
output			dwb_we_o;	// indicates write transfer
output	[3:0]		dwb_sel_o;	// byte select outputs
output	[dw-1:0]	dwb_dat_o;	// output data bus
`ifdef OR1200_WB_CAB
output			dwb_cab_o;	// indicates consecutive address burst
`endif
`ifdef OR1200_WB_B3
output	[2:0]		dwb_cti_o;	// cycle type identifier
output	[1:0]		dwb_bte_o;	// burst type extension
`endif

`ifdef OR1200_DC_INVALID_COHERENCE
input	[31:0]			snooped_adr_i;
input	      			snooped_ack_i;
input				snooped_we_i;
`elsif OR1200_DC_UPDATE_COHERENCE
input	[31:0]			snooped_adr_i;
input	      			snooped_ack_i;
input				snooped_we_i;
input	[dw-1:0]		snooped_dat_i;
input	[3:0]			snooped_sel_i;
`endif

//
// External Debug Interface
//
input			dbg_stall_i;	// External Stall Input
input			dbg_ewt_i;	// External Watchpoint Trigger Input
output	[3:0]		dbg_lss_o;	// External Load/Store Unit Status
output	[1:0]		dbg_is_o;	// External Insn Fetch Status
output	[10:0]		dbg_wp_o;	// Watchpoints Outputs
output			dbg_bp_o;	// Breakpoint Output
input			dbg_stb_i;      // External Address/Data Strobe
input			dbg_we_i;       // External Write Enable
input	[aw-1:0]	dbg_adr_i;	// External Address Input
input	[dw-1:0]	dbg_dat_i;	// External Data Input
output	[dw-1:0]	dbg_dat_o;	// External Data Output
output			dbg_ack_o;	// External Data Acknowledge (not WB compatible)

wire [31:0] wb_cas_dat_o;
wire [31:0] wb_cas_adr_o;
wire [3:0]  wb_cas_sel_o;
wire        wb_cas_we_o;
wire        wb_cas_stb_o;
wire        wb_cas_cyc_o;
wire [31:0] wb_cas_dat_i;
wire        wb_cas_ack_i;
wire        wb_cas_err_i;
wire        wb_cas_rty_i;

wb_cas_unit cas (
    .clk_i(clk_i), 
    .rst_i(reset), 
    .wb_core_dat_i(wb_cas_dat_o), 
    .wb_core_adr_i(wb_cas_adr_o), 
    .wb_core_dat_o(wb_cas_dat_i), 
    .wb_core_sel_i(wb_cas_sel_o), 
    .wb_core_we_i(wb_cas_we_o), 
    .wb_core_cyc_i(wb_cas_cyc_o), 
    .wb_core_stb_i(wb_cas_stb_o), 
    .wb_core_ack_o(wb_cas_ack_i), 
    .wb_core_rty_o(wb_cas_rty_i), 
    .wb_core_err_o(wb_cas_err_i), 
    .wb_bus_dat_o(dwb_dat_o), 
    .wb_bus_adr_o(dwb_adr_o), 
    .wb_bus_dat_i(dwb_dat_i), 
    .wb_bus_sel_o(dwb_sel_o), 
    .wb_bus_we_o(dwb_we_o), 
    .wb_bus_ack_i(dwb_ack_i), 
    .wb_bus_rty_i(dwb_rty_i), 
    .wb_bus_err_i(dwb_err_i), 
    .wb_bus_cyc_o(dwb_cyc_o), 
    .wb_bus_stb_o(dwb_stb_o)
    );


// Instantiate CPU0
or1200_top #(.coreid(id)) or1200_top(
  // System
  .clk_i        ( clk_i       ),
  .rst_i        ( rst_i       ),
  .pic_ints_i   ( 1'b0        ),
  .clmode_i     ( 2'b0        ),
  
  // Instruction WISHBONE INTERFACE  
  .iwb_clk_i    ( clk_i   ),
  .iwb_rst_i    ( rst_i   ),

  .iwb_cyc_o    ( iwb_cyc_o   ),
  .iwb_adr_o    ( iwb_adr_o   ),
  .iwb_stb_o    ( iwb_stb_o   ),
  .iwb_we_o     ( iwb_we_o    ),
  .iwb_sel_o    ( iwb_sel_o   ),
  .iwb_dat_o    ( iwb_dat_o   ),
  `ifdef OR1200_WB_B3 
  .iwb_cti_o    ( iwb_cti_o   ), 
  .iwb_bte_o    ( iwb_bte_o   ),
  `endif
  .iwb_ack_i    ( iwb_ack_i   ),
  .iwb_err_i    ( iwb_err_i   ),
  .iwb_rty_i    ( iwb_rty_i   ),
  .iwb_dat_i    ( iwb_dat_i   ),
  
  // Data WISHBONE INTERFACE
  .dwb_clk_i    ( clk_i   ),
  .dwb_rst_i    ( rst_i   ),
  
  .dwb_cyc_o    ( wb_cas_cyc_o   ),
  .dwb_adr_o    ( wb_cas_adr_o   ),
  .dwb_stb_o    ( wb_cas_stb_o   ),
  .dwb_we_o     ( wb_cas_we_o    ),
  .dwb_sel_o    ( wb_cas_sel_o   ),
  .dwb_dat_o    ( wb_cas_dat_o   ),
  `ifdef OR1200_WB_B3
  .dwb_cti_o    ( wbm_cti_o   ), 
  .dwb_bte_o    ( wbm_bte_o   ),
  `endif
  .dwb_ack_i    ( wb_cas_ack_i   ),
  .dwb_err_i    ( wb_cas_err_i   ),
  .dwb_rty_i    ( wb_cas_rty_i   ),
  .dwb_dat_i    ( wb_cas_dat_i   ),

`ifdef OR1200_DC_INVALID_COHERENCE
  .snooped_adr_i   (snooped_adr_i),
  .snooped_ack_i   (snooped_ack_i),
  .snooped_we_i    (snooped_we_i),
`elsif OR1200_DC_UPDATE_COHERENCE
  .snooped_adr_i   (snooped_adr_i),
  .snooped_ack_i   (snooped_ack_i),
  .snooped_we_i    (snooped_we_i),
  .snooped_dat_i   (snooped_dat_i),
  .snooped_sel_i   (snooped_sel_i),
`endif

  // External Debug Interface
	.dbg_stall_i(dbg_stall_i), 
   .dbg_ewt_i(dbg_ewt_i), 
   .dbg_lss_o(dbg_lss_o), 
   .dbg_is_o(dbg_is_o), 
   .dbg_wp_o(dbg_wp_o), 
   .dbg_bp_o(dbg_bp_o), 
   .dbg_stb_i(dbg_stb_i), 
   .dbg_we_i(dbg_we_i), 
   .dbg_adr_i(dbg_adr_i), 
   .dbg_dat_i(dbg_dat_i), 
   .dbg_dat_o(dbg_dat_o), 
   .dbg_ack_o(dbg_ack_o), 

  // Power Management
  .pm_cpustall_i  ( 1'b0  ),
  .pm_clksd_o     (   ),
  .pm_dc_gate_o   (   ),
  .pm_ic_gate_o   (   ),
  .pm_dmmu_gate_o (   ),
  .pm_immu_gate_o (   ),
  .pm_tt_gate_o   (   ),
  .pm_cpu_gate_o  (   ),
  .pm_wakeup_o    (   ),
  .pm_lvolt_o     (   )
);

endmodule
