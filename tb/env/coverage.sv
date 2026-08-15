`uvm_analysis_imp_decl(_wctrl)
`uvm_analysis_imp_decl(_rctrl)

class coverage#(int DATA_WIDTH=8) extends uvm_component;
    `uvm_component_param_utils(coverage#(DATA_WIDTH))

    uvm_analysis_imp_wctrl#(write_txn#(DATA_WIDTH), coverage#(DATA_WIDTH))   write_control_imp;
    uvm_analysis_imp_rctrl#(read_txn, coverage#(DATA_WIDTH)) read_control_imp;

    write_txn#(DATA_WIDTH) w_ctrl;
    read_txn r_ctrl;
    write_txn_data#(DATA_WIDTH) w_data;
    read_txn_data#(DATA_WIDTH) r_data;


    virtual function void write_wctrl(write_txn#(DATA_WIDTH) t);
        w_ctrl = t;
        write.sample();
    endfunction

    virtual function void write_rctrl(read_txn t);
        r_ctrl = t;
        read.sample();
    endfunction

    function new(string name = "coverage", uvm_component parent = null);
        super.new(name,parent);
        write = new();
        read = new();
        write_control_imp = new("write_control_imp", this);
        read_control_imp = new("read_control_imp", this);
    endfunction

    covergroup  write;
        cp_write_enable: coverpoint w_ctrl.do_write{
            bins wr_en_0 = {0};
            bins wr_en_1 = {1};
        }
        cp_w_delay: coverpoint w_ctrl.pre_delay{
            bins b1[] = {0, 1, 2, 3};
        }
        cp_full_status: coverpoint w_ctrl.was_full{
            bins isfull = {1};
            bins isnotfull = {0};
        }
        cross_wrenxwfull: cross cp_write_enable, cp_full_status;
    endgroup

    covergroup  read;
        cp_read_enable: coverpoint r_ctrl.do_read{
            bins rd_en_0 = {0};
            bins rd_en_1 = {1};
        }
        cp_r_delay: coverpoint r_ctrl.pre_delay{
            bins b1[] = {0, 1, 2, 3};
        }
        cp_empty_status: coverpoint r_ctrl.was_empty{
            bins isempty = {1};
            bins isnotempty = {0};
        }
        cross_rdenxrempty: cross cp_read_enable, cp_empty_status;
    endgroup

endclass