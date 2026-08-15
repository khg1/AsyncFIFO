class write_driver #(int DATA_WIDTH = 8) extends uvm_driver #(write_txn#(DATA_WIDTH));
    `uvm_component_param_utils(write_driver #(DATA_WIDTH))

    virtual write_if #(DATA_WIDTH) vif;
    uvm_analysis_port#(write_txn#(DATA_WIDTH)) write_control_port;
    int num_write;

    function new(string name = "write_driver", uvm_component parent = null);
        super.new(name, parent);
        write_control_port = new("write_control_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual write_if#(DATA_WIDTH))::get(this, "", "write_if", vif))
            `uvm_fatal(get_type_name(), "error extracting vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_txn #(DATA_WIDTH) req;
        vif.write_driver.wr_en <= 1'b0;
        do @(vif.write_driver);
        while(!vif.write_driver.wrst_n);
        forever begin
            seq_item_port.get_next_item(req);
            vif.write_driver.wr_en <= 1'b0;
            repeat(req.pre_delay)   @(vif.write_driver);
            if(req.do_write) begin
                num_write += 1;
                vif.write_driver.wr_en <= 1'b1;
                vif.write_driver.wdata <= req.wdata;
                do begin
                 @(vif.write_driver);
                 if(vif.write_driver.wfull) req.was_full=1;
                end while(vif.write_driver.wfull);
                vif.write_driver.wr_en <= 1'b0;
            end
            write_control_port.write(req);
            seq_item_port.item_done();
        end
    endtask
endclass