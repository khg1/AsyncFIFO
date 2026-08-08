class env#(int DATA_WIDTH = 8, int ADDR_WIDTH = 4) extends uvm_env;
    `uvm_component_param_utils(env#(DATA_WIDTH))

    read_agent#(DATA_WIDTH) r_agent;
    write_agent#(DATA_WIDTH) w_agent;
    fifo_sequencer#(DATA_WIDTH) v_seqr;
    scoreboard#(DATA_WIDTH) scrb;
    
    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        r_agent = read_agent#(DATA_WIDTH)::type_id::create("r_agent", this);
        w_agent = write_agent#(DATA_WIDTH)::type_id::create("w_agent", this);
        v_seqr = fifo_sequencer#(DATA_WIDTH)::type_id::create("v_seqr", this);
        scrb = scoreboard#(DATA_WIDTH)::type_id::create("scrb", this); 
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        v_seqr.read_seqr = r_agent.r_sequencer;
        v_seqr.write_seqr = w_agent.w_sequencer;
        r_agent.r_monitor.read_port.connect(scrb.read_reqs_buff.analysis_export);
        w_agent.w_monitor.write_port.connect(scrb.write_reqs_buff.analysis_export);
    endfunction

endclass