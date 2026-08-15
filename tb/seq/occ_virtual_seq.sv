class occ_virtual_seq #(int DATA_WIDTH = 8) extends uvm_sequence;
    `uvm_object_param_utils(occ_virtual_seq #(DATA_WIDTH))

    occ_read_seq#(DATA_WIDTH)  read_sequence;
    occ_write_seq#(DATA_WIDTH) write_sequence;

    read_sequencer  read_seqr;
    write_sequencer #(DATA_WIDTH) write_seqr;

    `uvm_declare_p_sequencer(fifo_sequencer #(DATA_WIDTH))

    function new(string name = "fifo_virtual_seq");
        super.new(name);
    endfunction

    task body();
        read_sequence = occ_read_seq::type_id::create("read_sequence");
        write_sequence = occ_write_seq #(DATA_WIDTH)::type_id::create("write_sequence");
        read_sequence.write_credits = p_sequencer.shared_shem;
        write_sequence.write_credits = p_sequencer.shared_shem;
        read_sequence.write_done = p_sequencer.write_done;
        write_sequence.write_done = p_sequencer.write_done;
        fork
            write_sequence.start(p_sequencer.write_seqr);
            read_sequence.start(p_sequencer.read_seqr);
        join
    endtask

endclass