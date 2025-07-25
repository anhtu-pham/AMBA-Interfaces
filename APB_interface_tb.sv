`timescale 1ns / 1ps

module APB_interface_tb #(
    parameter ERR_STATUS_ADDRESS = 1;
    parameter PAYLOAD_ADDRESS = 2;
    parameter DATA_SIZE_ADDRESS = 4;
);
    logic pclk, psel_x, preset_n, penable, pready, pwrite,
    logic [2:0] paddr,
    logic [7:0] pwdata,
    logic [1:0] err_status,
    logic [15:0] payload,
    logic [4:0] data_size,
    logic [7:0] prdata,
    logic pslverr

    APB_interface_module APB_dut (
        .pclk(pclk), 
        .psel_x(psel_x), 
        .preset_n(preset_n),
        .penable(penable),
        .pready(pready),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .err_status(err_status),
        .payload(payload),
        .data_size(data_size),
        .prdata(prdata),
        .pslverr(pslverr)
    );

    initial pclk = 0;
    always #10 pclk = ~pclk; // Clock frequency = 50MHz

    initial begin
        psel_x = 1'd0; preset_n = 1'd1; penable = 1'd0; pready = 1'd0; pwrite = 1'd0; paddr = 3'd0; pwdata = 8'd0; err_status = 2'd0; payload = 16'd0;
        #40;

        // Write data_size = 12 (with pwrite = 1, paddr = DATA_SIZE_ADDRESS, pwdata = 12) to APB interface
        psel_x = 1'd1; pwrite = 1'd1; paddr = DATA_SIZE_ADDRESS; pwdata = 5'd12;
        #20;
        penable = 1'd1;
        #20;
        pready = 1'd1;
        #20;
        psel_x = 1'd0; penable = 1'd0; pready = 1'd0; paddr = 3'd0;
        #40;

        // Read data_size (with pwrite = 0, paddr = DATA_SIZE_ADDRESS)
        psel_x = 1'd1; pwrite = 1'd0; paddr = DATA_SIZE_ADDRESS;
        #20;
        penable = 1'd1; pready = 1'd1;
        #20;
        psel_x = 1'd0; penable = 1'd0; pready = 1'd0; paddr = 3'd0;
        #20;

        // Write payload_0 = 8'b00110011 (with pwrite = 1, paddr = PAYLOAD_ADDRESS, pwdata = 8'b00110011)
        psel_x = 1'd1; pwrite = 1'd1; paddr = PAYLOAD_ADDRESS; pwdata = 8'b00110011;
        #20;
        penable = 1'd1; pready = 1'd1;
        #20;
        psel_x = 1'd0; penable = 1'd0; pready = 1'd0; paddr = 3'd0;
        #20;

        // Write payload_1 = 8'00000011 (with pwrite = 1, paddr = PAYLOAD_ADDRESS, pwdata = 8'00000011)
        psel_x = 1'd1; pwrite = 1'd1; paddr = PAYLOAD_ADDRESS + 1; pwdata = 8'00000011;
        #20;
        penable = 1'd1; pready = 1'd1;
        #20;
        psel_x = 1'd0; penable = 1'd0; pready = 1'd0; paddr = 3'd0;
        #20;

        // Read data_size with async preset_n
        psel_x = 1'd1; pwrite = 1'd0; paddr = DATA_SIZE_ADDRESS;
        #10;
        preset_n = 1'd0;
        #50;
    end
endmodule