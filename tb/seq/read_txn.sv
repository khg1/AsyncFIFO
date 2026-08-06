class read_txn extends uvm_sequence_item;
    `uvm_object_param_utils(read_txn #(DATA_WIDTH))

    rand int unsigned pre_delay;
    rand bit          do_read;

    constraint timing { pre_delay < 4 };

    function void new(string name = "read_txn");
        super.new(name);
    endfunction
endclass