module bcp_top (
    input clk, // clocks
    input reset, // reset
    input selector_suma_resta,
    input [3:0] input_top_1, // número de entrada 1,
    input [3:0] input_top_2, // número de entrada 2,
    output [6:0] SSeg, // segmentos a–g del display
    output [2:0] state_top  // determina el anodo, 0 para unidades 1 para decenas
);

    wire tick;
    wire signo;
    wire [3:0] input_top,
    wire [3:0] segments_top; // muestra unidades o decenas

    divisor_frecuencia #(9, 10) div (
        .clk_50MHz(clk),
        .reset(reset),
        .tick(tick)
    );

    sumres4b sumador_restador_4_bits (
        .A(input_top_1),
        .B(input_top_2),
        .Sel(selector_suma_resta),
        .So(input_top),
        .Co(signo)
    );

    // Alterna entre unidades y decenas del número de entrada
    BCD bcd (
        .tick(tick),
        .input_num(input_top),
        .sign(signo),
        .selector(selector_suma_resta),
        .segments(segments_top)
        .state(state_top)
    );

    // Decodifica el número a segmentos y controla qué dígito se enciende
    BCDtoSSeg bcd_to_7_seg (
        .BCD(segments_top),
        .SSeg(SSeg),
    );

endmodule
