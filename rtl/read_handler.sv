module read_handler #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input   logic   rclk,
    input   logic   rd_en,
    input   logic   rrst_n,
    input   logic[ADDR_WIDTH:0] wptr_gray_sync,
    output  logic               rempty,
    output  logic[ADDR_WIDTH:0] rptr_gray,
    output  logic[ADDR_WIDTH:0] rptr_binary
);

logic[ADDR_WIDTH:0] rptr_binary_next, rptr_gray_next;
assign  rptr_gray = binary_to_gray(rptr_binary);
assign  rptr_gray_next = binary_to_gray(rptr_binary_next);

always_ff @(posedge rclk or negedge rrst_n) begin
    if(~rrst_n) rptr_binary <= '0;
    else        rptr_binary <= rptr_binary_next;
end

always_comb begin
    rptr_binary_next = rptr_binary;
    rempty = (rptr_gray == wptr_gray_sync);
    if(~rempty && rd_en)    rptr_binary_next = rptr_binary_next + 1;
end

function logic[ADDR_WIDTH:0] binary_to_gray(logic[ADDR_WIDTH:0] b);
    logic[ADDR_WIDTH:0] g;
    g = b ^ (b >> 1);
    return g;
endfunction

endmodule