module AHB_interface (
    input logic hclk, hsel_x, hreset_n, hready, hwrite,
    input logic [2:0] haddr,
    input logic [1:0] htrans,
    input logic [2:0] hsize, // size of transfer = 2^hsize
    input logic [7:0] hwdata,
    input logic [1:0] err_status,  // data for reading
    output logic [15:0] payload,  // data over multiple registers for reading/writing
    output logic [4:0] data_size,  // data in 1 register for reading/writing
    output logic [7:0] hrdata,
    output logic hready_out,
    output logic hresp  // transfer error bit
);
    logic [1:0] read_select, write_select;
    logic [7:0] payload_0, payload_1;
    
    logic hwrite_reg;
    logic [1:0] write_select_reg, read_select_reg;

    AHB_address_mapping mapping_unit (
        .hsel_x(hsel_x),
        .hwrite(hwrite),
        .haddr(haddr), 
        .htrans(htrans),
        .hsize(hsize),
        .write_select(write_select),
        .read_select(read_select),
        .hresp(hresp)
    );

    AHB_read read_unit (
        .hclk(hclk),
        .hsel_x(hsel_x), 
        .hreset_n(hreset_n), 
        .hready(hready), 
        .hwrite(hwrite_reg),
        .read_select(read_select_reg),
        .err_status(err_status),
        .payload_0(payload_0),
        .payload_1(payload_1),
        .data_size(data_size),
        .hrdata(hrdata),
        .hresp(hresp)
    );

    AHB_write write_unit (
        .hclk(hclk), 
        .hsel_x(hsel_x),
        .hreset_n(hreset_n), 
        .hready(hready), 
        .hwrite(hwrite_reg),
        .write_select(write_select_reg),
        .hwdata(hwdata),
        .payload_0(payload_0),
        .payload_1(payload_1),
        .data_size(data_size),
        .hresp(hresp)
    );

    always_ff @(posedge hclk, negedge hreset_n) begin
        if (hsel_x) begin
            if (!hreset_n) begin
                hwrite_reg <= 1'dx;
                write_select_reg <= 2'dx;
                read_select_reg <= 2'dx;

            end else begin
                hwrite_reg <= hwrite;
                write_select_reg <= write_select;
                read_select_reg <= read_select;
            end
        end
    end
endmodule