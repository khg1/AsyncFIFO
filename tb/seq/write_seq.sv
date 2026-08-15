class write_seq #(int DATA_WIDTH = 8) extends uvm_sequence #(write_txn#(DATA_WIDTH));
    `uvm_object_param_utils(write_seq #(DATA_WIDTH))
    write_txn #(DATA_WIDTH) req;
    semaphore write_credits;
    uvm_event write_done;
    rand int unsigned num_txn;
    constraint txn_per_seq { num_txn >= 20; num_txn < 50; }

    function new(string name = "write_seq");
        super.new(name);
    endfunction

    task body();
        a_write_seq_ok: assert(this.randomize());
        for(int i = 0; i<num_txn; i++) begin
            `uvm_info(get_type_name(), $sformatf("[iteration:%0d/%0d] Inside Body of write_seq", i, num_txn), UVM_LOW)   
            req = write_txn#(DATA_WIDTH)::type_id::create("req");
            wait_for_grant();
            a_write_item_ok: assert(req.randomize());
            send_request(req);
            wait_for_item_done();
            `uvm_info(get_type_name(), "Putting the key from the write operation!!!!!!!!", UVM_DEBUG)
            if(req.do_write)    write_credits.put(1);
        end
        write_done.trigger();
    endtask
endclass