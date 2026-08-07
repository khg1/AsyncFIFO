class base_test#(int DATA_WIDTH = 8) extends uvm_test;
    `uvm_component_param_utils(base_test#(DATA_WIDTH))
    env#(DATA_WIDTH) test_env;
    fifo_virtual_seq#(DATA_WIDTH) v_seq;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        test_env = env#(DATA_WIDTH)::type_id::create("test_env", this);
    endfunction

    function void run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        v_seq = fifo_virtual_seq#(DATA_WIDTH)::type_id::create("v_seq");
        v_seq.start(test_env.v_seqr);
        phase.drop_objection(this);
    endfunction

endclass