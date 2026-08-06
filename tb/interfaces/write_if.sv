interface write_if #(
    parameter int DATA_WIDTH = 8
)(
    input   logic   wclk,
    input   logic   wrst_n
);

logic                   wr_en;
logic[DATA_WIDTH-1:0]   wdata;
logic                   wfull;

clocking write_driver @(posedge wclk)
    default input #1step output #1ns;
    input   wfull;
    output  wr_en;
    output  wdata;
endclocking

clocking write_fifo_dut @(posedge wclk)
    default input #1step output #1ns;
    input   wr_en;
    input   wdata;
    output   wfull;
endclocking

endinterface