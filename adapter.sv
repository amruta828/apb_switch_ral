class pkt_adapter extends uvm_reg_adapter;
  `uvm_object_utils(pkt_adapter)

  function new(string name="pkt_adapter");
    super.new(name);
    supports_byte_enable = 0;
    provides_responses   = 0;
  endfunction

  virtual function uvm_sequence_item reg2bus(
    const ref uvm_reg_bus_op rw
  );
    pkt_seq_item tr;

    tr = pkt_seq_item::type_id::create("tr");
    tr.write = (rw.kind == UVM_WRITE);
    tr.addr  = rw.addr[15:0];
    tr.data  = rw.data;

    return tr;
  endfunction

  virtual function void bus2reg(
    uvm_sequence_item bus_item,
    ref uvm_reg_bus_op rw
  );
    pkt_seq_item tr;

    if (!$cast(tr,bus_item))
      `uvm_fatal("BAD_APB_ITEM","Expected pkt_seq_item")

    rw.kind   = tr.write ? UVM_WRITE : UVM_READ;
    rw.addr   = tr.addr;
    rw.data   = tr.write ? tr.data : tr.rdata;
    rw.status = tr.slverr ? UVM_NOT_OK : UVM_IS_OK;
  endfunction
endclass