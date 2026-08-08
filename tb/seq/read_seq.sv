class read_seq extends uvm_sequence #(read_txn);
    `uvm_object_utils(read_seq)
    read_txn req;
    rand int unsigned num_txn;
    constraint txn_per_seq { num_txn >= 20; num_txn < 50; }

    function new(string name = "read_seq");
        super.new(name);
    endfunction

    task body();
        for(int i = 0; i<num_txn; i++) begin
            `uvm_info(get_type_name(), $sformatf("[iteration:%0d/%0d] Inside Body of read_seq", i, num_txn), UVM_LOW)   
            req = read_txn::type_id::create("req");
            wait_for_grant();
            assert(req.randomize());
            send_request(req);
            wait_for_item_done();
        end
    endtask
endclass