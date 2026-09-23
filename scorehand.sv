module scorehand(input [3:0] card1, input [3:0] card2, input [3:0] card3, output [3:0] total);

// The code describing scorehand will go here.  Remember this is a combinational
// block. The function is described in the handout.  Be sure to review the section
// on representing numbers in the lecture notes.


//Personal Notes
// Note to self: reg4 stores the card number, but scorehand uses its point value.
// Ace–9 count as 1–9; 10/J/Q/K and an empty card slot count as 0.
// Add the point values, then take % 10 because only the last decimal digit
// is the hand's score. For example, 9 + 9 = 18, so the score is 8.
//three cases could work but would be excessive use conditional logic

//condition ? value_if_true : value_if_false

	function automatic [3:0] points(input [3:0] card);
		 points = (card <= 4'd9) ? card : 4'd0;
	endfunction
	
	logic [5:0] sum; //must be 6 assume worst case 9,9,9 = 27 need 5 bits at least
	
	assign sum = points(card1) + points(card2) + points(card3);
	
	assign total = sum % 6'd10; //value of sum mod 10 always [0:9] therefore allowed

endmodule

