`timescale 1ns / 1ps

module debounce(
    input clk_i,
    input in,
    output reg out
);

parameter timeoutw = 17;
parameter timeout = 65536;

reg [timeoutw-1:0] timer = 0;

always @(posedge clk_i) begin
	if ( timer == 0 ) begin
		if ( in ) begin
			timer = 1;
			out = 1;
		end
		else begin
			out = 0;
		end
	end
	else begin
		if ( timer == timeout ) begin
			timer = 0;
			out = 0;
		end
		else begin
			timer = timer + 1;
			out = 1;
		end
	end
end

endmodule
