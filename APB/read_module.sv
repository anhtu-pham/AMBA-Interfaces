module read_module (
    input logic pclk, psel_x, preset_n, penable, pready, pwrite,
    input logic [1:0] read_select,
    input logic [1:0] err_status,
    input logic [7:0] payload_0,
    input logic [7:0] payload_1,
    input logic [4:0] data_size,
    output logic [7:0] prdata
);
    logic [7:0] data;

    always_comb begin
        prdata = (psel_x && !pwrite && penable && pready) ? data : 8'd0;
    end

    always_ff @(posedge pclk, negedge preset_n) begin
        if (psel_x) begin
            if (!preset_n) begin
                data <= 8'b0;
            end else if (!pwrite) begin
                case (read_select)
                    3'd0: data <= {6'b0, err_status};
                    3'd1: data <= payload_0;
                    3'd2: data <= payload_1;
                    3'd3: data <= {3'b0, data_size};
                endcase
            end
        end
    end
endmodule