class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    env#(8) test_env;
    fifo_virtual_seq#(8) v_seq;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        test_env = env#(8)::type_id::create("test_env", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        v_seq = fifo_virtual_seq#(8)::type_id::create("v_seq");
        v_seq.start(test_env.v_seqr);
        phase.drop_objection(this);
    endtask

endclass