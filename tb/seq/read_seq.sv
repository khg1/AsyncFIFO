class read_seq extends uvm_sequence #(read_txn);
    `uvm_object_utils(read_seq)
    read_txn req;
    semaphore write_credits;
    uvm_event write_done;
    rand int unsigned num_txn;
    constraint txn_per_seq { num_txn >= 20; num_txn < 50; }

    function new(string name = "read_seq");
        super.new(name);
    endfunction

    task body();
        assert(this.randomize());
        for(int i = 0; i<num_txn; i++) begin
            `uvm_info(get_type_name(), $sformatf("[iteration:%0d/%0d] Inside Body of read_seq", i, num_txn), UVM_LOW)   
            req = read_txn::type_id::create("req");
            wait_for_grant();
            assert(req.randomize());
            `uvm_info(get_type_name(), "Trying to get the key for read", UVM_DEBUG)
            if(req.do_read) begin
                bit got_credit = 0;
                fork 
                    begin
                        write_credits.get(1);
                        `uvm_info(get_type_name(), "Successfully got the key for read", UVM_DEBUG)
                        got_credit = 1;
                    end
                    write_done.wait_on();
                join_any
                disable fork;
                if(!got_credit) begin
                    `uvm_info(get_type_name(), $sformatf("Completed reading of %0d txn from total %0d before breaking.", i, num_txn), UVM_LOW)
                    break;
                end
            end
            send_request(req);
            wait_for_item_done();
        end
    endtask
endclass