
`timescale 1ns/1ps
`include "src/divisor_frecuencia.v"

module divisor_tb();

    reg clk_tb;
    reg reset_tb;

    always #5 clk_tb = ~clk_tb;


    divisor_frecuencia #(9, 10) div (
        .clk_50MHz(clk_tb),
        .reset(reset_tb)
    );

    initial begin
        clk_tb = 1'b0;
        reset_tb = 1'b0;
        #3 reset_tb = 1'b1;
        #10 reset_tb = 1'b0;

    end

    initial begin: TEST_CASE
        $dumpfile("divisor_tb.vcd");
        $dumpvars(-1, div);
        #3000 $finish;
    end

endmodule