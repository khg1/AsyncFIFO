module tb_top;
    import uvm_pkg::*;
    import fifo_pkg::*;

    logic wclk, rclk, wrst_n, rrst_n;
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 4;
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;
    end

    initial begin
        rclk = 0;
        forever #6 rclk = ~rclk;
    end

    initial begin
        wrst_n = 0;
        repeat(4) @(posedge wclk);
        @(negedge wclk);
        wrst_n = 1;
    end

    initial begin
        rrst_n = 0;
        repeat(4) @(posedge rclk);
        @(negedge rclk);
        rrst_n = 1;
    end

    read_if#(DATA_WIDTH) r_if (.rclk(rclk), .rrst_n(rrst_n));
    write_if#(DATA_WIDTH) w_if (.wclk(wclk), .wrst_n(wrst_n));

    async_fifo#(DATA_WIDTH, ADDR_WIDTH) DUT (
        .wclk(wclk),
        .wrst_n(wrst_n),
        .wr_en(w_if.wr_en),
        .write_data(w_if.wdata),
        .wfull(w_if.wfull),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rd_en(r_if.rd_en),
        .rdata(r_if.rdata),
        .rempty(r_if.rempty)
    );

    bind async_fifo async_fifo_sva#(DATA_WIDTH,ADDR_WIDTH) sva_inst(
        .wclk(wclk),
        .wrst_n(wrst_n),
        .wr_en(wr_en),
        .write_data(write_data),
        .wfull(wfull),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .rd_en(rd_en),
        .rdata(rdata),
        .rempty(rempty),
        .wptr_binary(inst_write_handler.wptr_binary),
        .wptr_gray(inst_write_handler.wptr_gray),
        .wptr_gray_next(inst_write_handler.wptr_gray_next),
        .rptr_gray(inst_read_handler.rptr_gray),
        .rptr_gray_next(inst_read_handler.rptr_gray_next),
        .rptr_gray_sync(inst_write_handler.rptr_gray_sync)
    );

    initial begin
        uvm_config_db#(virtual read_if#(DATA_WIDTH))::set(null, "*", "read_if", r_if);
        uvm_config_db#(virtual write_if#(DATA_WIDTH))::set(null, "*", "write_if", w_if);
        run_test();
    end

    initial begin
        $fsdbDumpfile("waves.fsdb");
        $fsdbDumpvars(0, tb_top, "+mda");
    end
endmodule