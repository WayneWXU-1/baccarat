module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

typedef enum logic [3:0]{
IDLE, PCARD1, DCARD1, PCARD2, DCARD2, PCARD3, DCARD3, DISPLAY
}states;

states state = IDLE;
states next_state = PCARD1;

/*must have intermediary signal since the outputs are wires, any always_comb assignemnts must be logic or variables
not wires, having intermediary variable works around the challenge*/

logic internal_load_pcard1, internal_load_pcard2, internal_load_pcard3;
logic internal_load_dcard1, internal_load_dcard2, internal_load_dcard3;
logic internal_player_win_light, internal_dealer_win_light;

assign load_pcard1 = internal_load_pcard1;
assign load_pcard2 = internal_load_pcard2;
assign load_pcard3 = internal_load_pcard3;
assign load_dcard1 = internal_load_dcard1;
assign load_dcard2 = internal_load_dcard2;
assign load_dcard3 = internal_load_dcard3;
assign player_win_light = internal_player_win_light;
assign dealer_win_light = internal_dealer_win_light;



//resetb supports asyncrhonous reset
always_ff @(posedge slow_clock or negedge resetb) begin
	if(!resetb) 
		state <= IDLE;
		
	else 
		state <= next_state;
end

/*Personal Notes:
- Two assignments in the same block aren’t two separate drivers
- blocking assignments execute top to bottom
- States like DCARD2 are the state that card is distrbuted, but the enable is high prior to entering that state
-cant drive output wire in always comb, it must be driven by assign not be an oridinary assignemnt in alwayscomb
output logic is a variable, where output is a legit wire*/

/* Bare outputs default to wires, which cannot be assigned procedurally.
   Compute internal logic variables in always_comb, then use continuous
   assign statements outside the block to drive the output wires.
   Alternatively, output logic permits direct procedural assignments
   when changing the port declarations is allowed. */



always_comb begin
	//MUST STATE DEFAULT HERE OTHERWISE INFER LATCH moved this up since these are wires
	/*load_pcard1 = 1'b0;
	load_pcard2 = 1'b0;
	load_dcard1 = 1'b0;
	load_dcard2 = 1'b0;
	load_dcard3 = 1'b0;
	load_pcard3 = 1'b0;
	player_win_light = 1'b0;
	dealer_win_light = 1'b0;*/
	
	internal_load_pcard1 = 1'b0;
	internal_load_pcard2 = 1'b0;
	internal_load_pcard3 = 1'b0;
	internal_load_dcard1 = 1'b0;
	internal_load_dcard2 = 1'b0;
	internal_load_dcard3 = 1'b0;
	internal_player_win_light = 1'b0;
	internal_dealer_win_light = 1'b0;
	
	case(state)
	
	IDLE: begin
		next_state = PCARD1;
		internal_load_pcard1 = 1'b1; //preload EN1 so that on first key0 we display
	end
	
	
	PCARD1: begin
		internal_load_dcard1 = 1'b1; //same idea preload
		next_state = DCARD1;
	end
	
	
	DCARD1: begin
		internal_load_pcard2 = 1'b1;
		next_state = PCARD2;
	end
	
	
	PCARD2: begin
		internal_load_dcard2 = 1'b1;
		next_state = DCARD2;
	end
	
	
	DCARD2: begin
		/* Use currently available data to choose next_state and load enables.
			Enables must be high BEFORE the edge that captures the data.
			That edge updates both the state and enabled data registers.
			Decisions needing newly captured data happen AFTER that edge.*/
		
		if(dscore == 4'd8 || dscore == 4'd9 || pscore == 4'd8 || pscore == 4'd9) 
			next_state = DISPLAY;
		
		
		else if(pscore >= 3'd0 && pscore <= 3'd5) begin
			internal_load_pcard3 = 1'b1;
			next_state = PCARD3;
		end
			
			
		
		else if(pscore == 3'd6 || pscore == 3'd7) begin
			internal_load_pcard3 = 1'b0; //no third card
			
			if(dscore >= 0 && dscore <= 5) begin
				internal_load_dcard3 = 1'b1;
				next_state = DCARD3;
			end else begin
				internal_load_dcard3 = 1'b0;
				next_state = DISPLAY;
			end
			
		end
		
		
		else 
			next_state = DISPLAY;
	end
	
	
	
	PCARD3:begin 
		case(dscore)
		3'd7: begin
			internal_load_dcard3 = 1'b0;
			next_state = DISPLAY;
		end
		
		3'd6: begin
			if(pcard3 == 3'd6 || pcard3 == 3'd7) begin
				internal_load_dcard3 = 1'b1; //get card
				next_state = DCARD3;
			end else begin
				internal_load_dcard3 = 1'b1;
				next_state = DISPLAY;
			end
		end
		
		3'd5: begin
			if(pcard3 >= 3'd4 && pcard3 <= 3'd7) begin
				internal_load_dcard3 = 1'b1; //get card
				next_state = DCARD3;
			end else begin
				internal_load_dcard3 = 1'b0;
				next_state = DISPLAY;
			end
			
		end
		
		3'd4: begin
			if(pcard3 >= 3'd2 && pcard3 <= 3'd7) begin
				internal_load_dcard3 = 1'b1; //get card
				next_state = DCARD3;
			end else begin
				internal_load_dcard3 = 1'b0;
				next_state = DISPLAY;
			end
		end
		
		3'd3: begin
			if(pcard3 != 4'd8) begin
				internal_load_dcard3 = 1'b1;
				next_state = DCARD3;
			end else begin
				internal_load_dcard3 = 1'b0;
				next_state = DISPLAY;
			end
		end
		
		3'd2: begin
			internal_load_dcard3 = 1'b1;
			next_state = DCARD3;
		end
		
		3'd1: begin
			internal_load_dcard3 = 1'b1;
			next_state = DCARD3;
		end
		
		3'd0: begin
			internal_load_dcard3 = 1'b1;
			next_state = DCARD3;
		end
		
		default: next_state = DISPLAY;
		
		endcase
	end
	
	
	DCARD3: begin
		next_state = DISPLAY;
	end
	
	
	
	DISPLAY: begin
		next_state = DISPLAY;
		if(dscore > pscore)begin
			internal_dealer_win_light = 1'b1;
			internal_player_win_light = 1'b0;
		end
		
		else if (pscore > dscore) begin
			internal_dealer_win_light = 1'b0;
			internal_player_win_light = 1'b1;
		end
		
		else begin
			internal_dealer_win_light = 1'b1;
			internal_player_win_light = 1'b1;
		end
	end	
	
	
	default: next_state = IDLE; //never occur
	
	endcase

end


endmodule


