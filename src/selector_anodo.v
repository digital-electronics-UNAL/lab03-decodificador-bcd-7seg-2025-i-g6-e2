module selector_anodo (
    input tick,
    output reg [3:0] anodo
);

    reg estado = 0;

    always @(posedge tick) begin
        estado <= ~estado;

        case (estado)
            0: anodo <= 4'b1110; // Activa unidades
            1: anodo <= 4'b1101; // Activa decenas
        endcase
    end

endmodule
