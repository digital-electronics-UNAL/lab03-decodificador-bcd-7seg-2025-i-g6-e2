//----------------------------------------------------------------------
//  tb_bcp_top_8.v ‒ Banco de pruebas para la versión de 8 bits
//  • Reloj de 100 MHz (10 ns)
//  • Cuatro casos: suma, resta positiva, saturación 0-255, resta negativa
//----------------------------------------------------------------------
`timescale 1ns/1ps
`include "src/8_bits/bcd_top.v"

module tb_bcp_top_8;
    /*----- señales de estímulo -----*/
    reg         clk;
    reg         reset;
    reg         selector;          // 0 = suma, 1 = resta
    reg  [7:0]  input_top_1;
    reg  [7:0]  input_top_2;

    /*----- salidas a observar -----*/
    wire [6:0]  SSeg;
    wire [3:0]  an;                // secuencia centenas-decenas-unidades-signo

    /*----- Instancia del DUT (Device Under Test) -----*/
    bcp_top uut (
        .clk               (clk),
        .reset             (reset),
        .selector_suma_resta(selector),
        .input_top_1       (input_top_1),
        .input_top_2       (input_top_2),
        .SSeg              (SSeg),
        .an                (an)
    );

    /*----- Generador de reloj 100 MHz -----*/
    always #5 clk = ~clk;          // periodo = 10 ns

    initial begin
        $dumpfile("bcd_top_8_bits_tb.vcd");
        $dumpvars(-1, uut);

        clk = 0; reset = 1; selector = 0;
        input_top_1 = 0; input_top_2 = 0;
        #20;  reset = 0;  #20;

        // 1) 255 + 255 = 510  (muestra “510”)
        selector     = 0;
        input_top_1  = 8'd255;
        input_top_2  = 8'd255;
        #3000;

        // 2) 200 + 55 = 255  (sin carry)
        selector     = 0;
        input_top_1  = 8'd200;
        input_top_2  = 8'd55;
        #3000;

        // 3) 150 − 45 = 105
        selector     = 1;
        input_top_1  = 8'd150;
        input_top_2  = 8'd45;
        #3000;

        // 4)  50 − 255 = −205  (muestra “-205”)
        selector     = 1;
        input_top_1  = 8'd50;
        input_top_2  = 8'd255;
        #4000;

        $finish;
    end
endmodule
