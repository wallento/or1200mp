`timescale 1ns / 1ps

module autoreset(
    input clk_i,
    input rst_i,
    input en_i,
    output rst_o
    );

parameter cycle = 66060606; // every two seconds for 33 MHz
parameter counterwidth = 26;

reg auto_rst;
reg [counterwidth-1:0] counter;

always @(posedge clk_i) begin
	if ( rst_i ) begin
		counter = 0;
	end
	else begin
		if ( counter == cycle ) begin
			auto_rst = 1;
			counter = 0;
		end
		else begin
			auto_rst = 0;
			counter = counter + 1;
		end
	end
end

assign rst_o = ( en_i & auto_rst ) | (~en_i & rst_i);

endmodule
