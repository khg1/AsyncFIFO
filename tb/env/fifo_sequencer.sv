class fifo_sequencer #(int DATA_WIDTH = 8) extends uvm_sequencer;
    `uvm_component_param_utils(fifo_sequencer #(DATA_WIDTH))
    
    read_sequencer #(DATA_WIDTH) read_seqr;
    write_sequencer #(DATA_WIDTH) write_seqr;

    function void new(string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass