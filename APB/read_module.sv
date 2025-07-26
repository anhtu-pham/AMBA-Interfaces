module read_module (
    input logic pclk, psel_x, preset_n, penable, pready, pwrite,
    input logic [1:0] read_select,
    input logic [1:0] err_status,
    input logic [7:0] payload_0,
    input logic [7:0] payload_1,
    input logic [4:0] data_size,
    output logic [7:0] prdata
);
    always_ff @(posedge pclk, negedge preset_n) begin
        if (psel_x) begin
            if (!preset_n) begin
                prdata <= 8'd0;
            end else if (!pwrite && penable && pready) begin
                case (read_select)
                    2'd0: prdata <= {6'd0, err_status};
                    2'd1: prdata <= payload_0;
                    2'd2: prdata <= payload_1;
                    2'd3: prdata <= {3'd0, data_size};
                    default: ;
                endcase
            end
        end
    end
endmodule
