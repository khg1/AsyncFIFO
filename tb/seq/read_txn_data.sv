class read_txn_data#(int DATA_WIDTH = 8) extends uvm_sequence_item;
    `uvm_object_param_utils(read_txn_data#(DATA_WIDTH))
    logic [DATA_WIDTH-1:0]  read_data_out;
    function void new(string name = "read_txn_data");
        super.new(name);
    endfunction
endclass