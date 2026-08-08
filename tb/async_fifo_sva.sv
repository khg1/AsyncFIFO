module async_fifo_sva #(
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

localparam int DEPTH = 1 <<ADDR_WIDTH;

property w_gray_bit_change;
    @(posedge wclk) disable iff (!wrst_n)
        $onehot0($past(wptr_gray) ^ wptr_gray);
endproperty

property r_gray_bit_change;
    @(posedge rclk) disable iff (!rrst_n)
        $onehot0($past(rptr_gray) ^ rptr_gray);
endproperty

property full_derivation;
    @(posedge wclk) disable iff (!wrst_n)
        wfull == (wptr_gray_next == {~rptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_sync[ADDR_WIDTH-2:0]});
endproperty

property no_overflow;
    @(posedge wclk) disable iff (!wrst_n)
        wfull |-> (wptr_gray_next == wptr_gray);
endproperty

property no_underflow;
    @(posedge rclk) disable iff (!rrst_n)
        rempty |-> (rptr_gray_next == rptr_gray);
endproperty

property write_reset_flags;
    @(posedge wclk)
        !wrst_n |=> (wptr_gray == 0 && wfull == 0);
endproperty

property read_reset_flags;
    @(posedge rclk)
        !rrst_n |=> (rptr_gray == 0 && rempty == 1);
endproperty

property write_occupancy_bound;
    @(posedge wclk) disable iff (!wrst_n)
        (wptr_binary - gray2binary(rptr_gray_sync)) inside {[0:DEPTH]};
endproperty

a_w_gray_bit_change: assert property(w_gray_bit_change) else $error("wgray ptr change >1 bit");
a_r_gray_bit_change: assert property(r_gray_bit_change) else $error("rgray ptr change >1 bit");
a_full_derivation: assert property(full_derivation) else $error("wfull mismatch: wfull=%0b, wgraynext=%0h, rgraysync=%0h",wfull, wptr_gray_next, rptr_gray_sync);
a_no_overflow: assert property(no_overflow) else $error("wptr incremented despite wfull");
a_no_underflow: assert property(no_underflow) else $error("rptr incremented despite rempty");
a_write_reset_flags: assert property(write_reset_flags) else $error("improper write reset flags observed");
a_read_reset_flags: assert property(read_reset_flags) else $error("improper read reset flags observed");
a_write_occupancy_bound: assert property(write_occupancy_bound) else $error("wrap bit error detected");

function logic[ADDR_WIDTH:0] gray2binary(logic [ADDR_WIDTH:0] g);
    for(int i = 0; i<=ADDR_WIDTH; i++)   gray2binary[i] = ^(g >> i);
endfunction
endmodule