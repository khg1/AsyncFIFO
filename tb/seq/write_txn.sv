class write_txn #(int DATA_WIDTH = 8) extends uvm_sequence_item;
    `uvm_object_param_utils(write_txn #(DATA_WIDTH))

    rand int unsigned           pre_delay;
    rand bit                    do_write;
    rand logic[DATA_WIDTH-1:0]  wdata;

    constraint timing { pre_delay < 4 };

    function void new(string name = "write_txn");
        super.new(name);
    endfunction
endclass