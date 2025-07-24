module write_module (
    input logic pclk, psel_x, preset_n, penable, pready, pwrite,
    input logic [1:0] write_select,
    input logic [7:0] pwdata,
    output logic [7:0] payload_0,
    output logic [7:0] payload_1,
    output logic [4:0] data_size
);
    logic write_payload_0;
    logic write_payload_1;
    logic write_data_size;

    always_comb begin
        if (psel_x && pwrite && penable && pready) begin
            payload_0 = (write_payload_0) ? pwdata : 8'd0;
            payload_1 = (write_payload_1) ? pwdata : 8'd0;
            data_size = (write_data_size) ? pwdata[4:0] : 8'd0;
        end else begin
            payload_0 = 8'd0;
            payload_1 = 8'd0;
            data_size = 8'd0;
        end
    end
    
    always_ff @(posedge pclk, negedge preset_n) begin
        if (psel_x) begin
            if (!preset_n) begin
                write_payload_0 <= 1'd0;
                write_payload_1 <= 1'd0;
                write_data_size <= 1'd0;
                // payload_0 <= 8'b0;
                // payload_1 <= 8'b0;
                // data_size <= 4'b0;
            end else if (pwrite) begin
                case (write_select)
                    3'd0: write_payload_0 <= 1'd1;
                    3'd1: write_payload_1 <= 1'd1;
                    3'd2: write_data_size <= 1'd1;
                    // 3'd0: payload_0 <= pwdata;
                    // 3'd1: payload_1 <= pwdata;
                    // 3'd2: data_size <= pwdata[3:0];
                endcase
            end
        end
    end
endmodule