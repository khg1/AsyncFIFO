class read_monitor#(int DATA_WIDTH = 8) extends uvm_monitor;
    `uvm_component_param_utils(read_monitor#(DATA_WIDTH))

    virtual read_if#(DATA_WIDTH) vif;  
    uvm_analysis_port #(read_txn_data#(DATA_WIDTH)) read_port;      
    read_txn_data#(DATA_WIDTH)  read_data_item;

    function new(string name = "read_monitor", uvm_component parent = null);
        super.new(name, parent);
        read_port = new("read_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual read_if#(DATA_WIDTH))::get(this, "", "read_if", vif))
            `uvm_fatal(get_type_name(), "Not set at top level")
    endfunction

    virtual task run_phase(uvm_phase phase);
        bit accept = 0;
        forever begin
            @(vif.read_fifo_dut);
            if(accept)  begin
                read_data_item = read_txn_data#(DATA_WIDTH)::type_id::create("read_data_item");
                read_data_item.read_data_out = vif.read_fifo_dut.rdata;
                read_port.write(read_data_item);
            end
            accept = vif.read_fifo_dut.rd_en && !vif.read_fifo_dut.rempty;
        end
    endtask
endclass