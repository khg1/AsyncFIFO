class read_sequencer #(int DATA_WIDTH = 8) extends uvm_sequencer #(read_txn#(DATA_WIDTH));
    `uvm_component_param_utils(read_sequencer #(DATA_WIDTH))
    function void new(string name = "read_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass