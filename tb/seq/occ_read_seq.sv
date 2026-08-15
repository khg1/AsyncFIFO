class occ_read_seq#(int DATA_WIDTH=8) extends uvm_sequence #(read_txn);
    `uvm_object_param_utils(occ_read_seq)
    read_txn req;
    semaphore write_credits;
    uvm_event write_done;
    rand int unsigned num_txn;
    constraint txn_per_seq { num_txn >= 20; num_txn < 50; }

    virtual write_if#(DATA_WIDTH) w_if;
    function new(string name = "read_seq");
        super.new(name);
    endfunction

    task body();
        if(!uvm_config_db#(virtual write_if#(DATA_WIDTH))::get(m_sequencer, "", "write_if", w_if))
            `uvm_fatal(get_type_name(), "Unable to get the write_if for read sequencer")
        wait(w_if.wfull);
        a_read_seq_ok: assert(this.randomize());
        forever begin
            req = read_txn::type_id::create("req");
            wait_for_grant();
            a_read_item_ok: assert(req.randomize() with {req.do_read==1; req.pre_delay==0;});
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
                    break;
                end
            end
            send_request(req);
            wait_for_item_done();
        end
    endtask
endclass