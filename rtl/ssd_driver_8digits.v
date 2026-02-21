module ssd_driver_8digits(
    input clk,
    input rst_n,
    input [3:0] digit0,digit1,digit2,digit3,
    input [3:0] digit4,digit5,digit6,digit7,
    output reg [6:0] seg,
    output dp,
    output reg [7:0] anode
);

    assign dp = 0;

    reg [2:0] sel;
    reg [19:0] refresh;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            refresh<=0; sel<=0;
        end else begin
            refresh<=refresh+1;
            if(refresh==0) sel<=sel+1;
        end
    end

    reg [3:0] current_digit;
    always @(*) begin
        case(sel)
            0: current_digit=digit0;
            1: current_digit=digit1;
            2: current_digit=digit2;
            3: current_digit=digit3;
            4: current_digit=digit4;
            5: current_digit=digit5;
            6: current_digit=digit6;
            7: current_digit=digit7;
        endcase
    end

    always @(*) begin
        anode=8'b00000000;
        anode[sel]=1;

        case(current_digit)
            0: seg=7'b1111110;
            1: seg=7'b0110000;
            2: seg=7'b1101101;
            3: seg=7'b1111001;
            4: seg=7'b0110011;
            5: seg=7'b1011011;
            6: seg=7'b1011111;
            7: seg=7'b1110000;
            8: seg=7'b1111111;
            9: seg=7'b1111011;
            default: seg=7'b0000000;
        endcase
    end

endmodule
