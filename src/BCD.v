module BCD (
    input tick,
    input [3:0] input_num, // hasta el 31
    input sign,
    input selector,
    output reg [3:0] segments,
    output reg [1:0] an;
);
    wire [4:0] input_real 

    assign input_real = (selector)? {1'b0, input_num} : {sign, input_num};

    reg [2:0] state ;

    initial begin
        state = 3'b000;
    end

    always @(posedge tick) begin
        case (state)
            3'b000: begin
                // Mostrar unidades
                segments <= input_real % 10;
                state <= 3'b001;
                an = 4'b1110;
            end
            3'b001: begin
                // Mostrar decenas
                segments <= input_real / 10;
                state <= (signo)? 3'b010 : 3'b000 ;
                an = 4'b1101;
            end
            3'b010: begin
                segments <= 4'b1111;
                state <= 3'b000;
                an = 4'b1011;
            end
        endcase
    end

endmodule
