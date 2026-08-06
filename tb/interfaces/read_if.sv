interface read_if #(
    parameter int DATA_WIDTH = 8
)(
    input   logic   rclk,
    input   logic   rrst_n
);

logic                   rd_en;
logic[DATA_WIDTH-1:0]   rdata;
logic                   rempty;

clocking read_driver @(posedge rclk)
    default input #1step output #1ns;
    input   rempty;
    input   rdata;
    output  rd_en;
endclocking

clocking read_fifo_dut @(posedge rclk)
    default input #1step output #1ns;
    input   rd_en;
    output  rdata;
    output  rempty;
endclocking

endinterface