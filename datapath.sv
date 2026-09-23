module datapath(input slow_clock, input fast_clock, input resetb,
                input load_pcard1, input load_pcard2, input load_pcard3,
                input load_dcard1, input load_dcard2, input load_dcard3,
                output [3:0] pcard3_out,
                output [3:0] pscore_out, output [3:0] dscore_out,
                output[6:0] HEX5, output[6:0] HEX4, output[6:0] HEX3,
                output[6:0] HEX2, output[6:0] HEX1, output[6:0] HEX0);
						
// The code describing your datapath will go here.  Your datapath 
// will hierarchically instantiate six card7seg blocks, two scorehand
// blocks, and a dealcard block.  The registers may either be instatiated
// or included as sequential always blocks directly in this file.
//
// Follow the block diagram in the Lab 1 handout closely as you write this code.


	logic [3:0] new_card; //temp. var to store the dealed card
	logic [3:0] pcard1, pcard2, pcard3; //register
   logic [3:0] dcard1, dcard2, dcard3;

   // Generate card numbers using the fast clock.
   dealcard deal(
		.clock(fast_clock),
		.resetb(resetb),
		.new_card(new_card)
	);

   // Six 4-bit registers, each with its own load enable.
   always_ff @(posedge slow_clock or negedge resetb) begin
		if (!resetb) begin
			pcard1 <= 4'd0;
         pcard2 <= 4'd0;
			pcard3 <= 4'd0;
			dcard1 <= 4'd0;
			dcard2 <= 4'd0;
			dcard3 <= 4'd0;
		end else begin
			if (load_pcard1) pcard1 <= new_card;
			if (load_pcard2) pcard2 <= new_card;
			if (load_pcard3) pcard3 <= new_card;
			
			if (load_dcard1) dcard1 <= new_card;
			if (load_dcard2) dcard2 <= new_card;
			if (load_dcard3) dcard3 <= new_card;
        end
    end

	// Player card displays.
	card7seg player_display1(.card(pcard1), .seg7(HEX0));
	card7seg player_display2(.card(pcard2), .seg7(HEX1));
	card7seg player_display3(.card(pcard3), .seg7(HEX2));

    // Dealer card displays.
	card7seg dealer_display1(.card(dcard1), .seg7(HEX3));
   card7seg dealer_display2(.card(dcard2), .seg7(HEX4));
	card7seg dealer_display3(.card(dcard3), .seg7(HEX5));

   // Calculate each hand's score.
   scorehand player_score(
		.card1(pcard1),
      .card2(pcard2),
      .card3(pcard3),
      .total(pscore_out)
	);

	scorehand dealer_score(
		.card1(dcard1),
      .card2(dcard2),
      .card3(dcard3),
      .total(dscore_out)
	);

   // The controller needs the player's third card identity.
   assign pcard3_out = pcard3;

endmodule

