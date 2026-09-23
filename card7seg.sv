module card7seg(input [3:0] card, output logic [6:0] seg7);

    always_comb begin
        case (card)
            4'd0:  seg7 = 7'b1111111; // no card: blank
            4'd1:  seg7 = 7'b0001000; // A
            4'd2:  seg7 = 7'b0100100; // 2
            4'd3:  seg7 = 7'b0110000; // 3
            4'd4:  seg7 = 7'b0011001; // 4
            4'd5:  seg7 = 7'b0010010; // 5
            4'd6:  seg7 = 7'b0000010; // 6
            4'd7:  seg7 = 7'b1111000; // 7
            4'd8:  seg7 = 7'b0000000; // 8
            4'd9:  seg7 = 7'b0010000; // 9
            4'd10: seg7 = 7'b1000000; // 0
            4'd11: seg7 = 7'b1100001; // J
            4'd12: seg7 = 7'b0100001; // q
            4'd13: seg7 = 7'b0001001; // H
            default: seg7 = 7'b1111111; // unused values: blank
        endcase
    end

endmodule