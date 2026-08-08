class read_agent#(int DATA_WIDTH = 8) extends uvm_agent;
    `uvm_component_param_utils(read_agent#(DATA_WIDTH))
    read_driver#(DATA_WIDTH) r_driver;
    read_monitor#(DATA_WIDTH) r_monitor;
    read_sequencer r_sequencer;

    function new(string name = "read_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        r_monitor = read_monitor#(DATA_WIDTH)::type_id::create("r_monitor", this);
        if(get_is_active() == UVM_ACTIVE) begin
            r_driver = read_driver#(DATA_WIDTH)::type_id::create("r_driver", this);
            r_sequencer = read_sequencer::type_id::create("r_sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            r_driver.seq_item_port.connect(r_sequencer.seq_item_export);
        end
    endfunction
endclass