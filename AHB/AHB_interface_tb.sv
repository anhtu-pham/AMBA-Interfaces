module AHB_interface_tb #(
    parameter ERR_STATUS_ADDRESS = 1,
    parameter PAYLOAD_ADDRESS = 2,
    parameter DATA_SIZE_ADDRESS = 4,
    parameter ERR_STATUS_HSIZE = 0,
    parameter PAYLOAD_HSIZE = 1,
    parameter DATA_SIZE_HSIZE = 0
);
    logic hclk, hsel_x, hreset_n, hready, hwrite;
    logic [2:0] haddr;
    logic [1:0] htrans;
    logic [2:0] hsize;
    logic [7:0] hwdata;
    logic [1:0] err_status;
    logic [15:0] payload;
    logic [4:0] data_size;
    logic [7:0] hrdata;
    logic hready_out;
    logic hresp;

    AHB_interface AHB_dut (
        .hclk(hclk),
        .hsel_x(hsel_x),
        .hreset_n(hreset_n),
        .hready(hready),
        .hwrite(hwrite),
        .haddr(haddr),
        .htrans(htrans),
        .hsize(hsize),
        .hwdata(hwdata),
        .err_status(err_status),
        .payload(payload),
        .data_size(data_size),
        .hrdata(hrdata),
        .hready_out(hready_out),
        .hresp(hresp)
);
    always #10 hclk = ~hclk;

    initial begin
        $dumpvars(0, AHB_interface_tb);
        hclk = 1'd0;

        @(posedge hclk);
        hsel_x = 1'd0; hreset_n = 1'd1; hready = 1'd0; hwrite = 1'd0; haddr = 3'd0; htrans = 2'd0; hsize = 3'd0; hwdata = 8'd0; err_status = 2'd0;

        // Write data_size = 12 (with hwrite = 1, haddr = DATA_SIZE_ADDRESS, hwdata = 12)
        @(posedge hclk); @(posedge hclk);
        hsel_x = 1'd1; hready = 1'd0; hwrite = 1'd1; haddr = DATA_SIZE_ADDRESS; htrans = 2'd2; hsize = DATA_SIZE_HSIZE; // no hwdata for data_size in address phase
        @(posedge hclk);
        hready = 1'd1;
        // Write payload_0 = 8'b00101001 (with hwrite = 1, haddr = PAYLOAD_ADDRESS, hwdata = 8'b00101001)
        @(posedge hclk);
        hready = 1'd0; hwrite = 1'd1; haddr = PAYLOAD_ADDRESS; htrans = 2'd2; hsize = PAYLOAD_HSIZE; hwdata = 8'd12; // hwdata for data_size in data phase, no hwdata for payload_0 in address phase
        @(posedge hclk); @(posedge hclk);
        hready = 1'd1;
        // IDLE transaction
        @(posedge hclk);
        hready = 1'd1; hwrite = 1'd0; haddr = 3'd0; htrans = 2'd0; hsize = 3'd0; hwdata = 8'b00101001; // hwdata for payload_0 in data phase
        @(posedge hclk);
        hready = 1'd0;
        @(posedge hclk);
        hsel_x = 1'd0;
        

        // Read data_size (with hwrite = 0, haddr = DATA_SIZE_ADDRESS)
        @(posedge hclk);
        hsel_x = 1'd1; hready = 1'd1; hwrite = 1'd0; haddr = DATA_SIZE_ADDRESS; htrans = 2'd2; hsize = 3'd0; // no hwdata for data_size in address phase (read data_size)
        // Write payload_1 = 8'b00001101 (with hwrite = 1, haddr = PAYLOAD_ADDRESS + 1, hwdata = 8'b00001101)
        @(posedge hclk);
        hready = 1'd0; hwrite = 1'd1; haddr = PAYLOAD_ADDRESS + 1; htrans = 2'd2; hsize = PAYLOAD_HSIZE - 1; // no hwdata for data_size in data phase (read data_size), no hwdata for payload_1 in address phase
        @(posedge hclk);
        hready = 1'd1;
        // Read payload_1 (with hwrite = 0, haddr = PAYLOAD_ADDRESS + 1)
        @(posedge hclk);
        hready = 1'd1; hwrite = 1'd0; haddr = PAYLOAD_ADDRESS + 1; htrans = 2'd2; hsize = 3'd0; hwdata = 8'b00001101; // hwdata for payload_1 in data phase, no hwdata for payload_1 in address phase (read payload_1)
        // IDLE transaction
        @(posedge hclk);
        hready = 1'd1; hwrite = 1'd0; haddr = 3'd0; htrans = 2'd0; hsize = 3'd0; // no hwdata for payload_1 in data phase (read payload_1)
        @(posedge hclk);
        hready = 1'd0;
        @(posedge hclk);
        hsel_x = 1'd0;

        // Read data_size with async hreset_n
        @(posedge hclk);
        hsel_x = 1'd1; hwrite = 1'd1; haddr = DATA_SIZE_ADDRESS; htrans = 2'd2; hsize = DATA_SIZE_HSIZE;
        #10;
        hreset_n = 1'd0;
        #50;

        $finish;
    end

endmodule