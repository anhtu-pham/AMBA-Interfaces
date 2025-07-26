module AHB_read (
    input logic hclk, hsel_x, hreset_n, hready, hwrite,
    input logic [1:0] read_select,
    input logic [1:0] err_status,
    input logic [7:0] payload_0,
    input logic [7:0] payload_1,
    input logic [4:0] data_size,
    output logic [7:0] hrdata,
    output logic hresp
);
    always_ff @(posedge hclk, negedge hreset_n) begin
        if (hsel_x) begin
            if (!hreset_n) begin
                hrdata <= 8'd0;
            end else if (!hwrite && hready) begin
                case (read_select)
                    2'd0: hrdata <= {6'd0, err_status};
                    2'd1: hrdata <= payload_0;
                    2'd2: hrdata <= payload_1;
                    2'd3: hrdata <= {3'd0, data_size};
                    default: ;
                endcase
            end
        end
    end
endmodule
