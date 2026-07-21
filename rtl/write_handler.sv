module write_handler #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input   logic   wclk,
    input   logic   wrst_n,
    input   logic   wr_en,
    input   logic[ADDR_WIDTH:0] rptr_gray_sync,
    output  logic[ADDR_WIDTH:0] wptr_gray,
    output  logic[ADDR_WIDTH:0] wptr_binary,
    output  logic               wfull
);

logic[ADDR_WIDTH:0] wptr_binary_next, wptr_gray_next;
assign  wptr_gray = binary_to_gray(wptr_binary);
assign  wptr_gray_next = binary_to_gray(wptr_binary_next);

always_ff @(posedge wclk) begin
    if(~wrst_n) wptr_binary <= '0;
    else        wptr_binary <= wptr_binary_next;
end

always_comb begin
    wptr_binary_next = wptr_binary;
    wfull = (wptr_gray_next == {~rptr_gray_sync[ADDR_WIDTH:ADDR_WIDTH-1], rptr_gray_sync[ADDR_WIDTH-2:0]});
    if(~wfull && wr_en)  wptr_binary_next = wptr_binary_next + 1;
end

function logic[ADDR_WIDTH:0] binary_to_gray(logic[ADDR_WIDTH:0] b);
    logic[ADDR_WIDTH:0] g;
    g = b ^ (b >> 1);
    return g;
endfunction

endmodule