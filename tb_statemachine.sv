`timescale 1ns/1ps

// Your testbench goes here. Make sure your tests exercise the entire design
// in the .sv file.  Note that in our tests the simulator will exit after
// 10,000 ticks (equivalent to "initial #10000 $finish();").

module tb_statemachine();

	logic tb_slow_clock;
	logic tb_resetb;
	logic [3:0] tb_dscore;
	logic [3:0] tb_pscore;
	logic [3:0] tb_pcard3;
	logic tb_load_pcard1;
	logic tb_load_pcard2;
	logic tb_load_pcard3;
	logic tb_load_dcard1;
	logic tb_load_dcard2;
	logic tb_load_dcard3;
	logic tb_player_win_light;
	logic tb_dealer_win_light;
	
	//instatiate dut
	statemachine dut(
		.slow_clock(tb_slow_clock),
		.resetb(tb_resetb),
		.dscore(tb_dscore),
		.pscore(tb_pscore),
		.load_pcard1(tb_load_pcard1),
		.load_pcard2(tb_load_pcard2),
		.load_pcard3(tb_load_pcard3),
		.load_dcard1(tb_load_dcard1),
		.load_dcard2(tb_load_dcard2),
		.load_dcard3(tb_load_dcard3),
		.dealer_win_light(tb_dealer_win_light),
		.player_win_light(tb_player_win_light)
		
	);
	
	
				
		

	initial begin
	tb_slow_clock = 1'b0;
	tb_resetb = 1'b1;
	
	#5 tb_slow_clock = 1'b1;
	#5
	//state PCARD1
	if(tb_load_dcard1 !== 1'b1)
		$fatal(1,"ERROR: State is not in PCARD1, UNEXPECTED");
		
	tb_resetb = 1'b0;
	#5
	if(tb_load_pcard1 !== 1'b1) 
		$fatal(1,"ERROR: State is not in IDLE after RESET, UNEXPECTED");
	#5
	
    $finish;
	end
	
	
endmodule

