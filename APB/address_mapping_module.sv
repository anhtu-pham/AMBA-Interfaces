module address_mapping_module #(
    parameter ERR_STATUS_ADDRESS = 1,
    parameter PAYLOAD_ADDRESS = 2,
    parameter DATA_SIZE_ADDRESS = 4
) (
    input logic psel_x, pwrite,
    input logic [2:0] paddr,
    output logic [1:0] write_select,
    output logic [1:0] read_select,
    output logic pslverr
);
    always_comb begin
        pslverr = 1'd0;
        write_select = 2'dx;
        read_select = 2'dx;
        if (psel_x) begin
            if (pwrite && paddr == ERR_STATUS_ADDRESS) begin
                pslverr = 1'd1;
            end else begin
                case (paddr)
                    ERR_STATUS_ADDRESS:
                        read_select = 2'd0;
                    PAYLOAD_ADDRESS: begin
                        write_select = 2'd0;
                        read_select = 2'd1;
                    end
                    (PAYLOAD_ADDRESS + 1): begin
                        write_select = 2'd1;
                        read_select = 2'd2;
                    end
                    DATA_SIZE_ADDRESS: begin
                        write_select = 2'd2;
                        read_select = 2'd3;
                    end
                    default:
                        pslverr = 1'd1;
                endcase
            end
        end
    end
endmodule
