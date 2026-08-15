# AsyncFIFO

A parameterizable asynchronous (dual-clock) FIFO in SystemVerilog, with Gray-code
pointer synchronization for safe clock-domain crossing, and a UVM testbench with
functional coverage and SVA-based protocol/CDC checks.

## RTL

| Module | File | Description |
|---|---|---|
| `async_fifo` | [rtl/async_fifo.sv](rtl/async_fifo.sv) | Top level. Instantiates the dual-port RAM, write/read handlers, and the two-flop synchronizers that cross each Gray-coded pointer into the other clock domain. |
| `write_handler` | [rtl/write_handler.sv](rtl/write_handler.sv) | Write-domain pointer logic. Converts the binary write pointer to Gray code and compares it against the synchronized read pointer to generate `wfull`. |
| `read_handler` | [rtl/read_handler.sv](rtl/read_handler.sv) | Read-domain pointer logic. Converts the binary read pointer to Gray code and compares it against the synchronized write pointer to generate `rempty`. |
| `dual_RAM` | [rtl/dual_RAM.sv](rtl/dual_RAM.sv) | Dual-port memory array, written on `wclk` and read on `rclk` using the binary pointers. |

Parameters (on `async_fifo`):
- `DATA_WIDTH` — width of each entry (default 8)
- `ADDR_WIDTH` — address width; FIFO depth is `2**ADDR_WIDTH` (default 4, i.e. depth 16)

Ports are split into a write domain (`wclk`/`wrst_n`/`wr_en`/`write_data`/`wfull`)
and a read domain (`rclk`/`rrst_n`/`rd_en`/`rdata`/`rempty`), each with its own
active-low reset.

## Verification

The testbench (`tb/`) is a UVM environment with independent read and write agents:

- **Agents** ([tb/agents/](tb/agents/)) — driver/monitor/sequencer per clock domain
  (`read_agent`/`write_agent`), driving `read_if`/`write_if` ([tb/interfaces/](tb/interfaces/)).
- **Env** ([tb/env/env.sv](tb/env/env.sv)) — wires the agents to a `scoreboard`
  (checks read data against expected write data) and a `coverage` component fed
  from driver control ports.
- **Sequences** ([tb/seq/](tb/seq/)) — reusable read/write transaction sequences,
  plus occupancy-focused sequences (`occ_read_seq`, `occ_write_seq`,
  `occ_virtual_seq`) used to stress `wfull`/`rempty` corners.
- **Tests** ([tb/test/](tb/test/)) — `base_test` runs the default virtual sequence;
  `occupancy_test` runs the occupancy virtual sequence.
- **SVA** ([tb/async_fifo_sva.sv](tb/async_fifo_sva.sv)) — assertions bound into
  the DUT checking pointer/flag protocol and CDC behavior.
- **Coverage** ([tb/async_fifo_cov.sv](tb/async_fifo_cov.sv),
  [tb/async_fifo_cov.sv](tb/async_fifo_cov.sv)) — covergroups bound into the DUT
  for pointer, full/empty, and toggle coverage.

`tb/tb_top.sv` generates independent write/read clocks and resets, binds the SVA
and coverage modules into the DUT, and starts `run_test()`.

## Running simulations

Simulation is driven by [simulation/Makefile](simulation/Makefile) using Synopsys
VCS (UVM 1.2) and `urg` for coverage reports.

```sh
cd simulation

make compile              # compile RTL + TB with VCS
make run                  # compile, then run UVM_TESTNAME=base_test
make run TEST_NAME=occupancy_test   # run a specific test

make regress              # run NUM_SEEDS (default 50) random seeds, stop on first failure
make regress NUM_SEEDS=10

make cov_report           # generate a urg text coverage report and print the dashboard
make verdi                # open Verdi with waves + coverage
make clean                # remove simulation build artifacts
```

Waveforms are dumped to `waves.fsdb`; coverage metrics collected are
`line+cond+fsm+tgl+branch+assert`.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
