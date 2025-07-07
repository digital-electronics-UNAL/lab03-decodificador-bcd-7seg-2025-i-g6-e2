`include "src/8_bits/divisor_frecuencia.v"
`include "src/8_bits/BCD4.v"
`include "src/8_bits/BCDtoSSeg.v"
`include "src/8_bits/sumres8b.v"
`include "src/4_bits/sum4b.v"
`include "src/8_bits/sum1b_estruc.v"

module bcp_top (
    input  wire       clk,
    input  wire       reset,
    input  wire       selector_suma_resta,   // 0 = suma, 1 = resta
    input  wire [7:0] input_top_1,
    input  wire [7:0] input_top_2,
    output wire [6:0] SSeg,
    output wire [3:0] an
);

    //---------------- 1. Tick de multiplexado -----------------
    wire tick;
    wire [6:0] segments_top; // muestra unidades o decenas

    divisor_frecuencia #(9,10) div (
        .clk_50MHz (clk),
        .reset     (reset),
        .tick      (tick)
    );

    //---------------- 2. ALU 8-bit ----------------------------
    wire [7:0] alu_raw;
    wire flag;              // carry (suma) / borrow (resta)
    sumres8b alu (
        .A   (input_top_1),
        .B   (input_top_2),
        .Sel (selector_suma_resta),
        .So  (alu_raw),
        .flag(flag)
    );

    //---------------- 3. Magnitud (0-510) + signo -------------
    wire carry_pos  = ~selector_suma_resta & flag;   // sólo suma
    wire borrow_neg =  selector_suma_resta & flag;   // sólo resta

    // magnitud positiva de 9 bits
    wire [8:0] magnitude = borrow_neg ? {1'b0,(~alu_raw + 8'd1)} :    // 205
                                    {carry_pos , alu_raw};          // 0-510

    // *** cámbialo aquí ***
    wire [8:0] value_9b = magnitude;      // <-- en lugar de {carry_pos , alu_raw}

    BCD4 disp (
        .tick(tick),
        .val(value_9b), // 0-510
        .neg(borrow_neg), // 1 → mostrar “–”
        .seg(segments_top),
        .an(an)
    );

    BCDtoSSeg bcd_to_7_seg (
        .BCD(segments_top),
        .SSeg(SSeg)
    );

endmodule