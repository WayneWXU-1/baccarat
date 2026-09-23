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
		.pcard3(tb_pcard3),
		.load_pcard1(tb_load_pcard1),
		.load_pcard2(tb_load_pcard2),
		.load_pcard3(tb_load_pcard3),
		.load_dcard1(tb_load_dcard1),
		.load_dcard2(tb_load_dcard2),
		.load_dcard3(tb_load_dcard3),
		.dealer_win_light(tb_dealer_win_light),
		.player_win_light(tb_player_win_light)
		
	);
	
	task automatic clock_tick;
    tb_slow_clock = 1'b0;
    #5 tb_slow_clock = 1'b1;
    #5; // Return after the DUT has settled.
	endtask
	
				
		

	initial begin
	// ============================================================
	// CASE: Player Score 9, Neutral Case, Player Win
	// ============================================================
	
	tb_slow_clock = 1'b0;
	tb_resetb = 1'b1;
	
	#5 tb_slow_clock = 1'b1;
	#5
	//state PCARD1
	if(tb_load_dcard1 !== 1'b1)
		$fatal(1,"ERROR: State is not in PCARD1, UNEXPECTED");
		
	$display("PASS: PCARD1 State Transition output matched");
	tb_resetb = 1'b0;
	#5
	if(tb_load_pcard1 !== 1'b1) 
		$fatal(1,"ERROR: State is not in IDLE after RESET, UNEXPECTED");
		
	$display("PASS: Reset Logic matched");
	#5
	tb_resetb = 1'b1;
	//Above tests 1st state transition & reset logic
	
	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2
	if(tb_load_dcard2 !== 1'b1)
		$fatal(1,"ERROR: State should be in PCARD2");
		
	$display("PASS: PCARD2 State Transition matched");
	
	tb_slow_clock = 1'b0;
	tb_pscore = 4'd9;
	tb_dscore = 3'd5;
	#5 tb_slow_clock = 1'b1;
	#5//dcard2
	
	clock_tick;
	if(tb_player_win_light !== 1'b1)
		$fatal(1,"ERROR: PLAYER ROLE 9, yet no player_win_light");
	#5
	$display("PASS: Case Natural PASSED");
	tb_resetb = 1'b0;
	#5 tb_resetb = 1'b1;
	//resets state to IDLE
	#15
	
	// ============================================================
	// CASE: P0_5, PCARD3 = 6, Dealer DCARD3, Player Win
	// ============================================================
	
	if(tb_load_pcard1 !== 1'b1)
		$fatal(1,"ERROR: Reset pressed should be in IDLE, not in IDLE");
	
	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2
	
	tb_slow_clock = 1'b0;
	tb_pscore = 3'd3; //3 from first two cards
	tb_dscore = 3'd6;
	#5 tb_slow_clock = 1'b1; 
	#5 //dcard2
	if(tb_load_pcard3 !== 1'b1)
		$fatal(1,"ERROR: Should be in DCARD2 P0_5 case, Enable for P3Card should be high");
	
	$display("PASS: In state DCARD2 in P0_5 case");
	
	
	tb_slow_clock = 1'b0;
	tb_pcard3 = 3'd6; //third card is 6
	#5 tb_slow_clock = 1'b1;
	#5//pcard3
	tb_pscore = 4'd9; //updated player score after 3rd card
	
	if(tb_load_dcard3 !== 1'b1)
		$fatal(1,"ERROR: Should be in PCARD3 in case Pcard3 = 6, where Dealer gets DCARD3 Not the case");
	
	$display("PASS: In state PCARD3 with Dealer ENABLE HIGH");
	#5//must have this here otherwise the if statement will sample enable on low clock which means enable is low
	tb_slow_clock = 1'b0;
	tb_dscore = 4'd10;
	#5 tb_slow_clock = 1'b1;
	//dcard3
	#5
	clock_tick; //display
	
	if(tb_dealer_win_light !== 1'b1)
		$fatal(1,"ERROR: Dealer point = 10, Player point = 9, yet Dealer_win_light != 1");
		
	$display("PASS: Case P0_5, PCARD3 = 6, Dealer third card PASSED");
	
	// ============================================================
	// CASE: Player 7 and dealer 6 both stand. CASE 67 -> Game over
	// ============================================================
	tb_resetb = 1'b0;
	#5;
	tb_resetb = 1'b1;
	#5;

	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2

	tb_pscore = 4'd7;
	tb_dscore = 4'd6;
	clock_tick; //dcard2

	if(tb_load_pcard3 !== 1'b0 || tb_load_dcard3 !== 1'b0)
		 $fatal(1, "ERROR: Player 7 and dealer 6 must both stand");

	clock_tick; //display

	if(tb_player_win_light !== 1'b1 ||
		tb_dealer_win_light !== 1'b0)
		 $fatal(1, "ERROR: Player 7 should beat dealer 6");

	$display("PASS: Both stand");
	
		
	// ============================================================
	// Dealer score 3, player's third card is NOT 8.
	// Dealer should draw. CASE 05->point 5
	// ============================================================
	tb_resetb = 1'b0;
	#5;
	tb_resetb = 1'b1;
	#5;

	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2

	tb_pscore = 4'd2;
	tb_dscore = 4'd3;
	clock_tick; //dcard2

	if(tb_load_pcard3 !== 1'b1)
		 $fatal(1, "ERROR: Player score 2 should enable third card");

	clock_tick; //pcard3
	tb_pcard3 = 4'd5;
	tb_pscore = 4'd7; //2 + 5
	#5;

	if(tb_load_dcard3 !== 1'b1)
		 $fatal(1, "ERROR: Dealer 3 should draw when Pcard3 = 5");

	clock_tick; //dcard3
	tb_dscore = 4'd9; //dealer receives a 6
	#5;

	clock_tick; //display

	if(tb_dealer_win_light !== 1'b1 ||
		tb_player_win_light !== 1'b0)
		 $fatal(1, "ERROR: Dealer 9 should beat player 7");

	$display("PASS: Dealer 3 draws when Pcard3 is not 8");
	
	// ============================================================
	// Player score 6: player does NOT draw.
	// Dealer score 5: dealer DOES draw. Case 67->banker gets third card-> Game Over
	// ============================================================
	tb_resetb = 1'b0;
	#5;
	tb_resetb = 1'b1;
	#5;

	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2

	tb_pscore = 4'd6;
	tb_dscore = 4'd5;
	clock_tick; //dcard2

	if(tb_load_pcard3 !== 1'b0)
		 $fatal(1, "ERROR: Player score 6 must not enable third card");

	if(tb_load_dcard3 !== 1'b1)
		 $fatal(1, "ERROR: Dealer score 5 should enable third card");

	clock_tick; //dcard3, skipping pcard3
	tb_dscore = 4'd7; //dealer receives a 2
	#5;

	clock_tick; //display

	if(tb_dealer_win_light !== 1'b1 ||
		tb_player_win_light !== 1'b0)
		 $fatal(1, "ERROR: Dealer 7 should beat player 6");

	$display("PASS: Player stands and dealer draws");
		
		
		
	// ============================================================
	// Dealer score 7: dealer does NOT draw.
	// Player score 3: player DOES draw. Case 05->point 1->Game Over
	// ============================================================
	tb_resetb = 1'b0;
	#5;
	tb_resetb = 1'b1;
	#5;

	clock_tick; //pcard1
	clock_tick; //dcard1
	clock_tick; //pcard2

	tb_pscore = 4'd3;
	tb_dscore = 4'd7;
	clock_tick; //dcard2

	if(tb_load_pcard3 !== 1'b1)
		 $fatal(1, "ERROR: Player score 3 should enable third card");

	clock_tick; //pcard3
	tb_pcard3 = 4'd6;
	tb_pscore = 4'd9; //3 + 6
	#5;

	if(tb_load_dcard3 !== 1'b0)
		 $fatal(1, "ERROR: Dealer score 7 must not enable third card");

	clock_tick; //display, skipping dcard3

	if(tb_player_win_light !== 1'b1 ||
		tb_dealer_win_light !== 1'b0)
		 $fatal(1, "ERROR: Player 9 should beat dealer 7");

	$display("PASS: Dealer 7 stands");
	
    $finish;
	end
	
	
endmodule

