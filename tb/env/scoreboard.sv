class scoreboard#(int DATA_WIDTH = 8, int ADDR_WIDTH = 4) extends uvm_scoreboard;
    `uvm_component_param_utils(scoreboard#(DATA_WIDTH, ADDR_WIDTH))
    uvm_tlm_analysis_fifo #(read_txn_data#(DATA_WIDTH)) read_reqs_buff;
    uvm_tlm_analysis_fifo #(write_txn_data#(DATA_WIDTH)) write_reqs_buff;

    logic [DATA_WIDTH-1:0] ref_queue[$];
    
    int num_write, num_read;

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
        read_reqs_buff = new("read_reqs_buff", this);
        write_reqs_buff = new("write_reqs_buff", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_txn_data#(DATA_WIDTH) wr_req;
        read_txn_data#(DATA_WIDTH) rd_req;
        logic [DATA_WIDTH-1:0]  expected_read_out;
        super.run_phase(phase);
        fork
            forever begin
                write_reqs_buff.get(wr_req);
                ref_queue.push_back(wr_req.write_data_in);
                num_write++;
            end
            forever begin
                read_reqs_buff.get(rd_req);
                if(ref_queue.size() == 0) begin
                    `uvm_error(get_type_name(), "Read happened while fifo is empty")
                end
                else begin
                    expected_read_out = ref_queue.pop_front();
                    num_read++;
                    if(expected_read_out != rd_req.read_data_out) begin
                        `uvm_error(get_type_name(), $sformatf("mismatch on read #%0d: got %0h, expected %0h", num_read, rd_req.read_data_out, expected_read_out))
                    end
                end
            end
        join
    endtask

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        if(num_read == 0) `uvm_error(get_type_name(), "no reads scored")
    endfunction
endclass