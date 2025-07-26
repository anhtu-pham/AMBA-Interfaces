module write_module (
    input logic pclk, psel_x, preset_n, penable, pready, pwrite,
    input logic [1:0] write_select,
    input logic [7:0] pwdata,
    output logic [7:0] payload_0,
    output logic [7:0] payload_1,
    output logic [4:0] data_size
);
    always_ff @(posedge pclk, negedge preset_n) begin
        if (psel_x) begin
            if (!preset_n) begin
                payload_0 <= 8'd0;
                payload_1 <= 8'd0;
                data_size <= 5'd0;
            end else if (pwrite && (penable && pready)) begin
                case (write_select)
                    2'd0: payload_0 <= pwdata;
                    2'd1: payload_1 <= pwdata;
                    2'd2: data_size <= pwdata[4:0];
                    default: ;
                endcase
            end
        end
    end
endmodule
