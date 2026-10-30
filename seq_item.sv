class pkt_seq_item extends uvm_sequence_item;
  `uvm_object_utils(pkt_seq_item)

  rand bit        pkt_write;
  rand bit [15:0] pkt_addr;
  rand bit [31:0] pkt_data;

       bit [31:0] pkt_rdata;
       bit        pkt_slverr;

  function new(string pkt_name="pkt_seq_item");
    super.new(pkt_name);
  endfunction

endclass