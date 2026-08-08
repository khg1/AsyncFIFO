TB_TOP = ../tb/tb_top.sv
RTL_FILES = ../rtl/async_fifo.sv \
            ../rtl/dual_RAM.sv \
            ../rtl/read_handler.sv \
            ../rtl/write_handler.sv
PKG_FILES = ../tb/fifo_pkg.sv
INTERFACE_FILES = ../tb/interfaces/read_if.sv \
				  ../tb/interfaces/write_if.sv
SVA_FILES = ../tb/async_fifo_sva.sv

VCS_CMD = vcs -sverilog -full64
UVM_FLAGS = -ntb_opts uvm-1.2
DEBUG_FLAGS = -kdb -debug_access+all
TIMESCALE = -timescale=1ns/1ps

TEST_NAME = base_test

compile:
	@echo "Compiling with VCS"
	$(VCS_CMD) $(UVM_FLAGS) $(DEBUG_FLAGS) $(TIMESCALE) \
		$(RTL_FILES) $(INTERFACE_FILES) $(SVA_FILES) \
		$(PKG_FILES) $(TB_TOP) \
		-l compile.log

run:
	@echo "Running simulation"
	./simv +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=UVM_LOW \
		-l sim.log +fsdb+autoflush
clean:
	rm -rf *.daidir *.log verdi_config_file
