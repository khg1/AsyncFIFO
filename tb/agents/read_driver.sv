class read_driver #(int DATA_WIDTH = 8) extends uvm_driver #(read_txn#(DATA_WIDTH));
    `uvm_component_param_utils(read_driver#(DATA_WIDTH))
    virtual read_if #(DATA_WIDTH)   vif;

    function new(string name = "read_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual read_if#(DATA_WIDTH))::get(this, "", "read_if", vif))
            `uvm_fatal(get_type_name(), "error extracting vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        read_txn#(DATA_WIDTH) req;
        forever begin
            seq_item_port.get_next_item(req);
            vif.read_driver.rd_en <= 1'b0;
            repeat(req.pre_delay)   @(vif.read_driver);
            if(req.do_read) begin
                vif.read_driver.rd_en <= 1'b1;
                do  @(vif.read_driver);
                while(vif.read_driver.rempty);
                vif.read_driver.rd_en <= 1'b0;
            end
            seq_item_port.item_done();
        end
    endtask
endclass