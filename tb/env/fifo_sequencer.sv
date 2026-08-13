class fifo_sequencer #(int DATA_WIDTH = 8) extends uvm_sequencer;
    `uvm_component_param_utils(fifo_sequencer #(DATA_WIDTH))
    
    read_sequencer read_seqr;
    write_sequencer #(DATA_WIDTH) write_seqr;

    semaphore shared_shem;
    uvm_event write_done;

    function new(string name = "fifo_sequencer", uvm_component parent = null);
        super.new(name, parent);
        shared_shem = new(0);
        write_done = new("write_done");
    endfunction

endclass