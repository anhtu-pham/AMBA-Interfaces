module APB_interface_module (
    input logic pclk, psel_x, preset_n, penable, pready, pwrite,
    input logic [2:0] paddr,
    input logic [7:0] pwdata,
    input logic [1:0] err_status, // data for reading
    output logic [15:0] payload, // data over multiple registers for reading/writing
    output logic [4:0] data_size, // data in 1 register for reading/writing
    output logic [7:0] prdata,
    output logic pslverr // transfer error bit
);
    logic [1:0] write_select;
    logic [1:0] read_select;

    logic [7:0] payload_0;
    logic [7:0] payload_1;
    
    address_mapping_module mapping_unit (
        .psel_x(psel_x),
        .pwrite(pwrite),
        .paddr(paddr),
        .write_select(write_select),
        .read_select(read_select),
        .pslverr(pslverr)
    );

    read_module read_unit (
        .pclk(pclk),
        .psel_x(psel_x),
        .preset_n(preset_n),
        .penable(penable),
        .pready(pready),
        .pwrite(pwrite),
        .read_select(read_select),
        .err_status(err_status),
        .payload_0(payload_0),
        .payload_1(payload_1),
        .data_size(data_size),
        .prdata(prdata)
    );

    write_module write_unit (
        .pclk(pclk),
        .psel_x(psel_x),
        .preset_n(preset_n),
        .penable(penable),
        .pready(pready),
        .pwrite(pwrite),
        .write_select(write_select),
        .pwdata(pwdata),
        .payload_0(payload_0),
        .payload_1(payload_1),
        .data_size(data_size)
    );

    always_comb begin
        payload = {payload_1, payload_0};
    end
    
endmodule