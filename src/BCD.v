module BCD (
    input tick,
    input [4:0] input_num, // hasta el 31
    output reg [3:0] segments,
    output reg state;
);

    state = 0;

    always @(posedge tick) begin
        case (state)
            0: begin
                // Mostrar unidades
                segments <= input_num % 10;
                state <= 1;
            end
            1: begin
                // Mostrar decenas
                segments <= input_num / 10;
                state <= 0;
            end
        endcase
    end

endmodule
