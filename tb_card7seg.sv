`timescale 1ns/1ps


module tb_card7seg();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

	logic [3:0] SW;
   wire [6:0] HEX0;

	card7seg dut(.SW(SW), .HEX0(HEX0));

	initial begin
	SW = 4'd0;  #10;
	if (HEX0 !== 7'b1111111) $fatal(1, "SW=0 failed");

	SW = 4'd1;  #10;
	if (HEX0 !== 7'b0001000) $fatal(1, "SW=1 failed");

	SW = 4'd2;  #10;
	if (HEX0 !== 7'b0100100) $fatal(1, "SW=2 failed");

	SW = 4'd3;  #10;
	if (HEX0 !== 7'b0110000) $fatal(1, "SW=3 failed");

	SW = 4'd4;  #10;
	if (HEX0 !== 7'b0011001) $fatal(1, "SW=4 failed");

	SW = 4'd5;  #10;
	if (HEX0 !== 7'b0010010) $fatal(1, "SW=5 failed");

	SW = 4'd6;  #10;
	if (HEX0 !== 7'b0000010) $fatal(1, "SW=6 failed");

	SW = 4'd7;  #10;
	if (HEX0 !== 7'b1111000) $fatal(1, "SW=7 failed");

	SW = 4'd8;  #10;
	if (HEX0 !== 7'b0000000) $fatal(1, "SW=8 failed");

	SW = 4'd9;  #10;
	if (HEX0 !== 7'b0010000) $fatal(1, "SW=9 failed");

	SW = 4'd10; #10;
	if (HEX0 !== 7'b1000000) $fatal(1, "SW=10 failed");

	SW = 4'd11; #10;
	if (HEX0 !== 7'b1100001) $fatal(1, "SW=11 failed");

	SW = 4'd12; #10;
	if (HEX0 !== 7'b0011000) $fatal(1, "SW=12 failed");

	SW = 4'd13; #10;
	if (HEX0 !== 7'b0001001) $fatal(1, "SW=13 failed");

	$display("PASS: all 14 card7seg inputs");
	$finish;
	
	
	end
	
endmodule
