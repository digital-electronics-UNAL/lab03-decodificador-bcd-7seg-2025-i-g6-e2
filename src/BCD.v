module BCD (
    input  wire       tick,
    input  wire [4:0] value,   // 0-31, SIEMPRE positivo
    input  wire       neg,     // 1 → mostrar “–”
    output reg  [3:0] segments,
    output reg  [3:0] an
);
    reg [1:0] state = 0;

    always @(posedge tick) begin
        case (state)
            2'd0: begin                     // unidades
                segments <= value % 10;
                an       <= 4'b1110;
                state    <= 2'd1;
            end
            2'd1: begin                     // decenas
                segments <= value / 10;
                an       <= 4'b1101;
                state    <= neg ? 2'd2 : 2'd0;
            end
            2'd2: begin                     // signo “–”
                segments <= 4'hF;
                an       <= 4'b1011;
                state    <= 2'd0;
            end
        endcase
    end
endmodule
