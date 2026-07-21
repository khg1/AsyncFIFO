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

logic   [ADDR_WIDTH:0]  d_rptr_gray, q_rptr_gray, q1_rptr_gray;
logic   [ADDR_WIDTH:0]  d_wptr_gray, q_wptr_gray, q1_wptr_gray;
logic   [ADDR_WIDTH:0]  d_wptr_binary, d_rptr_binary;

always_ff @(posedge rclk) begin
    if(~wrst_n) begin
        q_rptr_gray <= '0;
        q1_rptr_gray <= '0;
    end
    else begin
        q_rptr_gray <= d_rptr_gray;
        q1_rptr_gray <= q_rptr_gray;
    end
end

always_ff @(posedge wclk) begin
    if(~wrst_n) begin
        q_wptr_gray <= '0;
        q1_wptr_gray <= '0;
    end
    else begin
        q_wptr_gray <= d_wptr_gray;
        q1_wptr_gray <= q_wptr_gray;
    end
end

dual_RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))  inst_dual_ram (
    .wclk(wclk),
    .wr_en(wr_en),
    .wdata(write_data),
    .wfull(wfull),
    .wptr_binary(d_wptr_binary),
    .rclk(rclk),
    .rd_en(rd_en),
    .rdata(rdata),
    .rptr_binary(d_rptr_binary)
);

write_handler #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))   inst_write_handler (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wr_en(wr_en),
    .rptr_gray_sync(q1_rptr_gray),
    .wptr_gray(d_wptr_gray),
    .wptr_binary(d_wptr_binary),
    .wfull(wfull)
);

read_handler #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))    inst_read_handler (
    .rclk(rclk),
    .rd_en(rd_en),
    .rrst_n(rrst_n),
    .wptr_gray_sync(q1_wptr_gray),
    .rempty(rempty),
    .rptr_gray(d_rptr_gray),
    .rptr_binary(d_rptr_binary)
);

endmodule