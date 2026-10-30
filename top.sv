`include "uvm_macros.svh"
`include "interface.sv"
`include "registers.sv"
`include "reg_block.sv"
`include "seq_item.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "adapter.sv"
`include "subscriber.sv"
`include "env.sv"
`include "sequence.sv"
`include "test.sv"
`include "design.sv"

module tb;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  bit pkt_pclk = 0;
  always #5 pkt_pclk = ~pkt_pclk;

  pkt_interface pkt_apb_if(pkt_pclk);

  apb_pkt_switch pkt_dut (
    .pclk    (pkt_pclk),
    .presetn (pkt_apb_if.presetn),
    .psel    (pkt_apb_if.psel),
    .penable (pkt_apb_if.penable),
    .pwrite  (pkt_apb_if.pwrite),
    .paddr   (pkt_apb_if.paddr),
    .pwdata  (pkt_apb_if.pwdata),
    .prdata  (pkt_apb_if.prdata),
    .pready  (pkt_apb_if.pready),
    .pslverr (pkt_apb_if.pslverr),
    .irq     (pkt_apb_if.irq)
  );

  initial begin
    pkt_apb_if.presetn = 1'b0;
    pkt_apb_if.psel    = 1'b0;
    pkt_apb_if.penable = 1'b0;
    pkt_apb_if.pwrite  = 1'b0;
    pkt_apb_if.paddr   = '0;
    pkt_apb_if.pwdata  = '0;

    repeat (2) @(posedge pkt_pclk);
    pkt_apb_if.presetn = 1'b1;
  end

  initial begin
    uvm_config_db#(virtual pkt_interface)::set(
      null,
      "uvm_test_top.env.agent.*",
      "vif",
      pkt_apb_if
    );

    run_test("pkt_regression_test");
  end

endmodule