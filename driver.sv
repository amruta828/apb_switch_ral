class pkt_driver extends uvm_driver #(pkt_seq_item);
  `uvm_component_utils(pkt_driver)

  virtual pkt_interface pkt_vif;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual pkt_interface)::get(
          this,"","vif",pkt_vif))
      `uvm_fatal("NO_VIF","APB virtual interface not configured")
  endfunction

  task run_phase(uvm_phase phase);
    pkt_seq_item pkt_req;

    pkt_vif.driver_cb.psel    <= 0;
    pkt_vif.driver_cb.penable <= 0;
    pkt_vif.driver_cb.pwrite  <= 0;
    pkt_vif.driver_cb.paddr   <= 0;
    pkt_vif.driver_cb.pwdata  <= 0;

    repeat(3)@(pkt_vif.driver_cb);
    forever begin
      seq_item_port.get_next_item(pkt_req);
      drive_transfer(pkt_req);
      seq_item_port.item_done();
    end
  endtask

  task drive_transfer(pkt_seq_item pkt_trans);
    //@(pkt_vif.driver_cb);
   // wait(pkt_vif.presetn === 1'b1);

    // apb setup
    pkt_vif.driver_cb.psel    <= 1;
    pkt_vif.driver_cb.penable <= 0;
    pkt_vif.driver_cb.pwrite  <= pkt_trans.write;
    pkt_vif.driver_cb.paddr   <= pkt_trans.addr;
    pkt_vif.driver_cb.pwdata  <= pkt_trans.data;

    // apb access
    @(pkt_vif.driver_cb);
    pkt_vif.driver_cb.penable <= 1;

//     do @(pkt_vif.driver_cb);
//     while (pkt_vif.driver_cb.pready !== 1'b1);
    wait(pkt_vif.driver_cb.pready);

    pkt_trans.rdata  = pkt_vif.driver_cb.prdata;
    pkt_trans.slverr = pkt_vif.driver_cb.pslverr;

    @(pkt_vif.driver_cb);
    pkt_vif.driver_cb.psel    <= 0;
    pkt_vif.driver_cb.penable <= 0;
    pkt_vif.driver_cb.pwrite  <= 0;

    @(pkt_vif.driver_cb);
  endtask
endclass