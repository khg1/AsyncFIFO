class write_driver #(int DATA_WIDTH = 8) extends uvm_driver #(write_txn#(DATA_WIDTH));
    `uvm_component_param_utils(write_driver #(DATA_WIDTH))

    virtual write_if #(DATA_WIDTH) vif;

    function new(string name = "write_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual write_if#(DATA_WIDTH))::get(this, "", "write_if", vif))
            `uvm_fatal(get_type_name(), "error extracting vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        write_txn #(DATA_WIDTH) req;
        forever begin
            seq_item_port.get_next_item(req);
            vif.write_driver.wr_en <= 1'b0;
            repeat(req.pre_delay)   @(vif.write_driver);
            if(req.do_write) begin
                vif.write_driver.wr_en <= 1'b1;
                vif.write_driver.wdata <= req.wdata;
                do @(vif.write_driver);
                while(vif.write_driver.wfull);
                vif.write_driver.wr_en <= 1'b0;
            end
            seq_item_port.item_done();
        end
    endtask
endclass