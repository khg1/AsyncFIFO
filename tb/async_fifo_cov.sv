module async_fifo_cov #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input   logic   wclk,
    input   logic   wrst_n,
    input   logic   wr_en,
    input   logic[DATA_WIDTH-1:0]   write_data,
    input   logic                   wfull,
    input   logic [ADDR_WIDTH:0]  wptr_binary,
    input   logic [ADDR_WIDTH:0]  wptr_gray,
    input   logic [ADDR_WIDTH:0]  wptr_gray_next,

    //read domain
    input   logic   rclk,
    input   logic   rrst_n,
    input   logic   rd_en,
    input  logic[DATA_WIDTH-1:0]   rdata,
    input  logic   rempty,
    input   logic [ADDR_WIDTH:0]  rptr_gray,
    input   logic [ADDR_WIDTH:0]  rptr_gray_sync,
    input   logic [ADDR_WIDTH:0]  rptr_gray_next
);

localparam int DEPTH = 1 << ADDR_WIDTH;
logic [ADDR_WIDTH:0] w_occupancy;
assign w_occupancy = wptr_binary - gray2binary(rptr_gray_sync);

covergroup write_cov @(posedge wclk);
    cp_wfull_transition: coverpoint wfull {
        bins full_to_notfull = (1 => 0);
        bins notfull_to_full = (0 => 1);
    }

    cp_occupancy: coverpoint w_occupancy{
        bins zero = {0};
        bins full = {DEPTH};
        bins low = {[1:DEPTH/4]};
        bins mid = {[DEPTH/4+1:3*DEPTH/4-1]};
        bins high = {[3*DEPTH/4:DEPTH-1]};
    } 

    cp_wrap_bit: coverpoint (wptr_binary[ADDR_WIDTH]){
        bins b0 = {0};
        bins b1 = {1};
    }
endgroup

covergroup read_cov @(posedge rclk);
    cp_rempty_transition: coverpoint rempty {
        bins empty_to_notempty = (1 => 0);
        bins notempty_to_empty = (0 => 1);
    }
endgroup

covergroup concurrency_cov;
    cp_wr_en: coverpoint wr_en;
    cp_rd_en: coverpoint rd_en;
    cross_concurrent: cross cp_wr_en, cp_rd_en;
endgroup

function logic[ADDR_WIDTH:0] gray2binary(logic [ADDR_WIDTH:0] g);
    for(int i = 0; i<=ADDR_WIDTH; i++)   gray2binary[i] = ^(g >> i);
endfunction

write_cov       write_cov_h;
read_cov        read_cov_h;
concurrency_cov concurrency_cov_h;

initial begin
    write_cov_h = new();
    read_cov_h  = new();
end

initial begin
    concurrency_cov_h = new();
    forever @(wr_en or rd_en) concurrency_cov_h.sample();
end
endmodule
