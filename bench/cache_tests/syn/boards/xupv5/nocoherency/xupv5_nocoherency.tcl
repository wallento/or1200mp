#
# Based on the automatically generated tcl script of Project Navigator
#

set myProject "xupv5_nocoherency"
set myScript "xupv5_nocoherency.tcl"

# 
# Main (top-level) routines
# 

# 
# run_process
# This procedure is used to run processes on an existing project. You may comment or
# uncomment lines to control which processes are run. This routine is set up to run
# the Implement Design and Generate Programming File processes by default. This proc
# also sets process properties as specified in the "set_process_props" proc. Only
# those properties which have values different from their current settings in the project
# file will be modified in the project.
# 
proc run_process {} {

   global myScript
   global myProject

   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: running ($myProject)...\n"

   if { ! [ open_project ] } {
      return false
   }

   set_process_props
   #
   # Remove the comment characters (#'s) to enable the following commands 
   # process run "Synthesize"
   # process run "Translate"
   # process run "Map"
   # process run "Place & Route"
   #
   puts "Running 'Implement Design'"
   if { ! [ process run "Implement Design" ] } {
      puts "$myScript: Implementation run failed, check run output for details."
      project close
      return
   }
   puts "Running 'Generate Programming File'"
   if { ! [ process run "Generate Programming File" ] } {
      puts "$myScript: Generate Programming File run failed, check run output for details."
      project close
      return
   }

   puts "Run completed."
   project close

}

# 
# rebuild_project
# 
# This procedure renames the project file (if it exists) and recreates the project.
# It then sets project properties and adds project sources as specified by the
# set_project_props and add_source_files support procs. It recreates VHDL Libraries
# as they existed at the time this script was generated.
# 
# It then calls run_process to set process properties and run selected processes.
# 
proc rebuild_project {} {

   global myScript
   global myProject

   project close
   ## put out a 'heartbeat' - so we know something's happening.
   puts "\n$myScript: Rebuilding ($myProject)...\n"

   set proj_exts [ list ise xise gise ]
   foreach ext $proj_exts {
      set proj_name "${myProject}.$ext"
      if { [ file exists $proj_name ] } { 
         file delete $proj_name
      }
   }

   project new $myProject
   set_project_props
   add_source_files
   puts "$myScript: project rebuild completed."

   run_process

}

proc open_project {} {

   global myScript
   global myProject

   if { ! [ file exists ${myProject}.xise ] } { 
      ## project file isn't there, rebuild it.
      puts "Project $myProject not found. Use project_rebuild to recreate it."
      return false
   }

   project open $myProject

   return true

}
# 
# set_project_props
# 
# This procedure sets the project properties as they were set in the project
# at the time this script was generated.
# 
proc set_project_props {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: Setting project properties..."

   project set family "Virtex5"
   project set device "xc5vlx110t"
   project set package "ff1136"
   project set speed "-1"
   project set top_level_module_type "HDL"
   project set synthesis_tool "XST (VHDL/Verilog)"
   project set simulator "Modelsim-SE Mixed"
   project set "Preferred Language" "Verilog"
   project set "Enable Message Filtering" "false"

}


# 
# add_source_files
# 
proc add_source_files {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: Adding sources to project..."

   xfile add "../../../../../../rtl/verilog/or1200_alu.v"
   xfile add "../../../../../../rtl/verilog/or1200_cfgr.v"
   xfile add "../../../../../../rtl/verilog/or1200_cpu.v"
   xfile add "../../../../../../rtl/verilog/or1200_ctrl.v"
   xfile add "../../../../../../rtl/verilog/or1200_dc_fsm.v"
   xfile add "../../../../../../rtl/verilog/or1200_dc_ram.v"
   xfile add "../../../../../../rtl/verilog/or1200_dc_tag.v"
   xfile add "../../../../../../rtl/verilog/or1200_dc_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_dmmu_tlb.v"
   xfile add "../../../../../../rtl/verilog/or1200_dmmu_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_dpram.v"
   xfile add "../../../../../../rtl/verilog/or1200_du.v"
   xfile add "../../../../../../rtl/verilog/or1200_except.v"
   xfile add "../../../../../../rtl/verilog/or1200_freeze.v"
   xfile add "../../../../../../rtl/verilog/or1200_genpc.v"
   xfile add "../../../../../../rtl/verilog/or1200_gmultp2_32x32.v"
   xfile add "../../../../../../rtl/verilog/or1200_ic_fsm.v"
   xfile add "../../../../../../rtl/verilog/or1200_ic_ram.v"
   xfile add "../../../../../../rtl/verilog/or1200_ic_tag.v"
   xfile add "../../../../../../rtl/verilog/or1200_ic_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_if.v"
   xfile add "../../../../../../rtl/verilog/or1200_immu_tlb.v"
   xfile add "../../../../../../rtl/verilog/or1200_immu_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_iwb_biu.v"
   xfile add "../../../../../../rtl/verilog/or1200_lsu.v"
   xfile add "../../../../../../rtl/verilog/or1200_mem2reg.v"
   xfile add "../../../../../../rtl/verilog/or1200_mult_mac.v"
   xfile add "../../../../../../rtl/verilog/or1200_operandmuxes.v"
   xfile add "../../../../../../rtl/verilog/or1200_pic.v"
   xfile add "../../../../../../rtl/verilog/or1200_pm.v"
   xfile add "../../../../../../rtl/verilog/or1200_qmem_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_reg2mem.v"
   xfile add "../../../../../../rtl/verilog/or1200_rf.v"
   xfile add "../../../../../../rtl/verilog/or1200_sb.v"
   xfile add "../../../../../../rtl/verilog/or1200_spram.v"
   xfile add "../../../../../../rtl/verilog/or1200_sprs.v"
   xfile add "../../../../../../rtl/verilog/or1200_top.v"
   xfile add "../../../../../../rtl/verilog/or1200_tt.v"
   xfile add "../../../../../../rtl/verilog/or1200_wb_biu.v"
   xfile add "../../../../../../rtl/verilog/or1200_wbmux.v"
   xfile add "../../../../../../rtl/verilog/or1200_spram_1024x32_bw.v"
   xfile add "../../../../../../rtl/verilog/or1200_spram_256x21.v"
   xfile add "../../../../verilog/cache_tests.v"
   xfile add "../../../../verilog/dbg_if/dbg_cpu.v"
   xfile add "../../../../verilog/dbg_if/dbg_cpu_registers.v"
   xfile add "../../../../verilog/dbg_if/dbg_crc32_d1.v"
   xfile add "../../../../verilog/dbg_if/dbg_if.v"
   xfile add "../../../../verilog/dbg_if/dbg_wb.v"
   xfile add "../../../../verilog/jtag_tap/jtag_tap.v"
   xfile add "../../../../verilog/onchip_ram/onchip_ram_top.v"
   xfile add "../../../../verilog/or1200_module.v"
   xfile add "../../../../verilog/uart16550/raminfr.v"
   xfile add "../../../../verilog/uart16550/uart_debug_if.v"
   xfile add "../../../../verilog/uart16550/uart_receiver.v"
   xfile add "../../../../verilog/uart16550/uart_regs.v"
   xfile add "../../../../verilog/uart16550/uart_rfifo.v"
   xfile add "../../../../verilog/uart16550/uart_sync_flops.v"
   xfile add "../../../../verilog/uart16550/uart_tfifo.v"
   xfile add "../../../../verilog/uart16550/uart_top.v"
   xfile add "../../../../verilog/uart16550/uart_transmitter.v"
   xfile add "../../../../verilog/uart16550/uart_wb.v"
   xfile add "../../../../verilog/wb_cas_unit/wb_cas_fsm.v"
   xfile add "../../../../verilog/wb_cas_unit/wb_cas_unit.v"
   xfile add "../../../../verilog/wb_conbus/wb_conbus_arb.v"
   xfile add "../../../../verilog/wb_conbus/wb_conbus_top.v"
   xfile add "../reset_debounce.v"
   xfile add "../xupv5.ucf"
   xfile add "../xupv5.v"
   xfile add "../clockgen.v"
   xfile add "memory.bmm"

   # Set the Top Module as well...
   project set top "xupv5"

   puts "$myScript: project sources reloaded."

} ; # end add_source_files

# 
# set_process_props
# 
# This procedure sets properties as requested during script generation (either
# all of the properties, or only those modified from their defaults).
# 
proc set_process_props {} {

   global myScript

   if { ! [ open_project ] } {
      return false
   }

   puts "$myScript: setting process properties..."

   project set "Working Directory" "./impl"
   project set "Auto Implementation Top" "false"
   project set "Verilog Include Directories" "./|../"


   puts "$myScript: project property values set."

} ; # end set_process_props

rebuild_project
