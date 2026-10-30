class pkt_sequencer extends uvm_sequencer #(pkt_seq_item);
  `uvm_component_utils(pkt_sequencer)

  function new(string pkt_name, uvm_component pkt_parent);
    super.new(pkt_name,pkt_parent);
  endfunction
endclass