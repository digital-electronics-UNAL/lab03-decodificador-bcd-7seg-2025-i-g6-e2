module display (
    input  wire        clk,            // Reloj para multiplexar
    input  wire [3:0]  unidades,       // Entrada BCD para unidades
    input  wire [3:0]  decenas,        // Entrada BCD para decenas
    // input  wire [3:0]  centenas,     // (no usado por ahora)
    // input  wire [3:0]  millares,     // (no usado por ahora)
    output reg  [6:0]  segments,       // Salida a segmentos del display (negativa)
    output reg  [3:0]  display_enable  // Salida de habilitación para cada display (negativa)
);

    // Estados para seleccionar el display activo
    reg [1:0] state; // 2 bits para 4 estados, pero solo usaremos 0 y 1

    // Instancias del módulo uni_7seg para convertir cada valor BCD en segmentos
    wire [6:0] unidades_segments;
    wire [6:0] decenas_segments;
    // wire [6:0] centenas_segments;  // (comentado)
    // wire [6:0] millares_segments;  // (comentado)

    // Conversión BCD → 7 segmentos para unidades y decenas
    uni_7seg unidades_to_segments (
        .uni(unidades),
        .segments(unidades_segments)
    );

    uni_7seg decenas_to_segments (
        .uni(decenas),
        .segments(decenas_segments)
    );

    /*
    // No necesarias por ahora:
    uni_7seg centenas_to_segments (
        .uni(centenas),
        .segments(centenas_segments)
    );

    uni_7seg millares_to_segments (
        .uni(millares),
        .segments(millares_segments)
    );
    */

    // Avanza el estado (00→01→00→…) en cada flanco de clk
    always @(posedge clk) begin
        state <= state + 1;
    end

    // Multiplexado: solo casos 0 y 1
    always @(*) begin
        case (state)
            2'b00: begin
                // Mostrar unidades
                display_enable = 4'b1110;     // habilita digito 0 (unidad)
                segments       = unidades_segments;
            end
            2'b01: begin
                // Mostrar decenas
                display_enable = 4'b1101;     // habilita digito 1 (decena)
                segments       = decenas_segments;
            end
            default: begin
                // Apagar en los demás estados
                display_enable = 4'b1111;
                segments       = 7'b1111111;
            end
        endcase
    end

endmodule



module top(
    input  wire        sys_clk,        // Reloj principal del FPGA
    input  wire [7:0]  number,         // Valor 0–99
    output wire [6:0]  segments,
    output wire [3:0]  display_enable
);

    // 2.1) Separar dígitos en BCD
    //    unidades = number % 10
    //    decenas  = number / 10
    wire [3:0] unidades = number % 10;
    wire [3:0] decenas  = number / 10;

    // 2.2) Instanciar tu display
    display disp_inst (
        .clk            (sys_clk),
        .unidades      (unidades),
        .decenas       (decenas),
        .segments      (segments),
        .display_enable(display_enable)
    );

endmodule


// testbench
`timescale 1ns/1ps          // 1️⃣ Define la resolución de tiempo de la simulación

module tb_display;         // 2️⃣ Nombre arbitrario para tu testbench

    // 3️⃣ Señales internas que conectarán con tu DUT (Device Under Test)
    reg         sys_clk;           // Reloj que generarás tú mismo
    reg  [7:0]  number;            // Entrada que escribes para probar distintos valores
    wire [6:0]  segments;          // Salida de segmentos del display
    wire [3:0]  display_enable;    // Salida de habilitación de dígitos

    // 4️⃣ Instancia de tu módulo top (que a su vez llama a display)
    top dut (
        .sys_clk        (sys_clk),
        .number         (number),
        .segments       (segments),
        .display_enable (display_enable)
    );

    // 5️⃣ Generación de un reloj “simple”: 50 MHz → periodo 20 ns
    initial begin
        sys_clk = 0;
        forever #10 sys_clk = ~sys_clk;
    end

    // 6️⃣ Estímulos: cambia ‘number’ cada cierto tiempo
    initial begin
        // 6.1) Preparar grabación de señales en un fichero VCD
        $dumpfile("display.vcd");
        $dumpvars(0, tb_display);

        // 6.2) Asignar valores y esperar
        number = 8'd0;   #200;  // prueba 00
        number = 8'd7;   #200;  // prueba 07
        number = 8'd12;  #200;  // prueba 12
        number = 8'd34;  #200;  // prueba 34
        number = 8'd99;  #200;  // prueba 99

        // 6.3) Termina la simulación
        $finish;
    end

endmodule
