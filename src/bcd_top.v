module bcp_top (
    input clk, // clocks
    input reset, // reset
    input [4:0] input_top_1, // número de entrada 1,
    input [4:0] input_top_2, // número de entrada 2,
    output [6:0] SSeg, // segmentos a–g del display
    output [2:0] state_top  // determina el anodo, 0 para unidades 1 para decenas
);

    wire tick;
    wire [3:0] segments_top; // muestra unidades o decenas

    divisor_frecuencia #(9, 10) div (
        .clk_50MHz(clk),
        .reset(reset),
        .tick(tick)
    );

    suma_resta

    // Alterna entre unidades y decenas del número de entrada
    BCD bcd (
        .tick(tick),
        .input_num(input_top),
        .segments(segments_top)
        .state(state_top)
    );


    // Decodifica el número a segmentos y controla qué dígito se enciende
    BCDtoSSeg bcd_to_7_seg (
        .BCD(segments_top),
        .SSeg(SSeg),
    );

endmodule
