class read_txn extends uvm_sequence_item;
    `uvm_object_utils(read_txn)

    rand int unsigned pre_delay;
    rand bit          do_read;

    constraint timing { pre_delay < 4; }

    function new(string name = "read_txn");
        super.new(name);
    endfunction
endclass