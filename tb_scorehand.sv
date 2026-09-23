`timescale 1ns/1ps


module tb_scorehand();

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

	logic [3:0] tb_card1;
	logic [3:0] tb_card2;
	logic [3:0] tb_card3;
	logic [3:0] tb_total;
	
	scorehand dut(
	.card1(tb_card1),
	.card2(tb_card2),
	.card3(tb_card3),
	.total(tb_total)
	);
	
	
	task automatic reset_card;
	tb_card1 = 4'd0;
	tb_card2 = 4'd0;
	tb_card3 = 4'd0;
	endtask
	
	
	initial begin
	tb_card1 = 4'd5;
	tb_card2 = 4'd6;
	tb_card3 = 4'd8;
	#5
	if(tb_total != 4'd9)
		$fatal(1,"ERROR: c1 = 5, c2 = 6, c3 = 8, total = 19 mod 10 should = 9, NOT EQUAL");
		
	$display("PASS: case c1 = 5, c2 = 6, c3 = 8");
	reset_card;
	
	
	#5
	tb_card1 = 4'd9;
	tb_card2 = 4'd9;
	tb_card3 = 4'd9;
	#5
	if(tb_total !== 4'd7)
		$fatal(1,"ERROR: c1 = 9, c2 = 9, c3 = 9, total = 27 mod 10 should = 7, NOT EQUAL");
		
	$display("PASS: case c1 = 9, c2 = 9, c3 = 9");
	reset_card;
	
	#5
	tb_card1 = 4'd1;
	tb_card2 = 4'd4;
	tb_card3 = 4'd13;
	#5
	if(tb_total !== 4'd5)
		$fatal(1,"ERROR: c1 = 1, c2 = 4, c3 = 13, total = 5 mod 10 should = 5, NOT EQUAL");
		
	$display("PASS: case c1 = 1, c2 = 4, c3 = 13");
	reset_card;
	
	
	#5
	tb_card1 = 4'd0;
	tb_card2 = 4'd5;
	tb_card3 = 4'd10;
	#5
	if(tb_total !== 4'd5)
		$fatal(1,"ERROR: c1 = 0, c2 = 5, c3 = 10, total = 5 mod 10 should = 5, NOT EQUAL");
		
	$display("PASS: case c1 = 0, c2 = 5, c3 = 10");
	reset_card;
	
	$finish;
	end
						
endmodule

