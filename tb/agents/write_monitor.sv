class write_monitor#(int DATA_WIDTH = 8) extends uvm_monitor;
    `uvm_component_param_utils(write_monitor#(DATA_WIDTH))

    virtual write_if #(DATA_WIDTH) vif;
    uvm_analysis_port #(write_txn_data#(DATA_WIDTH)) write_port;
    write_txn_data #(DATA_WIDTH) write_data_item;

    function new (string name = "write_monitor", uvm_component parent = null);
        super.new(name, parent);
        write_port = new("write_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual write_if#(DATA_WIDTH))::get(this, "", "write_if", vif))
            `uvm_fatal(get_type_name(), "Failed to get the virtual interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(vif.write_fifo_dut);
            if(vif.write_fifo_dut.wr_en && !vif.write_fifo_dut.wfull) begin
                write_data_item = write_txn_data#(DATA_WIDTH)::type_id::create("write_data_item");
                write_data_item.write_data_in = vif.write_fifo_dut.wdata;
                write_port.write(write_data_item);
            end
        end
    endtask
endclass