interface pkt_interface(input logic pclk);

  logic        pkt_presetn;
  logic        pkt_psel;
  logic        pkt_penable;
  logic        pkt_pwrite;
  logic [15:0] pkt_paddr;
  logic [31:0] pkt_pwdata;
  logic [31:0] pkt_prdata;
  logic        pkt_pready;
  logic        pkt_pslverr;
  logic        pkt_irq;

  clocking pkt_driver_cb @(posedge pclk);
    default input #1step output #0;
    output pkt_psel, pkt_penable, pkt_pwrite, pkt_paddr, pkt_pwdata;
    input pkt_presetn, pkt_prdata, pkt_pready, pkt_pslverr, pkt_irq;
  endclocking

  clocking pkt_monitor_cb @(posedge pclk);
    default input #1step output #0;
    input pkt_presetn, pkt_psel, pkt_penable, pkt_pwrite, pkt_paddr, pkt_pwdata;
    input pkt_prdata, pkt_pready, pkt_pslverr, pkt_irq;
  endclocking

endinterface