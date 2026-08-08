class write_txn_data#(int DATA_WIDTH = 8) extends uvm_sequence_item;
    `uvm_object_param_utils(write_txn_data#(DATA_WIDTH))
    logic [DATA_WIDTH-1:0]  write_data_in;

    function new(string name = "write_txn_data");
        super.new(name);
    endfunction
endclass