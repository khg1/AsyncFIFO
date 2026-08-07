class write_agent#(int DATA_WIDTH = 8) extends uvm_agent;
    `uvm_component_param_utils(write_agent#(DATA_WIDTH))
    write_driver#(DATA_WIDTH) w_driver;
    write_monitor#(DATA_WIDTH) w_monitor;
    write_sequencer#(DATA_WIDTH) w_sequencer;

    function new(string name = "write_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        w_monitor = write_monitor#(DATA_WIDTH)::type_id::create("w_monitor", this);
        if(get_is_active() == UVM_ACTIVE) begin
            w_driver = write_driver#(DATA_WIDTH)::type_id::create("w_driver", this);
            w_sequencer = write_sequencer#(DATA_WIDTH)::type_id::create("w_sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            w_driver.seq_item_port.connect(w_sequencer.seq_item_export);
        end
    endfunction
endclass