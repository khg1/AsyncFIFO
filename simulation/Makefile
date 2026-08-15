TB_TOP = ../tb/tb_top.sv
RTL_FILES = ../rtl/async_fifo.sv \
            ../rtl/dual_RAM.sv \
            ../rtl/read_handler.sv \
            ../rtl/write_handler.sv
PKG_FILES = ../tb/fifo_pkg.sv
INTERFACE_FILES = ../tb/interfaces/read_if.sv \
				  ../tb/interfaces/write_if.sv
SVA_FILES = ../tb/async_fifo_sva.sv \
            ../tb/async_fifo_cov.sv

VCS_CMD = vcs -sverilog -full64
UVM_FLAGS = -ntb_opts uvm-1.2
DEBUG_FLAGS = -kdb -debug_access+all
TIMESCALE = -timescale=1ns/1ps
CM_METRICS = line+cond+fsm+tgl+branch+assert

URG = /eda/synopsys/vcs/Y-2026.03/bin/urg

TEST_NAME = base_test

NUM_SEEDS ?= 50

all: clean compile run

compile:
	@echo "Compiling with VCS"
	$(VCS_CMD) $(UVM_FLAGS) $(DEBUG_FLAGS) $(TIMESCALE) \
		$(RTL_FILES) $(INTERFACE_FILES) $(SVA_FILES) \
		$(PKG_FILES) $(TB_TOP) \
		-l compile.log -cm $(CM_METRICS)

run: compile
	@echo "Running simulation"
	./simv +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=UVM_LOW \
		-l sim.log +fsdb+autoflush -cm $(CM_METRICS)

clean:
	rm -rf *.daidir *.log verdi_config_file *.h *.key simv csrc *.fsdb *.rc *.conf verdiLog coverage_report inter.* .Makefile.swp .inter.* simv.* seed_log .fsm.*

regress: compile
	@mkdir -p seed_log
	@echo "RUNNING REGRESSION: $(NUM_SEEDS) seeds"
	@for s in $$(seq 1 $(NUM_SEEDS)); do \
		echo "---- seed $$s ----"; \
		./simv +UVM_TESTNAME=$(TEST_NAME) +UVM_VERBOSITY=UVM_LOW \
			+ntb_random_seed=$$s -l seed_log/$(TEST_NAME)_seed$$s.log \
			-cm $(CM_METRICS) -cm_name $(TEST_NAME)_seed$$s || exit 1; \
		if grep -Eq "UVM_ERROR *: *0" seed_log/$(TEST_NAME)_seed$$s.log && grep -Eq "UVM_FATAL *: *0" seed_log/$(TEST_NAME)_seed$$s.log; then \
			echo "seed $$s PASS"; \
		else \
			echo "seed $$s FAIL — see seed_log/$(TEST_NAME)_seed$$s.log"; exit 1; \
		fi; \
	done

verdi:
	verdi -ssf waves.fsdb -cov -covdir simv.vdb &

cov_report:
	@echo "GENERATING COVERAGE REPORT (urg)"
	$(URG) -dir simv.vdb -report coverage_report -format text
	@echo "Open coverage_report/dashboard.txt for the summary"
	cat coverage_report/dashboard.txt
