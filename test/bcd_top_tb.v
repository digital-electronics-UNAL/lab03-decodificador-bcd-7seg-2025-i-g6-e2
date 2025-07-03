`timescale 1ns/1ps
`include "src/sum1b_estruc.v"
`include "src/sum4b.v"
`include "src/sumres4b.v"
`include "src/dividor_frecuencia.v"
`include "src/BCD.v"
`include "src/BCDtoSSeg.v"
`include "src/bcd_top.v"

module tb_bcp_top;
    // Inputs
    reg clk;
    reg reset;
    reg [4:0] input_top_1;
    reg [4:0] input_top_2;
    // Outputs
    wire [6:0] SSeg;
    wire [2:0] state_top;

    // Instantiate the Unit Under Test (UUT)
    bcp_top uut (
        .clk(clk),
        .reset(reset),
        .input_top_1(input_top_1),
        .input_top_2(input_top_2),
        .SSeg(SSeg),
        .state_top(state_top)
    );

    // Clock generation: 100MHz -> period 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("bcd_top_tb.vcd");
        $dumpvars(-1, uut); // 1. nivel de profundidad que llega la simulación, 2. lo que probaré
        // Initialize inputs
        clk = 0;
        reset = 1;
        input_top_1 = 5'd0;
        input_top_2 = 5'd0;
        #20;
        // Release reset
        reset = 0;
        #20;

        // Test case 1: Addition 3 + 2 = 5
        input_top_1 = 5'd3;
        input_top_2 = 5'd2;       // Sel = 0 (addition)
        #100;

        // Test case 2: Subtraction 5 - 2 = 3
        input_top_1 = 5'd5;
        input_top_2 = 5'b10010; // bit4=1 (sub), B=2
        #100;

        // Test case 3: Addition with overflow 15 + 1 = 0 (carry)
        input_top_1 = 5'd15;
        input_top_2 = 5'd1;
        #100;

        // Test case 4: Subtraction negative 0 - 1 = -1 (two's complement)
        input_top_1 = 5'd0;
        input_top_2 = 5'b10001; // bit4=1 (sub), B=1
        #100;

        // End simulation
        $finish;
    end


endmodule
