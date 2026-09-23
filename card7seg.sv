module card7seg(input [3:0] SW, output [6:0] HEX0);
		
	logic [6:0] reg7;
	assign HEX0 = reg7;
   // your code goes here
	always_comb begin
        case (SW)
            4'd0:  reg7 = 7'b1111111; // no card: blank
            4'd1:  reg7 = 7'b0001000; // A
            4'd2:  reg7 = 7'b0100100; // 2
            4'd3:  reg7 = 7'b0110000; // 3
            4'd4:  reg7 = 7'b0011001; // 4
            4'd5:  reg7 = 7'b0010010; // 5
            4'd6:  reg7 = 7'b0000010; // 6
            4'd7:  reg7 = 7'b1111000; // 7
            4'd8:  reg7 = 7'b0000000; // 8
            4'd9:  reg7 = 7'b0010000; // 9
            4'd10: reg7 = 7'b1000000; // 0
            4'd11: reg7 = 7'b1100001; // J
				4'd12: reg7 = 7'b0011000; // Q
            4'd13: reg7 = 7'b0001001; // H
            default: reg7 = 7'b1111111; // unused values: blank
        endcase
    end
	
endmodule
