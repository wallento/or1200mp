synthesis: synthesis-chipscope synthesis-normal

synthesis-normal:
	xtclsh xupv5_nodc.tcl
	mv impl/xupv5.bit xupv5_nodc.bit
	mv memory_bd.bmm xupv5_nodc.bmm

synthesis-chipscope:
	xtclsh xupv5_nodc_cs.tcl
	mv impl_cs/xupv5.bit xupv5_nodc_cs.bit
	mv memory_bd.bmm xupv5_nodc_cs.bmm



