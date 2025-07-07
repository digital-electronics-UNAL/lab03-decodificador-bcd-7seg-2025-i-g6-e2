`include "src/divisor_frecuencia.v"
`include "src/BCD.v"
`include "src/BCDtoSSeg.v"
`include "src/sumres4b.v"
`include "src/sum4b.v"
`include "src/sum1b_estruc.v"


module bcp_top (
    input clk, // clocks
    input reset, // reset
    input selector_suma_resta,
    input [3:0] input_top_1, // número de entrada 1,
    input [3:0] input_top_2, // número de entrada 2,
    output [6:0] SSeg, // segmentos a–g del display
    output [3:0] an  // determina el anodo, 0 para unidades 1 para decenas
);

    wire tick;
    wire carry;
    wire [3:0] input_top;
    wire [3:0] segments_top; // muestra unidades o decenas

    divisor_frecuencia #(9, 10) div (
        .clk_50MHz(clk),
        .reset(reset),
        .tick(tick)
    );

    wire [3:0] alu_raw;
    wire       flag;           // carry ó borrow

    sumres4b alu (
        .A   (input_top_1),
        .B   (input_top_2),
        .Sel (selector_suma_resta),
        .So  (alu_raw),
        .flag(flag)
    );

    /*--------- decodificamos los casos -------------------------------*/
    wire carry_pos  = ~selector_suma_resta & flag;   // sólo suma
    wire borrow_neg =  selector_suma_resta & flag;   // sólo resta

    /* valor en magnitud siempre positivo */
    wire [3:0] magnitude = borrow_neg ? (~alu_raw + 4'd1) : alu_raw;

    /* hasta 31 = 16 + 15 */
    wire [4:0] value_5b  = {carry_pos, magnitude};

    BCD bcd (
        .tick    (tick),
        .value   (value_5b),    // ← NUEVA ENTRADA de 5 bits
        .neg     (borrow_neg),  // ← NUEVA ENTRADA de signo
        .segments(segments_top),
        .an      (an)
    );

    // Decodifica el número a segmentos y controla qué dígito se enciende
    BCDtoSSeg bcd_to_7_seg (
        .BCD(segments_top),
        .SSeg(SSeg)
    );

endmodule
