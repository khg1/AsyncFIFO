class read_seq #(int DATA_WIDTH = 8) extends uvm_sequence #(read_txn#(DATA_WIDTH));
    `uvm_object_param_utils(read_seq #(DATA_WIDTH))
    read_txn #(DATA_WIDTH) req;
    rand int unsigned num_txn;
    constraint txn_per_seq { num_txn >= 20; num_txn < 50};

    function void new(string name = "read_seq");
        super.new(name);
    endfunction

    task body();
        for(int i = 0; i<num_txn; i++) begin
            `uvm_info(get_type_name(), $sformatf("[num_txn:%0d]Inside Body of read_seq", i), uvm_low);
            req = write_txn::type_id::create("req");
            wait_for_grant();
            assert(req.randomize());
            send_request(req);
            wait_for_item_done();
        end
    endtask
endclass