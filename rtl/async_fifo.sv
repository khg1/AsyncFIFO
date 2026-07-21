module async_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    //write domain
    input   logic   wclk,
    input   logic   wrst_n,
    input   logic   wr_en,
    input   logic[DATA_WIDTH-1:0]   write_data,
    output  logic                   wfull,

    //read domain
    input   logic   rclk,
    input   logic   rrst_n,
    input   logic   rd_en,
    output  logic[DATA_WIDTH-1:0]   rdata,
    output  logic   rempty
);

logic   [ADDR_WIDTH:0]  

endmodule