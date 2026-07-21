module dual_RAM #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    //domain write
    input   logic   wclk,
    input   logic   wr_en,
    input   logic[DATA_WIDTH-1:0]   wdata,
    input   logic   wfull,
    input   logic[ADDR_WIDTH:0]   wptr_binary,     

    //domain read
    input   logic   rclk,
    input   logic   rd_en,
    input   logic[DATA_WIDTH-1:0]   rdata,
    input   logic[ADDR_WIDTH:0]   rptr_binary
);

logic[DATA_WIDTH-1:0]   ram [0:(1'b1 << ADDR_WIDTH)-1];

always_ff @(posedge wclk) begin
    if(wr_en && ~wfull) ram[wptr_binary[ADDR_WIDTH-2:0]] <= wdata;
end

always_ff @(posedge rclk) begin
    rdata <= '0;
    if(rd_en && ~rempty)    rdata <= ram[rptr_binary[ADDR__WIDTH-2:0]];    
end
endmodule