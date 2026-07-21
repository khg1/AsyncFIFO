module read_handler #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input   logic   rclk,
    input   logic   rd_en,
    input   logic   rrst_n,
    input   logic[ADDR_WIDTH:0] g_wptr_sync,
    output  logic               rempty,
    output  logic[ADDR_WIDTH:0] g_rptr,
    output  logic[ADDR_WIDTH:0] b_rptr
);

logic[ADDR_WIDTH:0] b_rptr_next, g_rptr_next;
assign  g_rptr = binary_to_gray(b_rptr);
assign  g_rptr_next = binary_to_gray(b_rptr_next);

always_ff @(posedge rclk or negedge rrst_n) begin
    if(~rrst_n) b_rptr <= '0;
    else        b_rptr <= b_rptr_next;
end

always_comb begin
    b_rptr_next = b_rptr;
    rempty = (g_rptr == g_wptr_sync);
    if(~rempty && rd_en)    b_rptr_next = b_rptr_next + 1;
end

function logic[ADDR_WIDTH:0] binary_to_gray(logic[ADDR_WIDTH:0] b);
    logic[ADDR_WIDTH:0] g;
    g = b ^ (b >> 1);
    return g;
endfunction

endmodule