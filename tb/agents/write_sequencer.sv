class write_sequencer #(int DATA_WIDTH = 8) extends uvm_sequencer #(write_txn#(DATA_WIDTH));
    `uvm_component_param_utils(write_sequencer #(DATA_WIDTH))
    function void new(string name = "write_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass