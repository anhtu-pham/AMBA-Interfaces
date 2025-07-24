module address_mapping_module #(
    parameter ERR_STATUS_ADDRESS = 1;
    parameter PAYLOAD_ADDRESS = 2;
    parameter DATA_SIZE_ADDRESS = 4;
)(
    input logic psel_x, pwrite,
    input logic [2:0] paddr,
    output logic [1:0] write_select,
    output logic [1:0] read_select,
    output logic pslverr
);
    always_comb begin
        if (psel_x) begin
            if (pwrite && paddr == ERR_STATUS_ADDRESS) begin
                pslverr = 1'd1;
            end else begin
                pslverr = 1'd0;
                case (paddr)
                    ERR_STATUS_ADDRESS:
                        read_select = 3'd0;
                    PAYLOAD_ADDRESS:
                        write_select = 3'd0;
                        read_select = 3'd1;
                    PAYLOAD_ADDRESS + 1:
                        write_select = 3'd1;
                        read_select = 3'd2;
                    DATA_SIZE_ADDRESS:
                        write_select = 3'd2;
                        read_select = 3'd3;
                    default:
                        pslverr = 1'd1;
                endcase
            end
        end
    end
endmodule
