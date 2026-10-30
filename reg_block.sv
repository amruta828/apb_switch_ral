class pkt_reg_block extends uvm_reg_block;
  `uvm_object_utils(pkt_reg_block)

  rand device_id_reg     pkt_device_id;
  rand version_reg       pkt_version;
  rand switch_status_reg pkt_switch_status;
  rand port_status_reg   pkt_port_status;
  rand gen_status_reg    pkt_gen_status;
  rand stat_rx_reg       pkt_stat_rx;
  rand stat_tx_reg       pkt_stat_tx;
  rand stat_drop_reg     pkt_stat_drop;
  rand switch_ctrl_reg   pkt_switch_ctrl;
  rand port_enable_reg   pkt_port_enable;
  rand fwd_enable_reg    pkt_fwd_enable;
  rand gen_ctrl_reg      pkt_gen_ctrl;
  rand gen_pkt_cfg_reg   pkt_gen_pkt_cfg;
  rand gen_interval_reg  pkt_gen_interval;
  rand gen_count_reg     pkt_gen_count;
  rand irq_status_reg    pkt_irq_status;
  rand irq_enable_reg    pkt_irq_enable;
  rand irq_force_reg     pkt_irq_force;
  rand err_status_reg    pkt_err_status;
  rand err_enable_reg    pkt_err_enable;
  rand err_inject_reg    pkt_err_inject;
  rand err_count_reg     pkt_err_count;
  rand err_info_reg      pkt_err_info;
  rand lock_reg          pkt_lock;
  rand soft_reset_reg    pkt_soft_reset;

  uvm_reg_map pkt_apb_map;

  function new(string name = "pkt_reg_block");
    super.new(name, UVM_CVR_FIELD_VALS);
  endfunction

  virtual function void build();

    pkt_apb_map = create_map("apb_map", 'h0, 4, UVM_LITTLE_ENDIAN, 0);

    pkt_device_id = device_id_reg::type_id::create("device_id");
    pkt_device_id.configure(this, null, "");
    pkt_device_id.build();
    pkt_device_id.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_device_id, 'h00, "RO");

    pkt_version = version_reg::type_id::create("version");
    pkt_version.configure(this, null, "");
    pkt_version.build();
    pkt_version.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_version, 'h04, "RO");

    pkt_switch_status = switch_status_reg::type_id::create("switch_status");
    pkt_switch_status.configure(this, null, "");
    pkt_switch_status.build();
    pkt_switch_status.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_switch_status, 'h08, "RO");

    pkt_port_status = port_status_reg::type_id::create("port_status");
    pkt_port_status.configure(this, null, "");
    pkt_port_status.build();
    pkt_port_status.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_port_status, 'h0C, "RO");

    pkt_gen_status = gen_status_reg::type_id::create("gen_status");
    pkt_gen_status.configure(this, null, "");
    pkt_gen_status.build();
    pkt_gen_status.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_gen_status, 'h10, "RO");

    pkt_stat_rx = stat_rx_reg::type_id::create("stat_rx");
    pkt_stat_rx.configure(this, null, "");
    pkt_stat_rx.build();
    pkt_stat_rx.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_stat_rx, 'h14, "RO");

    pkt_stat_tx = stat_tx_reg::type_id::create("stat_tx");
    pkt_stat_tx.configure(this, null, "");
    pkt_stat_tx.build();
    pkt_stat_tx.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_stat_tx, 'h18, "RO");

    pkt_stat_drop = stat_drop_reg::type_id::create("stat_drop");
    pkt_stat_drop.configure(this, null, "");
    pkt_stat_drop.build();
    pkt_stat_drop.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_stat_drop, 'h1C, "RO");

    pkt_switch_ctrl = switch_ctrl_reg::type_id::create("switch_ctrl");
    pkt_switch_ctrl.configure(this, null, "");
    pkt_switch_ctrl.build();
    pkt_switch_ctrl.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_switch_ctrl, 'h20, "RW");

    pkt_port_enable = port_enable_reg::type_id::create("port_enable");
    pkt_port_enable.configure(this, null, "");
    pkt_port_enable.build();
    pkt_port_enable.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_port_enable, 'h24, "RW");

    pkt_fwd_enable = fwd_enable_reg::type_id::create("fwd_enable");
    pkt_fwd_enable.configure(this, null, "");
    pkt_fwd_enable.build();
    pkt_fwd_enable.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_fwd_enable, 'h28, "RW");

    pkt_gen_ctrl = gen_ctrl_reg::type_id::create("gen_ctrl");
    pkt_gen_ctrl.configure(this, null, "");
    pkt_gen_ctrl.build();
    pkt_gen_ctrl.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_gen_ctrl, 'h2C, "RW");

    pkt_gen_pkt_cfg = gen_pkt_cfg_reg::type_id::create("gen_pkt_cfg");
    pkt_gen_pkt_cfg.configure(this, null, "");
    pkt_gen_pkt_cfg.build();
    pkt_gen_pkt_cfg.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_gen_pkt_cfg, 'h30, "RW");

    pkt_gen_interval = gen_interval_reg::type_id::create("gen_interval");
    pkt_gen_interval.configure(this, null, "");
    pkt_gen_interval.build();
    pkt_gen_interval.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_gen_interval, 'h34, "RW");

    pkt_gen_count = gen_count_reg::type_id::create("gen_count");
    pkt_gen_count.configure(this, null, "");
    pkt_gen_count.build();
    pkt_gen_count.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_gen_count, 'h38, "RW");

    pkt_irq_status = irq_status_reg::type_id::create("irq_status");
    pkt_irq_status.configure(this, null, "");
    pkt_irq_status.build();
    pkt_irq_status.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_irq_status, 'h3C, "RW");

    pkt_irq_enable = irq_enable_reg::type_id::create("irq_enable");
    pkt_irq_enable.configure(this, null, "");
    pkt_irq_enable.build();
    pkt_irq_enable.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_irq_enable, 'h40, "RW");

    pkt_irq_force = irq_force_reg::type_id::create("irq_force");
    pkt_irq_force.configure(this, null, "");
    pkt_irq_force.build();
    pkt_irq_force.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_irq_force, 'h44, "WO");

    pkt_err_status = err_status_reg::type_id::create("err_status");
    pkt_err_status.configure(this, null, "");
    pkt_err_status.build();
    pkt_err_status.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_err_status, 'h48, "RW");

    pkt_err_enable = err_enable_reg::type_id::create("err_enable");
    pkt_err_enable.configure(this, null, "");
    pkt_err_enable.build();
    pkt_err_enable.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_err_enable, 'h4C, "RW");

    pkt_err_inject = err_inject_reg::type_id::create("err_inject");
    pkt_err_inject.configure(this, null, "");
    pkt_err_inject.build();
    pkt_err_inject.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_err_inject, 'h50, "WO");

    pkt_err_count = err_count_reg::type_id::create("err_count");
    pkt_err_count.configure(this, null, "");
    pkt_err_count.build();
    pkt_err_count.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_err_count, 'h54, "RO");

    pkt_err_info = err_info_reg::type_id::create("err_info");
    pkt_err_info.configure(this, null, "");
    pkt_err_info.build();
    pkt_err_info.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_err_info, 'h58, "RO");

    pkt_lock = lock_reg::type_id::create("lock");
    pkt_lock.configure(this, null, "");
    pkt_lock.build();
    pkt_lock.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_lock, 'h5C, "RW");

    pkt_soft_reset = soft_reset_reg::type_id::create("soft_reset");
    pkt_soft_reset.configure(this, null, "");
    pkt_soft_reset.build();
    pkt_soft_reset.set_coverage(UVM_CVR_FIELD_VALS);
    pkt_apb_map.add_reg(pkt_soft_reset, 'h60, "WO");

    lock_model();

  endfunction
endclass