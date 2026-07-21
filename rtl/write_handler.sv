module write_handler #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input   logic   wclk,
    input   logic   wrst_n,
    input   logic   wr_en,
    input   logic[ADDR_WIDTH:0] g_rptr_sync,
    output  logic[ADDR_WIDTH:0] g_wptr,
    output  logic[ADDR_WIDTH:0] b_wptr,
    output  logic               wfull
);

logic[ADDR_WIDTH:0] b_wptr_next, g_wptr_next;
assign  g_wptr = binary_to_gray(b_wptr);
assign  g_wptr_next = binary_to_gray(b_wptr_next);

always_ff @(posedge wclk or negedge wrst_n) begin
    if(~wrst_n) b_wptr <= '0;
    else        b_wptr <= b_wptr_next;
end

always_comb begin
    b_wptr_next = b_wptr;
    wfull = (wptr_gray_next == {~g_rptr_sync[ADDR_WIDTH:ADDR_WIDTH-1], g_rptr_sync[ADDR_WIDTH-2:0]});
    if(~wfull && wr_en)  b_wptr_next = b_wptr_next + 1;
end

function logic[ADDR_WIDTH:0] binary_to_gray(logic[ADDR_WIDTH:0] b);
    logic[ADDR_WIDTH:0] g;
    g = b ^ (b >> 1);
    return g;
endfunction

endmodule