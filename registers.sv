import uvm_pkg::*;
`include "uvm_macros.svh"
//==============================================================
// DEVICE_ID: 0x00
//==============================================================
class device_id_reg extends uvm_reg;
  `uvm_object_utils(device_id_reg)

  rand uvm_reg_field pkt_revision, pkt_vendor_id, pkt_product_id;

  covergroup pkt_device_id_cov;
    option.per_instance = 1;

    coverpoint pkt_revision.value {
      bins expected = {8'h02};
    }

    coverpoint pkt_vendor_id.value {
      bins expected = {8'hA5};
    }

    coverpoint pkt_product_id.value {
      bins expected = {16'h5357};
    }
  endgroup

  function new(string pkt_name="device_id_reg");
    super.new(pkt_name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_device_id_cov = new();
  endfunction

  virtual function void build();
    pkt_revision   = uvm_reg_field::type_id::create("revision");
    pkt_vendor_id  = uvm_reg_field::type_id::create("vendor_id");
    pkt_product_id = uvm_reg_field::type_id::create("product_id");

    pkt_revision.configure(this, 8, 24, "RO", 0, 8'h02, 1, 0, 0);
    pkt_vendor_id.configure(this, 8, 16, "RO", 0, 8'hA5, 1, 0, 0);
    pkt_product_id.configure(this, 16, 0, "RO", 0, 16'h5357, 1, 0, 0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_device_id_cov.sample();
  endfunction
endclass


//==============================================================
// VERSION: 0x04
//==============================================================
class version_reg extends uvm_reg;
  `uvm_object_utils(version_reg)

  rand uvm_reg_field pkt_reserved, pkt_major, pkt_minor, pkt_patch;

  covergroup pkt_version_cov;
    option.per_instance = 1;

    coverpoint pkt_major.value {
      bins expected = {8'h01};
    }

    coverpoint pkt_minor.value {
      bins expected = {8'h02};
    }

    coverpoint pkt_patch.value {
      bins expected = {8'h00};
    }
  endgroup

  function new(string pkt_name="version_reg");
    super.new(pkt_name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_version_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved = uvm_reg_field::type_id::create("reserved");
    pkt_major    = uvm_reg_field::type_id::create("major");
    pkt_minor    = uvm_reg_field::type_id::create("minor");
    pkt_patch    = uvm_reg_field::type_id::create("patch");

    pkt_reserved.configure(this, 8, 24, "RO", 0, 8'h00, 1, 0, 0);
    pkt_major.configure(this, 8, 16, "RO", 0, 8'h01, 1, 0, 0);
    pkt_minor.configure(this, 8, 8, "RO", 0, 8'h02, 1, 0, 0);
    pkt_patch.configure(this, 8, 0, "RO", 0, 8'h00, 1, 0, 0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_version_cov.sample();
  endfunction
endclass

//==============================================================
// SWITCH_STATUS: 0x08
//==============================================================
class switch_status_reg extends uvm_reg;
  `uvm_object_utils(switch_status_reg)

  rand uvm_reg_field pkt_reserved_hi, pkt_gen_fsm, pkt_reserved_mid;
  rand uvm_reg_field pkt_err_pending, pkt_gen_running, pkt_port_enabled;
  rand uvm_reg_field pkt_locked, pkt_switch_enabled, pkt_busy, pkt_ready;

  covergroup pkt_switch_status_cov;
    option.per_instance = 1;

    coverpoint pkt_gen_fsm.value {
      bins idle = {0};
      bins send = {1};
      bins gap  = {2};
      bins pkt_done = {3};
    }

    coverpoint pkt_locked.value {
      bins pkt_locked   = {1};
      bins unlocked = {0};
    }

    coverpoint pkt_switch_enabled.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_gen_running.value {
      bins stopped = {0};
      bins pkt_running = {1};
    }
  endgroup

  function new(string pkt_name="switch_status_reg");
    super.new(pkt_name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_switch_status_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved_hi = uvm_reg_field::type_id::create("reserved_hi");
    pkt_gen_fsm = uvm_reg_field::type_id::create("gen_fsm");
    pkt_reserved_mid = uvm_reg_field::type_id::create("reserved_mid");
    pkt_err_pending = uvm_reg_field::type_id::create("err_pending");
    pkt_gen_running = uvm_reg_field::type_id::create("gen_running");
    pkt_port_enabled = uvm_reg_field::type_id::create("port_enabled");
    pkt_locked = uvm_reg_field::type_id::create("locked");
    pkt_switch_enabled = uvm_reg_field::type_id::create("switch_enabled");
    pkt_busy = uvm_reg_field::type_id::create("busy");
    pkt_ready = uvm_reg_field::type_id::create("ready");

    pkt_reserved_hi.configure(this,14,18,"RO",0,14'h0,1,0,0);
    pkt_gen_fsm.configure(this,2,16,"RO",1,2'h0,1,0,0);
    pkt_reserved_mid.configure(this,6,10,"RO",0,6'h0,1,0,0);
    pkt_err_pending.configure(this,1,9,"RO",1,1'b0,1,0,0);
    pkt_gen_running.configure(this,1,8,"RO",1,1'b0,1,0,0);
    pkt_port_enabled.configure(this,4,4,"RO",1,4'hF,1,0,0);
    pkt_locked.configure(this,1,3,"RO",1,1'b1,1,0,0);
    pkt_switch_enabled.configure(this,1,2,"RO",1,1'b0,1,0,0);
    pkt_busy.configure(this,1,1,"RO",1,1'b0,1,0,0);
    pkt_ready.configure(this,1,0,"RO",1,1'b1,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_switch_status_cov.sample();
  endfunction
endclass


//==============================================================
// PORT_STATUS: 0x0C
//==============================================================
class port_status_reg extends uvm_reg;
  `uvm_object_utils(port_status_reg)

  rand uvm_reg_field pkt_port3_level, pkt_port2_level;
  rand uvm_reg_field pkt_port1_level, pkt_port0_level;

  covergroup pkt_port_status_cov;
    option.per_instance = 1;

    coverpoint pkt_port0_level.value {
      bins empty = {0};
      bins occupied = {[1:15]};
      bins full = {16};
    }

    coverpoint pkt_port1_level.value {
      bins empty = {0};
      bins occupied = {[1:15]};
      bins full = {16};
    }

    coverpoint pkt_port2_level.value {
      bins empty = {0};
      bins occupied = {[1:15]};
      bins full = {16};
    }

    coverpoint pkt_port3_level.value {
      bins empty = {0};
      bins occupied = {[1:15]};
      bins full = {16};
    }
  endgroup

  function new(string pkt_name="port_status_reg");
    super.new(pkt_name, 32, UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_port_status_cov = new();
  endfunction

  virtual function void build();
    pkt_port3_level = uvm_reg_field::type_id::create("port3_level");
    pkt_port2_level = uvm_reg_field::type_id::create("port2_level");
    pkt_port1_level = uvm_reg_field::type_id::create("port1_level");
    pkt_port0_level = uvm_reg_field::type_id::create("port0_level");

    pkt_port3_level.configure(this,8,24,"RO",1,8'h0,1,0,0);
    pkt_port2_level.configure(this,8,16,"RO",1,8'h0,1,0,0);
    pkt_port1_level.configure(this,8,8,"RO",1,8'h0,1,0,0);
    pkt_port0_level.configure(this,8,0,"RO",1,8'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_port_status_cov.sample();
  endfunction
endclass

//==============================================================
// GEN_STATUS: 0x10
//==============================================================
class gen_status_reg extends uvm_reg;
  `uvm_object_utils(gen_status_reg)

  rand uvm_reg_field pkt_reserved_hi, pkt_remaining, pkt_reserved_mid;
  rand uvm_reg_field pkt_fsm, pkt_done, pkt_running;

  covergroup pkt_gen_status_cov;
    option.per_instance = 1;

    coverpoint pkt_fsm.value {
      bins idle = {0};
      bins send = {1};
      bins gap  = {2};
      bins pkt_done = {3};
    }

    coverpoint pkt_running.value {
      bins stopped = {0};
      bins pkt_running = {1};
    }

    coverpoint pkt_done.value {
      bins not_done = {0};
      bins completed = {1};
    }

    coverpoint pkt_remaining.value {
      bins zero = {0};
      bins some_remaining = {[1:65535]};
    }
  endgroup

  function new(string pkt_name="gen_status_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_status_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved_hi=uvm_reg_field::type_id::create("reserved_hi");
    pkt_remaining=uvm_reg_field::type_id::create("remaining");
    pkt_reserved_mid=uvm_reg_field::type_id::create("reserved_mid");
    pkt_fsm=uvm_reg_field::type_id::create("fsm");
    pkt_done=uvm_reg_field::type_id::create("done");
    pkt_running=uvm_reg_field::type_id::create("running");

    pkt_reserved_hi.configure(this,8,24,"RO",0,8'h0,1,0,0);
    pkt_remaining.configure(this,16,8,"RO",1,16'h0,1,0,0);
    pkt_reserved_mid.configure(this,4,4,"RO",0,4'h0,1,0,0);
    pkt_fsm.configure(this,2,2,"RO",1,2'h0,1,0,0);
    pkt_done.configure(this,1,1,"RO",1,1'b0,1,0,0);
    pkt_running.configure(this,1,0,"RO",1,1'b0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_gen_status_cov.sample();
  endfunction
endclass


//==============================================================
// STAT_RX: 0x14
//==============================================================
class stat_rx_reg extends uvm_reg;
  `uvm_object_utils(stat_rx_reg)

  rand uvm_reg_field pkt_reserved, pkt_rx_packets;

  covergroup pkt_stat_rx_cov;
    option.per_instance = 1;

    coverpoint pkt_rx_packets.value {
      bins zero = {0};
      bins one_packet = {1};
      bins multiple_packets = {[2:65534]};
      bins max_count = {65535};
    }
  endgroup

  function new(string pkt_name="stat_rx_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_stat_rx_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_rx_packets=uvm_reg_field::type_id::create("rx_packets");

    pkt_reserved.configure(this,16,16,"RO",0,16'h0,1,0,0);
    pkt_rx_packets.configure(this,16,0,"RO",1,16'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_stat_rx_cov.sample();
  endfunction
endclass

//==============================================================
// STAT_TX: 0x18
//==============================================================
class stat_tx_reg extends uvm_reg;
  `uvm_object_utils(stat_tx_reg)

  rand uvm_reg_field pkt_reserved, pkt_tx_packets;

  covergroup pkt_stat_tx_cov;
    option.per_instance = 1;

    coverpoint pkt_tx_packets.value {
      bins zero = {0};
      bins one_packet = {1};
      bins multiple_packets = {[2:65534]};
      bins max_count = {65535};
    }
  endgroup

  function new(string pkt_name="stat_tx_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_stat_tx_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_tx_packets=uvm_reg_field::type_id::create("tx_packets");

    pkt_reserved.configure(this,16,16,"RO",0,16'h0,1,0,0);
    pkt_tx_packets.configure(this,16,0,"RO",1,16'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_stat_tx_cov.sample();
  endfunction
endclass


//==============================================================
// STAT_DROP: 0x1C
//==============================================================
class stat_drop_reg extends uvm_reg;
  `uvm_object_utils(stat_drop_reg)

  rand uvm_reg_field pkt_reserved, pkt_dropped_packets;

  covergroup pkt_stat_drop_cov;
    option.per_instance = 1;

    coverpoint pkt_dropped_packets.value {
      bins zero = {0};
      bins one_packet = {1};
      bins multiple_packets = {[2:65534]};
      bins max_count = {65535};
    }
  endgroup

  function new(string pkt_name="stat_drop_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);
    if (has_coverage(UVM_CVR_FIELD_VALS))
      pkt_stat_drop_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_dropped_packets=uvm_reg_field::type_id::create("dropped_packets");

    pkt_reserved.configure(this,16,16,"RO",0,16'h0,1,0,0);
    pkt_dropped_packets.configure(this,16,0,"RO",1,16'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    pkt_stat_drop_cov.sample();
  endfunction
endclass

//==============================================================
// SWITCH_CTRL: 0x20 -- mixed RW / WO
//==============================================================
class switch_ctrl_reg extends uvm_reg;
  `uvm_object_utils(switch_ctrl_reg)

  rand uvm_reg_field pkt_reserved_hi, pkt_irq_global_en;
  rand uvm_reg_field pkt_reserved_bit2, pkt_stat_clear, pkt_enable;

  covergroup pkt_switch_ctrl_cov;
    option.per_instance = 1;

    coverpoint pkt_irq_global_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_enable.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="switch_ctrl_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_switch_ctrl_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved_hi=uvm_reg_field::type_id::create("reserved_hi");
    pkt_irq_global_en=uvm_reg_field::type_id::create("irq_global_en");
    pkt_reserved_bit2=uvm_reg_field::type_id::create("reserved_bit2");
    pkt_stat_clear=uvm_reg_field::type_id::create("stat_clear");
    pkt_enable=uvm_reg_field::type_id::create("enable");

    pkt_reserved_hi.configure(this,28,4,"RO",0,28'h0,1,0,0);
    pkt_irq_global_en.configure(this,1,3,"RW",0,1'b0,1,1,1);
    pkt_reserved_bit2.configure(this,1,2,"RO",0,1'b0,1,0,0);
    pkt_stat_clear.configure(this,1,1,"WO",0,1'b0,1,0,0);
    pkt_enable.configure(this,1,0,"RW",0,1'b0,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_switch_ctrl_cov.sample();
  endfunction
endclass

//==============================================================
// PORT_ENABLE: 0x24
//==============================================================
class port_enable_reg extends uvm_reg;
  `uvm_object_utils(port_enable_reg)

  rand uvm_reg_field pkt_reserved, pkt_port3_en, pkt_port2_en, pkt_port1_en, pkt_port0_en;

  covergroup pkt_port_enable_cov;
    option.per_instance = 1;

    coverpoint pkt_port0_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_port1_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_port2_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_port3_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="port_enable_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_port_enable_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_port3_en=uvm_reg_field::type_id::create("port3_en");
    pkt_port2_en=uvm_reg_field::type_id::create("port2_en");
    pkt_port1_en=uvm_reg_field::type_id::create("port1_en");
    pkt_port0_en=uvm_reg_field::type_id::create("port0_en");

    pkt_reserved.configure(this,28,4,"RO",0,28'h0,1,0,0);
    pkt_port3_en.configure(this,1,3,"RW",0,1'b1,1,1,1);
    pkt_port2_en.configure(this,1,2,"RW",0,1'b1,1,1,1);
    pkt_port1_en.configure(this,1,1,"RW",0,1'b1,1,1,1);
    pkt_port0_en.configure(this,1,0,"RW",0,1'b1,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_port_enable_cov.sample();
  endfunction
endclass

//==============================================================
// FWD_ENABLE: 0x28
//==============================================================
class fwd_enable_reg extends uvm_reg;
  `uvm_object_utils(fwd_enable_reg)

  rand uvm_reg_field pkt_reserved, pkt_fwd3_en, pkt_fwd2_en, pkt_fwd1_en, pkt_fwd0_en;

  covergroup pkt_fwd_enable_cov;
    option.per_instance = 1;

    coverpoint pkt_fwd0_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_fwd1_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_fwd2_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_fwd3_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="fwd_enable_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_fwd_enable_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_fwd3_en=uvm_reg_field::type_id::create("fwd3_en");
    pkt_fwd2_en=uvm_reg_field::type_id::create("fwd2_en");
    pkt_fwd1_en=uvm_reg_field::type_id::create("fwd1_en");
    pkt_fwd0_en=uvm_reg_field::type_id::create("fwd0_en");

    pkt_reserved.configure(this,28,4,"RO",0,28'h0,1,0,0);
    pkt_fwd3_en.configure(this,1,3,"RW",0,1'b1,1,1,1);
    pkt_fwd2_en.configure(this,1,2,"RW",0,1'b1,1,1,1);
    pkt_fwd1_en.configure(this,1,1,"RW",0,1'b1,1,1,1);
    pkt_fwd0_en.configure(this,1,0,"RW",0,1'b1,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_fwd_enable_cov.sample();
  endfunction
endclass

//==============================================================
// GEN_CTRL: 0x2C -- ENABLE/CONTINUOUS RW, START/STOP WO
//==============================================================
class gen_ctrl_reg extends uvm_reg;
  `uvm_object_utils(gen_ctrl_reg)

  rand uvm_reg_field pkt_reserved, pkt_continuous, pkt_stop, pkt_start, pkt_enable;

  covergroup pkt_gen_ctrl_cov;
    option.per_instance = 1;

    coverpoint pkt_continuous.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_enable.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="gen_ctrl_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_ctrl_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_continuous=uvm_reg_field::type_id::create("continuous");
    pkt_stop=uvm_reg_field::type_id::create("stop");
    pkt_start=uvm_reg_field::type_id::create("start");
    pkt_enable=uvm_reg_field::type_id::create("enable");

    pkt_reserved.configure(this,28,4,"RO",0,28'h0,1,0,0);
    pkt_continuous.configure(this,1,3,"RW",0,1'b0,1,1,1);
    pkt_stop.configure(this,1,2,"WO",0,1'b0,1,0,0);
    pkt_start.configure(this,1,1,"WO",0,1'b0,1,0,0);
    pkt_enable.configure(this,1,0,"RW",0,1'b0,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_ctrl_cov.sample();
  endfunction
endclass

//==============================================================
// GEN_PKT_CFG: 0x30
//==============================================================
class gen_pkt_cfg_reg extends uvm_reg;
  `uvm_object_utils(gen_pkt_cfg_reg)

  rand uvm_reg_field pkt_reserved_hi, pkt_seed, pkt_length;
  rand uvm_reg_field pkt_reserved_mid, pkt_src_port, pkt_dst_port;

  covergroup pkt_gen_pkt_cfg_cov;
    option.per_instance = 1;

    coverpoint pkt_length.value {
      bins zero       = {0};
      bins valid      = {[1:16]};
      bins above_max  = {[17:255]};
    }

    coverpoint pkt_src_port.value {
      bins port0 = {0};
      bins port1 = {1};
      bins port2 = {2};
      bins port3 = {3};
    }

    coverpoint pkt_dst_port.value {
      bins port0 = {0};
      bins port1 = {1};
      bins port2 = {2};
      bins port3 = {3};
    }
  endgroup

  function new(string pkt_name="gen_pkt_cfg_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_pkt_cfg_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved_hi=uvm_reg_field::type_id::create("reserved_hi");
    pkt_seed=uvm_reg_field::type_id::create("seed");
    pkt_length=uvm_reg_field::type_id::create("length");
    pkt_reserved_mid=uvm_reg_field::type_id::create("reserved_mid");
    pkt_src_port=uvm_reg_field::type_id::create("src_port");
    pkt_dst_port=uvm_reg_field::type_id::create("dst_port");

    pkt_reserved_hi.configure(this,8,24,"RO",0,8'h0,1,0,0);
    pkt_seed.configure(this,8,16,"RW",0,8'h00,1,1,1);
    pkt_length.configure(this,8,8,"RW",0,8'h04,1,1,1);
    pkt_reserved_mid.configure(this,4,4,"RO",0,4'h0,1,0,0);
    pkt_src_port.configure(this,2,2,"RW",0,2'h0,1,1,1);
    pkt_dst_port.configure(this,2,0,"RW",0,2'h1,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_pkt_cfg_cov.sample();
  endfunction
endclass

//==============================================================
// GEN_INTERVAL: 0x34
//==============================================================
class gen_interval_reg extends uvm_reg;
  `uvm_object_utils(gen_interval_reg)

  rand uvm_reg_field pkt_interval;

  covergroup pkt_gen_interval_cov;
    option.per_instance = 1;

    coverpoint pkt_interval.value {
      bins zero          = {0};
      bins single_cycle  = {1};
      bins multiple      = {[2:32'hFFFFFFFE]};
      bins max_value     = {32'hFFFFFFFF};
    }
  endgroup

  function new(string pkt_name="gen_interval_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_interval_cov = new();
  endfunction

  virtual function void build();
    pkt_interval=uvm_reg_field::type_id::create("interval");
    pkt_interval.configure(this,32,0,"RW",0,32'h2,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_interval_cov.sample();
  endfunction
endclass

//==============================================================
// GEN_COUNT: 0x38
//==============================================================
class gen_count_reg extends uvm_reg;
  `uvm_object_utils(gen_count_reg)

  rand uvm_reg_field pkt_count;

  covergroup pkt_gen_count_cov;
    option.per_instance = 1;

    coverpoint pkt_count.value {
      bins zero          = {0};
      bins single_packet = {1};
      bins multiple      = {[2:32'hFFFFFFFE]};
      bins max_value     = {32'hFFFFFFFF};
    }
  endgroup

  function new(string pkt_name="gen_count_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_count_cov = new();
  endfunction

  virtual function void build();
    pkt_count=uvm_reg_field::type_id::create("count");
    pkt_count.configure(this,32,0,"RW",0,32'h4,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_gen_count_cov.sample();
  endfunction
endclass

//==============================================================
// IRQ_STATUS: 0x3C -- W1C
//==============================================================
class irq_status_reg extends uvm_reg;
  `uvm_object_utils(irq_status_reg)

  rand uvm_reg_field pkt_sw_event, pkt_start_ack, pkt_queue_af, pkt_packet_fwd;
  rand uvm_reg_field pkt_packet_drop, pkt_overflow, pkt_error, pkt_gen_done;
  rand uvm_reg_field pkt_reserved;

  covergroup pkt_irq_status_cov;
    option.per_instance = 1;

    coverpoint pkt_sw_event.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_start_ack.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_packet_drop.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_error.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_gen_done.value {
      bins inactive = {0};
      bins active   = {1};
    }
  endgroup

  function new(string pkt_name="irq_status_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_status_cov = new();
  endfunction

  virtual function void build();
    pkt_sw_event=uvm_reg_field::type_id::create("sw_event");
    pkt_start_ack=uvm_reg_field::type_id::create("start_ack");
    pkt_queue_af=uvm_reg_field::type_id::create("queue_af");
    pkt_packet_fwd=uvm_reg_field::type_id::create("packet_fwd");
    pkt_packet_drop=uvm_reg_field::type_id::create("packet_drop");
    pkt_overflow=uvm_reg_field::type_id::create("overflow");
    pkt_error=uvm_reg_field::type_id::create("error");
    pkt_gen_done=uvm_reg_field::type_id::create("gen_done");
    pkt_reserved=uvm_reg_field::type_id::create("reserved");

    pkt_reserved.configure(this,24,8,"RO",0,24'h0,1,0,0);
    pkt_sw_event.configure(this,1,7,"W1C",0,1'b0,1,0,0);
    pkt_start_ack.configure(this,1,6,"W1C",0,1'b0,1,0,0);
    pkt_queue_af.configure(this,1,5,"W1C",0,1'b0,1,0,0);
    pkt_packet_fwd.configure(this,1,4,"W1C",0,1'b0,1,0,0);
    pkt_packet_drop.configure(this,1,3,"W1C",0,1'b0,1,0,0);
    pkt_overflow.configure(this,1,2,"W1C",0,1'b0,1,0,0);
    pkt_error.configure(this,1,1,"W1C",0,1'b0,1,0,0);
    pkt_gen_done.configure(this,1,0,"W1C",0,1'b0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_status_cov.sample();
  endfunction
endclass

//==============================================================
// IRQ_ENABLE: 0x40
//==============================================================
class irq_enable_reg extends uvm_reg;
  `uvm_object_utils(irq_enable_reg)

  rand uvm_reg_field pkt_reserved, pkt_sw_event_en, pkt_start_ack_en, pkt_queue_af_en;
  rand uvm_reg_field pkt_packet_fwd_en, pkt_packet_drop_en, pkt_overflow_en;
  rand uvm_reg_field pkt_error_en, pkt_gen_done_en;

  covergroup pkt_irq_enable_cov;
    option.per_instance = 1;

    coverpoint pkt_sw_event_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_packet_drop_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_error_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_gen_done_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="irq_enable_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_enable_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_sw_event_en=uvm_reg_field::type_id::create("sw_event_en");
    pkt_start_ack_en=uvm_reg_field::type_id::create("start_ack_en");
    pkt_queue_af_en=uvm_reg_field::type_id::create("queue_af_en");
    pkt_packet_fwd_en=uvm_reg_field::type_id::create("packet_fwd_en");
    pkt_packet_drop_en=uvm_reg_field::type_id::create("packet_drop_en");
    pkt_overflow_en=uvm_reg_field::type_id::create("overflow_en");
    pkt_error_en=uvm_reg_field::type_id::create("error_en");
    pkt_gen_done_en=uvm_reg_field::type_id::create("gen_done_en");

    pkt_reserved.configure(this,24,8,"RO",0,24'h0,1,0,0);
    pkt_sw_event_en.configure(this,1,7,"RW",0,1'b0,1,1,1);
    pkt_start_ack_en.configure(this,1,6,"RW",0,1'b0,1,1,1);
    pkt_queue_af_en.configure(this,1,5,"RW",0,1'b0,1,1,1);
    pkt_packet_fwd_en.configure(this,1,4,"RW",0,1'b0,1,1,1);
    pkt_packet_drop_en.configure(this,1,3,"RW",0,1'b0,1,1,1);
    pkt_overflow_en.configure(this,1,2,"RW",0,1'b0,1,1,1);
    pkt_error_en.configure(this,1,1,"RW",0,1'b0,1,1,1);
    pkt_gen_done_en.configure(this,1,0,"RW",0,1'b0,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_enable_cov.sample();
  endfunction
endclass

//==============================================================
// IRQ_FORCE: 0x44 -- write-only force bits
//==============================================================
class irq_force_reg extends uvm_reg;
  `uvm_object_utils(irq_force_reg)

  rand uvm_reg_field pkt_reserved, pkt_force_bits;

  covergroup pkt_irq_force_cov;
    option.per_instance = 1;

    coverpoint pkt_force_bits.value {
      bins no_force       = {8'h00};
      bins single_bit     = {[8'h01:8'h80]};
      bins multiple_bits  = {[8'h81:8'hFF]};
    }
  endgroup

  function new(string pkt_name="irq_force_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_force_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_force_bits=uvm_reg_field::type_id::create("force_bits");

    pkt_reserved.configure(this,24,8,"WO",0,24'h0,1,0,0);
    pkt_force_bits.configure(this,8,0,"WO",0,8'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_irq_force_cov.sample();
  endfunction
endclass

//==============================================================
// ERR_STATUS: 0x48 -- W1C
//==============================================================
class err_status_reg extends uvm_reg;
  `uvm_object_utils(err_status_reg)

  rand uvm_reg_field pkt_reserved, pkt_injected, pkt_length_error, pkt_crc_error;
  rand uvm_reg_field pkt_protocol_error, pkt_undersize, pkt_queue_overflow;
  rand uvm_reg_field pkt_dest_error, pkt_bus_error;

  covergroup pkt_err_status_cov;
    option.per_instance = 1;

    coverpoint pkt_injected.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_length_error.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_queue_overflow.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_dest_error.value {
      bins inactive = {0};
      bins active   = {1};
    }

    coverpoint pkt_bus_error.value {
      bins inactive = {0};
      bins active   = {1};
    }
  endgroup

  function new(string pkt_name="err_status_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_status_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_injected=uvm_reg_field::type_id::create("injected");
    pkt_length_error=uvm_reg_field::type_id::create("length_error");
    pkt_crc_error=uvm_reg_field::type_id::create("crc_error");
    pkt_protocol_error=uvm_reg_field::type_id::create("protocol_error");
    pkt_undersize=uvm_reg_field::type_id::create("undersize");
    pkt_queue_overflow=uvm_reg_field::type_id::create("queue_overflow");
    pkt_dest_error=uvm_reg_field::type_id::create("dest_error");
    pkt_bus_error=uvm_reg_field::type_id::create("bus_error");

    pkt_reserved.configure(this,24,8,"RO",0,24'h0,1,0,0);
    pkt_injected.configure(this,1,7,"W1C",0,1'b0,1,0,0);
    pkt_length_error.configure(this,1,6,"W1C",0,1'b0,1,0,0);
    pkt_crc_error.configure(this,1,5,"W1C",0,1'b0,1,0,0);
    pkt_protocol_error.configure(this,1,4,"W1C",0,1'b0,1,0,0);
    pkt_undersize.configure(this,1,3,"W1C",0,1'b0,1,0,0);
    pkt_queue_overflow.configure(this,1,2,"W1C",0,1'b0,1,0,0);
    pkt_dest_error.configure(this,1,1,"W1C",0,1'b0,1,0,0);
    pkt_bus_error.configure(this,1,0,"W1C",0,1'b0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_status_cov.sample();
  endfunction
endclass

//==============================================================
// ERR_ENABLE: 0x4C
//==============================================================
class err_enable_reg extends uvm_reg;
  `uvm_object_utils(err_enable_reg)

  rand uvm_reg_field pkt_reserved, pkt_injected_en, pkt_length_en, pkt_crc_en;
  rand uvm_reg_field pkt_protocol_en, pkt_undersize_en, pkt_overflow_en;
  rand uvm_reg_field pkt_dest_en, pkt_bus_en;

  covergroup pkt_err_enable_cov;
    option.per_instance = 1;

    coverpoint pkt_injected_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_length_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_overflow_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_dest_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }

    coverpoint pkt_bus_en.value {
      bins disabled = {0};
      bins enabled  = {1};
    }
  endgroup

  function new(string pkt_name="err_enable_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_enable_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_injected_en=uvm_reg_field::type_id::create("injected_en");
    pkt_length_en=uvm_reg_field::type_id::create("length_en");
    pkt_crc_en=uvm_reg_field::type_id::create("crc_en");
    pkt_protocol_en=uvm_reg_field::type_id::create("protocol_en");
    pkt_undersize_en=uvm_reg_field::type_id::create("undersize_en");
    pkt_overflow_en=uvm_reg_field::type_id::create("overflow_en");
    pkt_dest_en=uvm_reg_field::type_id::create("dest_en");
    pkt_bus_en=uvm_reg_field::type_id::create("bus_en");

    pkt_reserved.configure(this,24,8,"RO",0,24'h0,1,0,0);
    pkt_injected_en.configure(this,1,7,"RW",0,1'b0,1,1,1);
    pkt_length_en.configure(this,1,6,"RW",0,1'b0,1,1,1);
    pkt_crc_en.configure(this,1,5,"RW",0,1'b0,1,1,1);
    pkt_protocol_en.configure(this,1,4,"RW",0,1'b0,1,1,1);
    pkt_undersize_en.configure(this,1,3,"RW",0,1'b0,1,1,1);
    pkt_overflow_en.configure(this,1,2,"RW",0,1'b0,1,1,1);
    pkt_dest_en.configure(this,1,1,"RW",0,1'b0,1,1,1);
    pkt_bus_en.configure(this,1,0,"RW",0,1'b0,1,1,1);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_enable_cov.sample();
  endfunction
endclass

//==============================================================
// ERR_INJECT: 0x50 -- WO diagnostic event register
//==============================================================
class err_inject_reg extends uvm_reg;
  `uvm_object_utils(err_inject_reg)

  rand uvm_reg_field pkt_clear_count, pkt_reserved, pkt_injected, pkt_length;
  rand uvm_reg_field pkt_crc, pkt_protocol, pkt_undersize, pkt_overflow, pkt_dest, pkt_bus;

  covergroup pkt_err_inject_cov;
    option.per_instance = 1;

    coverpoint pkt_clear_count.value {
      bins no_clear = {0};
      bins clear    = {1};
    }

    coverpoint {pkt_injected.value, pkt_length.value, pkt_crc.value,
                pkt_protocol.value, pkt_undersize.value, pkt_overflow.value,
                pkt_dest.value, pkt_bus.value} {
      bins no_injection = {8'b0};
      bins injection    = {[8'b1:8'hFF]};
    }
  endgroup

  function new(string pkt_name="err_inject_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_inject_cov = new();
  endfunction

  virtual function void build();
    pkt_clear_count=uvm_reg_field::type_id::create("clear_count");
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_injected=uvm_reg_field::type_id::create("injected");
    pkt_length=uvm_reg_field::type_id::create("length");
    pkt_crc=uvm_reg_field::type_id::create("crc");
    pkt_protocol=uvm_reg_field::type_id::create("protocol");
    pkt_undersize=uvm_reg_field::type_id::create("undersize");
    pkt_overflow=uvm_reg_field::type_id::create("overflow");
    pkt_dest=uvm_reg_field::type_id::create("dest");
    pkt_bus=uvm_reg_field::type_id::create("bus");

    pkt_clear_count.configure(this,1,31,"WO",0,1'b0,1,0,0);
    pkt_reserved.configure(this,23,8,"WO",0,23'h0,1,0,0);
    pkt_injected.configure(this,1,7,"WO",0,1'b0,1,0,0);
    pkt_length.configure(this,1,6,"WO",0,1'b0,1,0,0);
    pkt_crc.configure(this,1,5,"WO",0,1'b0,1,0,0);
    pkt_protocol.configure(this,1,4,"WO",0,1'b0,1,0,0);
    pkt_undersize.configure(this,1,3,"WO",0,1'b0,1,0,0);
    pkt_overflow.configure(this,1,2,"WO",0,1'b0,1,0,0);
    pkt_dest.configure(this,1,1,"WO",0,1'b0,1,0,0);
    pkt_bus.configure(this,1,0,"WO",0,1'b0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_inject_cov.sample();
  endfunction
endclass

//==============================================================
// ERR_COUNT: 0x54
//==============================================================
class err_count_reg extends uvm_reg;
  `uvm_object_utils(err_count_reg)

  rand uvm_reg_field pkt_reserved, pkt_error_count;

  covergroup pkt_err_count_cov;
    option.per_instance = 1;

    coverpoint pkt_error_count.value {
      bins zero         = {0};
      bins one_error    = {1};
      bins multiple     = {[2:65534]};
      bins max_count    = {65535};
    }
  endgroup

  function new(string pkt_name="err_count_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_count_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_error_count=uvm_reg_field::type_id::create("error_count");

    pkt_reserved.configure(this,16,16,"RO",0,16'h0,1,0,0);
    pkt_error_count.configure(this,16,0,"RO",1,16'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_count_cov.sample();
  endfunction
endclass

//==============================================================
// ERR_INFO: 0x58
//==============================================================
class err_info_reg extends uvm_reg;
  `uvm_object_utils(err_info_reg)

  rand uvm_reg_field pkt_tx_snapshot, pkt_reserved, pkt_dest_port;
  rand uvm_reg_field pkt_source, pkt_last_code;

  covergroup pkt_err_info_cov;
    option.per_instance = 1;

    coverpoint pkt_dest_port.value {
      bins port0 = {0};
      bins port1 = {1};
      bins port2 = {2};
      bins port3 = {3};
    }

    coverpoint pkt_last_code.value {
      bins no_error = {0};
      bins pkt_error    = {[1:255]};
    }
  endgroup

  function new(string pkt_name="err_info_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_info_cov = new();
  endfunction

  virtual function void build();
    pkt_tx_snapshot=uvm_reg_field::type_id::create("tx_snapshot");
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_dest_port=uvm_reg_field::type_id::create("dest_port");
    pkt_source=uvm_reg_field::type_id::create("source");
    pkt_last_code=uvm_reg_field::type_id::create("last_code");

    pkt_tx_snapshot.configure(this,12,20,"RO",1,12'h0,1,0,0);
    pkt_reserved.configure(this,2,18,"RO",0,2'h0,1,0,0);
    pkt_dest_port.configure(this,2,16,"RO",1,2'h0,1,0,0);
    pkt_source.configure(this,8,8,"RO",1,8'h0,1,0,0);
    pkt_last_code.configure(this,8,0,"RO",1,8'h0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_err_info_cov.sample();
  endfunction
endclass

//==============================================================
// LOCK: 0x5C
// Writes compare the complete key; read returns LOCKED at bit 0.
//==============================================================
class lock_reg extends uvm_reg;
  `uvm_object_utils(lock_reg)

  rand uvm_reg_field pkt_key_reserved, pkt_locked;

  covergroup pkt_lock_cov;
    option.per_instance = 1;

    coverpoint pkt_locked.value {
      bins unlocked = {0};
      bins pkt_locked   = {1};
    }
  endgroup

  function new(string pkt_name="lock_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_lock_cov = new();
  endfunction

  virtual function void build();
    pkt_key_reserved=uvm_reg_field::type_id::create("key_reserved");
    pkt_locked=uvm_reg_field::type_id::create("locked");

    pkt_key_reserved.configure(this,31,1,"WO",0,31'h0,1,0,0);
    pkt_locked.configure(this,1,0,"RO",1,1'b1,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_lock_cov.sample();
  endfunction
endclass

//==============================================================
// SOFT_RESET: 0x60
//==============================================================
class soft_reset_reg extends uvm_reg;
  `uvm_object_utils(soft_reset_reg)

  rand uvm_reg_field pkt_reserved, pkt_pulse;

  covergroup pkt_soft_reset_cov;
    option.per_instance = 1;

    coverpoint pkt_pulse.value {
      bins inactive = {0};
      bins asserted = {1};
    }
  endgroup

  function new(string pkt_name="soft_reset_reg");
    super.new(pkt_name,32,UVM_CVR_FIELD_VALS);

    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_soft_reset_cov = new();
  endfunction

  virtual function void build();
    pkt_reserved=uvm_reg_field::type_id::create("reserved");
    pkt_pulse=uvm_reg_field::type_id::create("pulse");

    pkt_reserved.configure(this,31,1,"WO",0,31'h0,1,0,0);
    pkt_pulse.configure(this,1,0,"WO",0,1'b0,1,0,0);
  endfunction

  virtual function void sample_values();
    super.sample_values();
    if(has_coverage(UVM_CVR_FIELD_VALS))
      pkt_soft_reset_cov.sample();
  endfunction
endclass