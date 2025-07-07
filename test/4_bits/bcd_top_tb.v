`timescale 1ns/1ps
`include "src/bcd_top.v"

module tb_bcp_top;
    // Inputs
    reg clk;
    reg reset;
    reg selector;
    reg [3:0] input_top_1;
    reg [3:0] input_top_2;
    // Outputs
    wire [6:0] SSeg;
    wire [3:0] state_top;

    // Instantiate the Unit Under Test (UUT)
    bcp_top uut (
        .clk(clk),
        .reset(reset),
        .selector_suma_resta(selector),
        .input_top_1(input_top_1),
        .input_top_2(input_top_2),
        .SSeg(SSeg),
        .an(state_top)
    );

    // Clock generation: 100MHz -> period 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("bcd_top_tb.vcd");
        $dumpvars(-1, uut); // 1. nivel de profundidad que llega la simulación, 2. lo que probaré
        // Initialize inputs
        clk = 0;
        reset = 1;
        input_top_1 = 4'd0;
        input_top_2 = 4'd0;
        selector = 0;
        #20;
        // Release reset
        reset = 0;
        #20;

        // Test case 1: Addition 3 + 2 = 5
        input_top_1 = 4'd3;
        input_top_2 = 4'd2;
        selector = 0;
        #1500;

        // Test case 2: Subtraction 5 - 2 = 3
        input_top_1 = 4'd5;
        input_top_2 = 4'b0010; //(sub), B=2
        selector = 1;
        #1500;

        // Test case 3: Addition with overflow 15 + 1 = 0 (carry)
        input_top_1 = 4'd15;
        input_top_2 = 4'd1;
        selector = 0;
        #1500;

        // Test case 4: Subtraction negative 0 - 1 = -1 (two's complement)
        input_top_1 = 4'd0;
        input_top_2 = 4'b0001; // bit4=1 (sub), B=1
        selector = 1;
        #2500;

        // End simulation
        $finish;
    end

endmodule
