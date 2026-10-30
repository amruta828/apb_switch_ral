class pkt_agent extends uvm_agent;
  `uvm_component_utils(pkt_agent)

  pkt_sequencer pkt_sequencer_h;
  pkt_driver    pkt_driver_h;
  pkt_monitor   pkt_monitor_h;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    pkt_monitor_h = pkt_monitor::type_id::create("monitor",this);

    if (get_is_active() == UVM_ACTIVE) begin
      pkt_sequencer_h = pkt_sequencer::type_id::create("sequencer",this);
      pkt_driver_h    = pkt_driver::type_id::create("driver",this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (get_is_active() == UVM_ACTIVE)
      pkt_driver_h.seq_item_port.connect(pkt_sequencer_h.seq_item_export);
  endfunction
endclass