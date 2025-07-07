//---------------------------------------------------------------------------
//  BCD4.v  –  Multiplexa centenas, decenas, unidades y signo
//  • val : 0–255   (positivo)
//  • neg : 1 → mostrar “–” en el cuarto dígito
//---------------------------------------------------------------------------
module BCD4 (
    input  wire       tick,
    input  wire [8:0] val,
    input  wire       neg,
    output reg  [3:0] seg,
    output reg  [3:0] an
);
    /*----------- Descomposición decimal sencilla -----------*/
    wire [3:0] unidades = val % 10;
    wire [3:0] decenas = (val / 10) % 10;
    wire [3:0] centenas = val / 100;  // 0-5

    reg [1:0] state = 0;

    always @(posedge tick) begin
        case (state)
            2'd0: begin                 // unidades
                seg <= unidades;
                an <= 4'b1110;
                state <= 2'd1;
            end
            2'd1: begin                 // decenas
                seg <= decenas;
                an <= 4'b1101;
                state <= 2'd2;
            end
            2'd2: begin                 // centenas
                seg <= centenas;
                an  <= 4'b1011;
                state  <= neg ? 2'd3 : 2'd0;
            end
            2'd3: begin                 // signo “–”
                seg <= 4'hF;
                an  <= 4'b0111;
                state  <= 2'd0;
            end
        endcase
    end
endmodule
