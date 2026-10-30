class pkt_base_test extends uvm_test;
  `uvm_component_utils(pkt_base_test)

  pkt_env pkt_env_h;

  function new(string pkt_name, uvm_component pkt_parent);
    super.new(pkt_name,pkt_parent);
  endfunction

  function void build_phase(uvm_phase pkt_phase);
    super.build_phase(pkt_phase);
    pkt_env_h=pkt_env::type_id::create("env",this);
  endfunction
endclass



class device_id_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(device_id_ro_uvm_test)

  function new(string pkt_name = "device_id_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    device_id_ro_test pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = device_id_ro_test::type_id::create("seq");

    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;

    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class version_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(version_ro_uvm_test)

  function new(string pkt_name = "version_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    version_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = version_ro_sequence::type_id::create("seq");

    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;

    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class switch_status_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(switch_status_ro_uvm_test)

  function new(string pkt_name = "switch_status_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    switch_status_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = switch_status_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class port_status_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(port_status_ro_uvm_test)

  function new(string pkt_name = "port_status_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    port_status_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = port_status_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class gen_status_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(gen_status_ro_uvm_test)

  function new(string pkt_name = "gen_status_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    gen_status_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = gen_status_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class stat_rx_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(stat_rx_ro_uvm_test)

  function new(string pkt_name = "stat_rx_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    stat_rx_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = stat_rx_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class stat_tx_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(stat_tx_ro_uvm_test)

  function new(string pkt_name = "stat_tx_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    stat_tx_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = stat_tx_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass




class stat_drop_ro_uvm_test extends pkt_base_test;

  `uvm_component_utils(stat_drop_ro_uvm_test)

  function new(string pkt_name = "stat_drop_ro_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    stat_drop_ro_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = stat_drop_ro_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class port_enable_uvm_test extends pkt_base_test;

  `uvm_component_utils(port_enable_uvm_test)

  function new(string pkt_name = "port_enable_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    port_enable_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = port_enable_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class switch_ctrl_uvm_test extends pkt_base_test;

  `uvm_component_utils(switch_ctrl_uvm_test)

  function new(string pkt_name = "switch_ctrl_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    switch_ctrl_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = switch_ctrl_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class fwd_enable_uvm_test extends pkt_base_test;

  `uvm_component_utils(fwd_enable_uvm_test)

  function new(string pkt_name = "fwd_enable_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    fwd_enable_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = fwd_enable_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class gen_ctrl_uvm_test extends pkt_base_test;

  `uvm_component_utils(gen_ctrl_uvm_test)

  function new(string pkt_name = "gen_ctrl_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    gen_ctrl_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = gen_ctrl_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class gen_pkt_cfg_uvm_test extends pkt_base_test;

  `uvm_component_utils(gen_pkt_cfg_uvm_test)

  function new(string pkt_name = "gen_pkt_cfg_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    gen_pkt_cfg_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = gen_pkt_cfg_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass

class unaligned_address_test extends pkt_base_test;
  `uvm_component_utils(unaligned_address_test)

  function new(string pkt_name = "unaligned_address_test", uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    unaligned_address_sequence pkt_seq;

    pkt_phase.raise_objection(this);
    pkt_seq = unaligned_address_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);
    pkt_phase.drop_objection(this);
  endtask
endclass


class invalid_address_test extends pkt_base_test;
  `uvm_component_utils(invalid_address_test)

  function new(string pkt_name = "invalid_address_test", uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    invalid_address_sequence pkt_seq;

    pkt_phase.raise_objection(this);
    pkt_seq = invalid_address_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);
    pkt_phase.drop_objection(this);
  endtask
endclass



class gen_interval_uvm_test extends pkt_base_test;

  `uvm_component_utils(gen_interval_uvm_test)

  function new(string pkt_name = "gen_interval_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    gen_interval_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = gen_interval_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class gen_count_uvm_test extends pkt_base_test;

  `uvm_component_utils(gen_count_uvm_test)

  function new(string pkt_name = "gen_count_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    gen_count_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = gen_count_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class irq_status_uvm_test extends pkt_base_test;

  `uvm_component_utils(irq_status_uvm_test)

  function new(string pkt_name = "irq_status_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    irq_status_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = irq_status_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class irq_enable_uvm_test extends pkt_base_test;

  `uvm_component_utils(irq_enable_uvm_test)

  function new(string pkt_name = "irq_enable_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    irq_enable_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = irq_enable_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class irq_force_uvm_test extends pkt_base_test;

  `uvm_component_utils(irq_force_uvm_test)

  function new(string pkt_name = "irq_force_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    irq_force_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = irq_force_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class err_status_uvm_test extends pkt_base_test;

  `uvm_component_utils(err_status_uvm_test)

  function new(string pkt_name = "err_status_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    err_status_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = err_status_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class err_enable_uvm_test extends pkt_base_test;

  `uvm_component_utils(err_enable_uvm_test)

  function new(string pkt_name = "err_enable_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    err_enable_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = err_enable_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class err_inject_uvm_test extends pkt_base_test;

  `uvm_component_utils(err_inject_uvm_test)

  function new(string pkt_name = "err_inject_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    err_inject_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = err_inject_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass




class err_count_uvm_test extends pkt_base_test;

  `uvm_component_utils(err_count_uvm_test)

  function new(string pkt_name = "err_count_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    err_count_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = err_count_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass


class err_info_uvm_test extends pkt_base_test;

  `uvm_component_utils(err_info_uvm_test)

  function new(string pkt_name = "err_info_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    err_info_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = err_info_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass

class lock_uvm_test extends pkt_base_test;

  `uvm_component_utils(lock_uvm_test)

  function new(string pkt_name = "lock_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    lock_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = lock_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class soft_reset_uvm_test extends pkt_base_test;

  `uvm_component_utils(soft_reset_uvm_test)

  function new(string pkt_name = "soft_reset_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    soft_reset_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = soft_reset_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class reset_values_uvm_test extends pkt_base_test;

  `uvm_component_utils(reset_values_uvm_test)

  function new(string pkt_name = "reset_values_uvm_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    reset_values_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = reset_values_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass



class generate_four_packets_test extends pkt_base_test;

  `uvm_component_utils(generate_four_packets_test)

  function new(string pkt_name = "generate_four_packets_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    generate_four_packets_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = generate_four_packets_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass




class clear_sticky_status_test extends pkt_base_test;

  `uvm_component_utils(clear_sticky_status_test)

  function new(string pkt_name = "clear_sticky_status_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    clear_sticky_status_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = clear_sticky_status_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass




class destination_drop_test extends pkt_base_test;

  `uvm_component_utils(destination_drop_test)

  function new(string pkt_name = "destination_drop_test",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    destination_drop_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = destination_drop_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass

class pkt_regression_test extends pkt_base_test;
  `uvm_component_utils(pkt_regression_test)

  function new(string pkt_name = "pkt_regression_test", uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
  endfunction

  task run_phase(uvm_phase pkt_phase);
    pkt_regression_sequence pkt_seq;

    pkt_phase.raise_objection(this);

    pkt_seq = pkt_regression_sequence::type_id::create("seq");
    pkt_seq.pkt_regmodel = pkt_env_h.pkt_regmodel;
    pkt_seq.start(pkt_env_h.pkt_agent_h.pkt_sequencer_h);

    pkt_phase.drop_objection(this);
  endtask

endclass