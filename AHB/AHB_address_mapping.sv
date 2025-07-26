module AHB_address_mapping #(
    parameter ERR_STATUS_ADDRESS = 1,
    parameter PAYLOAD_ADDRESS = 2,
    parameter DATA_SIZE_ADDRESS = 4
) (
    input logic hsel_x, hwrite,
    input logic [2:0] haddr,
    input logic [1:0] htrans,
    input logic [2:0] hsize,
    output logic [1:0] write_select,
    output logic [1:0] read_select,
    output logic hresp
);
    always_comb begin
        write_select = 2'dx;
        read_select = 2'dx;
        hresp = 1'd0;
        if (hsel_x) begin
            if (hwrite && haddr == ERR_STATUS_ADDRESS) begin
                hresp = 1'd1;
            end else if (htrans != 2'd0 && htrans != 2'd1) begin
                case (haddr)
                    ERR_STATUS_ADDRESS: begin
                        read_select = 2'd0;
                        if (hsize > 3'd1) hresp = 1'd1;
                    end
                    PAYLOAD_ADDRESS: begin
                        write_select = 2'd0;
                        read_select = 2'd1;
                        if (hsize > 3'd2) hresp = 1'd1;
                    end
                    (PAYLOAD_ADDRESS + 1): begin
                        write_select = 2'd1;
                        read_select = 2'd2;
                        if (hsize > 3'd1) hresp = 1'd1;
                    end
                    DATA_SIZE_ADDRESS: begin
                        write_select = 2'd2;
                        read_select = 2'd3;
                        if (hsize > 3'd1) hresp = 1'd1;
                    end
                    default:
                        hresp = 1'd1;
                endcase
            end
        end
    end
endmodule