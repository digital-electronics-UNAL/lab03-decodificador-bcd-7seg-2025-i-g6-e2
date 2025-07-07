// M = 50000000 / (16 * 9600 baud) = 325.52 = 326

module divisor_frecuencia
    #(
        parameter N = 9, // bits para contador (hasta 512 > 326)
        M = 326
    )
    (
        input clk_50MHz, // reloj cyclone IV
        input reset,
        output reg tick
);

    reg [N-1:0] counter;
    wire [N-1:0] next; // siguiente valor de counter

    initial begin
        tick = 1'b0;
        counter = 'd0;
    end

    always @(posedge clk_50MHz)begin
        if(reset) begin 
            counter <= 0;
            tick <= 0;
        end else if (counter == M) begin
            counter <= 'b0;
            tick <= ~tick;
        end else begin
            counter <= counter +1 ;
        end
    end

    // assign next = (counter == (M-1)) ? 0 : counter + 1;
    
    // assign tick = (counter == (M-1)) ? 1'b1 : 1'b0; // salida 1 cuando llega al final de 1 ciclo

endmodule