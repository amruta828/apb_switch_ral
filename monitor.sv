class pkt_monitor extends uvm_component;
  `uvm_component_utils(pkt_monitor)

  virtual pkt_interface pkt_vif;
  uvm_analysis_port #(pkt_seq_item) pkt_ap;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    pkt_ap = new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual pkt_interface)::get(
          this,"","vif",pkt_vif))
      `uvm_fatal("NO_VIF","APB virtual interface not configured")
  endfunction

  task run_phase(uvm_phase phase);
    pkt_seq_item pkt_trans;
    repeat(4)@(pkt_vif.monitor_cb);
    forever 
      begin
        wait(pkt_vif.monitor_cb.psel &&pkt_vif.monitor_cb.penable &&pkt_vif.monitor_cb.pready)
        pkt_trans = pkt_seq_item::type_id::create("tr");
        pkt_trans.write  = pkt_vif.monitor_cb.pwrite;
        pkt_trans.addr   = pkt_vif.monitor_cb.paddr;
        pkt_trans.data   = pkt_vif.monitor_cb.pwdata;
        pkt_trans.rdata  = pkt_vif.monitor_cb.prdata;
        pkt_trans.slverr = pkt_vif.monitor_cb.pslverr;
        pkt_ap.write(pkt_trans);
        @(pkt_vif.monitor_cb);
    end
  endtask
endclass