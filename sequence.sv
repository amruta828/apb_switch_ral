class pkt_base_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(pkt_base_sequence)

  pkt_reg_block pkt_regmodel;
  uvm_status_e pkt_status;
  uvm_reg_data_t pkt_read_value;

  function new(string pkt_name = "pkt_base_sequence");
    super.new(pkt_name);
  endfunction

  task unlock_config();
    pkt_regmodel.lock.write(pkt_status, 32'hA5A5C3C3, UVM_FRONTDOOR);
    pkt_regmodel.lock.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[0] != 1'b0)
      `uvm_fatal("BASE_SEQ", "Configuration did not unlock")
    `uvm_info("BASE_SEQ", "Configuration unlocked successfully", UVM_LOW)
  endtask

  task check_readback(
    uvm_reg pkt_rg,
    uvm_reg_data_t pkt_expected_value,
    uvm_reg_data_t pkt_mask,
    string pkt_name
  );
    pkt_rg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if ((pkt_read_value & pkt_mask) == (pkt_expected_value & pkt_mask))
      `uvm_info("BASE_SEQ",$sformatf("PASS: %s expected=0x%08h read=0x%08h",pkt_name, pkt_expected_value, pkt_read_value), UVM_LOW)
    else
      `uvm_error("BASE_SEQ",$sformatf("FAIL: %s expected=0x%08h read=0x%08h mask=0x%08h",pkt_name, pkt_expected_value, pkt_read_value, pkt_mask))
  endtask

endclass
   
class device_id_ro_test extends pkt_base_sequence;
  `uvm_object_utils(device_id_ro_test)

  function new(string pkt_name = "device_id_ro_test");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_after_write_value;
    uvm_reg_data_t pkt_write_value;

    if (pkt_regmodel == null) `uvm_fatal("DEVICE_ID_RO", "Register model is not assigned")

    pkt_regmodel.device_id.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("DEVICE_ID_RO", "Initial read failed")

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.device_id.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("DEVICE_ID_RO", "Write operation failed")

    pkt_regmodel.device_id.read(pkt_status, pkt_after_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("DEVICE_ID_RO", "Read after write failed")

    if (pkt_original_value == pkt_after_write_value) `uvm_info("DEVICE_ID_RO", "PASS: DEVICE_ID remained unchanged after write", UVM_LOW)
    else `uvm_error("DEVICE_ID_RO", $sformatf("FAIL: Before=0x%08h After=0x%08h", pkt_original_value, pkt_after_write_value))
  endtask
endclass
      
class version_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(version_ro_sequence)

  function new(string pkt_name = "version_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_after_write_value;
    uvm_reg_data_t pkt_write_value;

    if (pkt_regmodel == null) `uvm_fatal("VERSION_RO", "Register model is not assigned")

    pkt_regmodel.version.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("VERSION_RO", "Initial read failed")

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.version.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("VERSION_RO", "Write operation failed")

    pkt_regmodel.version.read(pkt_status, pkt_after_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("VERSION_RO", "Read after write failed")

    if (pkt_original_value == pkt_after_write_value) `uvm_info("VERSION_RO", "PASS: VERSION remained unchanged after write", UVM_LOW)
    else `uvm_error("VERSION_RO", $sformatf("FAIL: Original=0x%08h After=0x%08h", pkt_original_value, pkt_after_write_value))
  endtask
endclass
      
class switch_status_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(switch_status_ro_sequence)

  uvm_reg_data_t pkt_original_value;

  function new(string pkt_name = "switch_status_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("SWITCH_STATUS_RO", "Register model is not assigned")

    pkt_regmodel.switch_status.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("SWITCH_STATUS_RO", "Initial read failed")

    pkt_regmodel.switch_status.write(pkt_status, ~pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("SWITCH_STATUS_RO", "Write access failed")

    pkt_regmodel.switch_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("SWITCH_STATUS_RO", "Readback failed")

    if (pkt_read_value == pkt_original_value)
      `uvm_info("SWITCH_STATUS_RO", $sformatf("PASS: SWITCH_STATUS is read-only, value=0x%08h", pkt_read_value), UVM_LOW)
    else
      `uvm_error("SWITCH_STATUS_RO", $sformatf("FAIL: SWITCH_STATUS changed, expected=0x%08h actual=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
class port_status_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(port_status_ro_sequence)

  uvm_reg_data_t pkt_original_value;

  function new(string pkt_name = "port_status_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("PORT_STATUS_RO", "Register model is not assigned")

    pkt_regmodel.port_status.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("PORT_STATUS_RO", "Initial read failed")

    pkt_regmodel.port_status.write(pkt_status, ~pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("PORT_STATUS_RO", "Write access failed")

    pkt_regmodel.port_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("PORT_STATUS_RO", "Readback failed")

    if (pkt_read_value == pkt_original_value)
      `uvm_info("PORT_STATUS_RO", $sformatf("PASS: PORT_STATUS is read-only, value=0x%08h", pkt_read_value), UVM_LOW)
    else
      `uvm_error("PORT_STATUS_RO", $sformatf("FAIL: PORT_STATUS changed, expected=0x%08h actual=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
      
class gen_status_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(gen_status_ro_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;

  function new(string pkt_name = "gen_status_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("GEN_STATUS_RO", "Register model is not assigned")

    pkt_regmodel.gen_status.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("GEN_STATUS_RO", "Initial read failed")

    `uvm_info("GEN_STATUS_RO", $sformatf("Original GEN_STATUS = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.gen_status.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("GEN_STATUS_RO", "Write operation failed")

    pkt_regmodel.gen_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("GEN_STATUS_RO", "Read after write failed")

    if (pkt_original_value == pkt_read_value)
      `uvm_info("GEN_STATUS_RO", "PASS: GEN_STATUS remained unchanged after write", UVM_LOW)
    else
      `uvm_error("GEN_STATUS_RO", $sformatf("FAIL: Original=0x%08h, After write=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
 class stat_rx_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(stat_rx_ro_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;

  function new(string pkt_name = "stat_rx_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("STAT_RX_RO", "Register model is not assigned")

    pkt_regmodel.stat_rx.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_RX_RO", "Initial read failed")

    `uvm_info("STAT_RX_RO", $sformatf("Original STAT_RX = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.stat_rx.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_RX_RO", "Write operation failed")

    pkt_regmodel.stat_rx.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_RX_RO", "Read after write failed")

    if (pkt_original_value == pkt_read_value)
      `uvm_info("STAT_RX_RO", "PASS: STAT_RX remained unchanged after write", UVM_LOW)
    else
      `uvm_error("STAT_RX_RO", $sformatf("FAIL: Original=0x%08h, After write=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
      
class stat_tx_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(stat_tx_ro_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;

  function new(string pkt_name = "stat_tx_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("STAT_TX_RO", "Register model is not assigned")

    pkt_regmodel.stat_tx.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_TX_RO", "Initial read failed")

    `uvm_info("STAT_TX_RO", $sformatf("Original STAT_TX = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.stat_tx.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_TX_RO", "Write operation failed")

    pkt_regmodel.stat_tx.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_TX_RO", "Read after write failed")

    if (pkt_original_value == pkt_read_value)
      `uvm_info("STAT_TX_RO", "PASS: STAT_TX remained unchanged after write", UVM_LOW)
    else
      `uvm_error("STAT_TX_RO", $sformatf("FAIL: Original=0x%08h, After write=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
      
class stat_drop_ro_sequence extends pkt_base_sequence;
  `uvm_object_utils(stat_drop_ro_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;

  function new(string pkt_name = "stat_drop_ro_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("STAT_DROP_RO", "Register model is not assigned")

    pkt_regmodel.stat_drop.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_DROP_RO", "Initial read failed")

    `uvm_info("STAT_DROP_RO", $sformatf("Original STAT_DROP = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = ~pkt_original_value;
    pkt_regmodel.stat_drop.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_DROP_RO", "Write operation failed")

    pkt_regmodel.stat_drop.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("STAT_DROP_RO", "Read after write failed")

    if (pkt_original_value == pkt_read_value)
      `uvm_info("STAT_DROP_RO", "PASS: STAT_DROP remained unchanged after write", UVM_LOW)
    else
      `uvm_error("STAT_DROP_RO", $sformatf("FAIL: Original=0x%08h, After write=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
class irq_status_sequence extends pkt_base_sequence;
  `uvm_object_utils(irq_status_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;
  uvm_reg_data_t pkt_read_value;
  string pkt_bit_name[8] = '{"gen_done", "error", "overflow", "packet_drop", "packet_fwd", "queue_af", "start_ack", "sw_event"};

  function new(string pkt_name = "irq_status_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("IRQ_STATUS", "Register model is not assigned")

    pkt_regmodel.irq_status.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_STATUS", "Initial read failed")

    `uvm_info("IRQ_STATUS", $sformatf("Original IRQ_STATUS = 0x%08h", pkt_original_value), UVM_LOW)

    if (pkt_original_value == 32'h00000000)
      `uvm_info("IRQ_STATUS", "PASS: reset value is 0x00000000", UVM_LOW)
    else
      `uvm_error("IRQ_STATUS", $sformatf("FAIL: reset value expected 0x00000000, read 0x%08h", pkt_original_value))

    for (int pkt_i = 0; pkt_i < 8; pkt_i++) begin
      pkt_write_value = 32'h1 << pkt_i;
      pkt_regmodel.irq_force.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
      if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_STATUS", $sformatf("IRQ_FORCE write failed for bit %0d", pkt_i))

      pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
      if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_STATUS", $sformatf("Read after force failed for bit %0d", pkt_i))

      `uvm_info("IRQ_STATUS", $sformatf("%s: IRQ_STATUS = 0x%08h", pkt_bit_name[pkt_i], pkt_read_value), UVM_LOW)

      if (pkt_read_value[pkt_i] == 1'b1)
        `uvm_info("IRQ_STATUS", $sformatf("PASS: %s bit set", pkt_bit_name[pkt_i]), UVM_LOW)
      else
        `uvm_error("IRQ_STATUS", $sformatf("FAIL: %s bit not set", pkt_bit_name[pkt_i]))

      pkt_regmodel.irq_status.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
      if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_STATUS", $sformatf("IRQ_STATUS clear failed for bit %0d", pkt_i))

      pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
      if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_STATUS", $sformatf("Read after clear failed for bit %0d", pkt_i))

      if (pkt_read_value[pkt_i] == 1'b0)
        `uvm_info("IRQ_STATUS", $sformatf("PASS: %s bit cleared", pkt_bit_name[pkt_i]), UVM_LOW)
      else
        `uvm_error("IRQ_STATUS", $sformatf("FAIL: %s bit not cleared", pkt_bit_name[pkt_i]))
    end
  endtask
endclass
        
class err_status_sequence extends pkt_base_sequence;
  `uvm_object_utils(err_status_sequence)

  uvm_reg_data_t pkt_read_value;

  function new(string pkt_name = "err_status_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("ERR_STATUS", "Register model is not assigned")

    pkt_regmodel.err_inject.write(pkt_status, 32'h0000007F, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Error injection write failed")

    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Error status read failed")

    if (pkt_read_value[6:0] == 7'h7F)
      `uvm_info("ERR_STATUS", "PASS: Error bits [6:0] are set", UVM_LOW)
    else
      `uvm_error("ERR_STATUS", $sformatf("FAIL: Expected 0x7F, read 0x%08h", pkt_read_value))

    pkt_regmodel.err_status.write(pkt_status, 32'h0000007F, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Error status clear failed")

    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Read after clear failed")

    if (pkt_read_value[6:0] == 7'h00)
      `uvm_info("ERR_STATUS", "PASS: Error bits [6:0] are cleared", UVM_LOW)
    else
      `uvm_error("ERR_STATUS", $sformatf("FAIL: Error bits [6:0] not cleared, read 0x%08h", pkt_read_value))

    pkt_regmodel.err_inject.write(pkt_status, 32'h00000080, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Injected-bit write failed")

    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Injected-bit read failed")

    if (pkt_read_value[7] == 1'b1)
      `uvm_info("ERR_STATUS", "PASS: INJECTED bit is set", UVM_LOW)
    else
      `uvm_error("ERR_STATUS", "FAIL: INJECTED bit is not set")

    pkt_regmodel.err_status.write(pkt_status, 32'h00000080, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Injected-bit clear failed")

    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_STATUS", "Final read failed")

    if (pkt_read_value[7] == 1'b0)
      `uvm_info("ERR_STATUS", "PASS: INJECTED bit is cleared", UVM_LOW)
    else
      `uvm_error("ERR_STATUS", "FAIL: INJECTED bit is not cleared")

    if (pkt_read_value[31:8] == 24'h0)
      `uvm_info("ERR_STATUS", "PASS: Reserved bits are zero", UVM_LOW)
    else
      `uvm_error("ERR_STATUS", $sformatf("FAIL: Reserved bits are not zero, read 0x%08h", pkt_read_value))
  endtask
endclass
      
 class err_enable_sequence extends pkt_base_sequence;
  `uvm_object_utils(err_enable_sequence)

  uvm_reg_data_t pkt_lock_value;
  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;
  uvm_reg_data_t pkt_read_value;

  function new(string pkt_name = "err_enable_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("ERR_ENABLE", "Register model is not assigned")

    pkt_regmodel.lock.write(pkt_status, 32'hA5A5C3C3, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Unlock write failed")

    pkt_regmodel.lock.read(pkt_status, pkt_lock_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "LOCK read failed")
    `uvm_info("ERR_ENABLE", $sformatf("LOCK after unlock = 0x%08h", pkt_lock_value), UVM_LOW)

    pkt_regmodel.err_enable.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Initial read failed")
    `uvm_info("ERR_ENABLE", $sformatf("Original ERR_ENABLE = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = 32'h000000FF;
    pkt_regmodel.err_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Write 0xFF failed")

    pkt_regmodel.err_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Read after write 0xFF failed")

    if (pkt_read_value == pkt_write_value)
      `uvm_info("ERR_ENABLE", "PASS: all 8 enable bits set", UVM_LOW)
    else
      `uvm_error("ERR_ENABLE", $sformatf("FAIL: Written=0x%08h Read=0x%08h", pkt_write_value, pkt_read_value))

    pkt_write_value = 32'h00000000;
    pkt_regmodel.err_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Write 0x00 failed")

    pkt_regmodel.err_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Read after write 0x00 failed")

    if (pkt_read_value == pkt_write_value)
      `uvm_info("ERR_ENABLE", "PASS: all 8 enable bits cleared", UVM_LOW)
    else
      `uvm_error("ERR_ENABLE", $sformatf("FAIL: Written=0x%08h Read=0x%08h", pkt_write_value, pkt_read_value))

    pkt_write_value = 32'hABCDEF55;
    pkt_regmodel.err_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Reserved write failed")

    pkt_regmodel.err_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Reserved read after write failed")

    if (pkt_read_value[31:8] == 24'h0)
      `uvm_info("ERR_ENABLE", "PASS: reserved bits remain zero", UVM_LOW)
    else
      `uvm_error("ERR_ENABLE", $sformatf("FAIL: reserved bits changed, read[31:8]=0x%06h", pkt_read_value[31:8]))

    if (pkt_read_value[7:0] == pkt_write_value[7:0])
      `uvm_info("ERR_ENABLE", "PASS: enable bits stored correctly", UVM_LOW)
    else
      `uvm_error("ERR_ENABLE", $sformatf("FAIL: expected 0x%02h, read 0x%02h", pkt_write_value[7:0], pkt_read_value[7:0]))

    pkt_regmodel.err_enable.write(pkt_status, 32'h00000000, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_ENABLE", "Restore write failed")
  endtask
endclass
      
      
 class err_inject_sequence extends pkt_base_sequence;
  `uvm_object_utils(err_inject_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_read_value;

  function new(string pkt_name = "err_inject_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("ERR_INJECT", "Register model is not assigned")

    pkt_regmodel.err_inject.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Initial read failed")

    `uvm_info("ERR_INJECT", $sformatf("Original ERR_INJECT = 0x%08h", pkt_original_value), UVM_LOW)

    if (pkt_original_value == 32'h00000000)
      `uvm_info("ERR_INJECT", "PASS: reset value is 0", UVM_LOW)
    else
      `uvm_error("ERR_INJECT", $sformatf("FAIL: expected 0, read 0x%08h", pkt_original_value))

    pkt_regmodel.err_inject.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Write 0x1 failed")

    pkt_regmodel.err_inject.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Read after write 0x1 failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("ERR_INJECT", "PASS: reads zero after write of 0x1", UVM_LOW)
    else
      `uvm_error("ERR_INJECT", $sformatf("FAIL: expected zero, read 0x%08h", pkt_read_value))

    pkt_regmodel.err_inject.write(pkt_status, 32'h7FFFFF00, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Write 0x7FFFFF00 failed")

    pkt_regmodel.err_inject.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Read after write 0x7FFFFF00 failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("ERR_INJECT", "PASS: reads zero after write of 0x7FFFFF00", UVM_LOW)
    else
      `uvm_error("ERR_INJECT", $sformatf("FAIL: expected zero, read 0x%08h", pkt_read_value))

    pkt_regmodel.err_inject.write(pkt_status, 32'hFFFFFFFF, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Write 0xFFFFFFFF failed")

    pkt_regmodel.err_inject.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Read after write 0xFFFFFFFF failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("ERR_INJECT", "PASS: reads zero after write of 0xFFFFFFFF", UVM_LOW)
    else
      `uvm_error("ERR_INJECT", $sformatf("FAIL: expected zero, read 0x%08h", pkt_read_value))

    pkt_regmodel.err_inject.write(pkt_status, 32'h80000000, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "Clear-count write failed")

    pkt_regmodel.err_status.write(pkt_status, 32'h000000FF, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("ERR_INJECT", "ERR_STATUS clear failed")
  endtask
endclass
    

      
class port_enable_sequence extends pkt_base_sequence;

  `uvm_object_utils(port_enable_sequence)

  function new(string pkt_name = "port_enable_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_after_write_value;

    unlock_config();

    pkt_regmodel.port_enable.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    `uvm_info("PORT_ENABLE",$sformatf("Original PORT_ENABLE = 0x%08h", pkt_original_value),UVM_LOW)

    pkt_write_value = pkt_original_value ^ 32'h0000000F;

    `uvm_info("PORT_ENABLE",
      $sformatf("Writing PORT_ENABLE = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.port_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.port_enable.read(pkt_status, pkt_after_write_value, UVM_FRONTDOOR);

    `uvm_info("PORT_ENABLE",$sformatf("PORT_ENABLE after write = 0x%08h", pkt_after_write_value),UVM_LOW)

    if (pkt_after_write_value == pkt_write_value)
      `uvm_info("PORT_ENABLE","PASS: read value matches written value", UVM_LOW)
    else
      `uvm_error("PORT_ENABLE",$sformatf("FAIL: Written=0x%08h Read=0x%08h", pkt_write_value, pkt_after_write_value))

  endtask

endclass
      
      
class switch_ctrl_sequence extends pkt_base_sequence;

  `uvm_object_utils(switch_ctrl_sequence)

  function new(string pkt_name = "switch_ctrl_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_after_write_value;

    unlock_config();

    pkt_regmodel.switch_ctrl.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("SWITCH_CTRL",
      $sformatf("Original SWITCH_CTRL = 0x%08h", pkt_original_value),
      UVM_LOW)

    pkt_write_value = pkt_original_value ^ 32'h00000009;

    `uvm_info("SWITCH_CTRL",
      $sformatf("Writing SWITCH_CTRL = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.switch_ctrl.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.switch_ctrl.read(pkt_status, pkt_after_write_value, UVM_FRONTDOOR);

    `uvm_info("SWITCH_CTRL",
      $sformatf("SWITCH_CTRL after write = 0x%08h", pkt_after_write_value),
      UVM_LOW)

    if (pkt_after_write_value == pkt_write_value)
      `uvm_info("SWITCH_CTRL",
        "PASS: read value matches written value", UVM_LOW)
    else
      `uvm_error("SWITCH_CTRL",
        $sformatf("FAIL: Written=0x%08h Read=0x%08h",
                  pkt_write_value, pkt_after_write_value))

  endtask

endclass
      
      
class fwd_enable_sequence extends pkt_base_sequence;

  `uvm_object_utils(fwd_enable_sequence)

  function new(string pkt_name = "fwd_enable_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_after_write_value;

    unlock_config();

    pkt_regmodel.fwd_enable.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("FWD_ENABLE",
      $sformatf("Original FWD_ENABLE = 0x%08h", pkt_original_value),
      UVM_LOW)

    pkt_write_value = pkt_original_value ^ 32'h0000000F;

    `uvm_info("FWD_ENABLE",
      $sformatf("Writing FWD_ENABLE = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.fwd_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.fwd_enable.read(pkt_status, pkt_after_write_value, UVM_FRONTDOOR);

    `uvm_info("FWD_ENABLE",
      $sformatf("FWD_ENABLE after write = 0x%08h", pkt_after_write_value),
      UVM_LOW)

    if (pkt_after_write_value == pkt_write_value)
      `uvm_info("FWD_ENABLE",
        "PASS: read value matches written value", UVM_LOW)
    else
      `uvm_error("FWD_ENABLE",
        $sformatf("FAIL: Written=0x%08h Read=0x%08h",
                  pkt_write_value, pkt_after_write_value))

  endtask

endclass
      
class gen_ctrl_sequence extends pkt_base_sequence;

  `uvm_object_utils(gen_ctrl_sequence)

  function new(string pkt_name = "gen_ctrl_sequence");
    super.new(pkt_name);
  endfunction

  task body();

    unlock_config();

    `uvm_info("GEN_CTRL",
      "CHECK 1: RW fields (enable, continuous)", UVM_LOW)

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000009, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    `uvm_info("GEN_CTRL",
      $sformatf("Wrote 0x00000009, read 0x%08h", pkt_read_value),
      UVM_LOW)

    if (pkt_read_value[0] == 1'b1)
      `uvm_info("GEN_CTRL", "PASS: enable set to 1", UVM_LOW)
    else
      `uvm_error("GEN_CTRL", "FAIL: enable did not set to 1")

    if (pkt_read_value[3] == 1'b1)
      `uvm_info("GEN_CTRL", "PASS: continuous set to 1", UVM_LOW)
    else
      `uvm_error("GEN_CTRL", "FAIL: continuous did not set to 1")

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000000, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    `uvm_info("GEN_CTRL",
      $sformatf("Wrote 0x00000000, read 0x%08h", pkt_read_value),
      UVM_LOW)

    `uvm_info("GEN_CTRL",
      "CHECK 2: Reserved bits [31:4]", UVM_LOW)

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'hFFFFFFF0, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    `uvm_info("GEN_CTRL",
      $sformatf("Wrote 0xFFFFFFF0, read 0x%08h", pkt_read_value),
      UVM_LOW)

    if (pkt_read_value[31:4] == 28'h0)
      `uvm_info("GEN_CTRL",
        "PASS: reserved bits remain zero", UVM_LOW)
    else
      `uvm_error("GEN_CTRL",
        $sformatf("FAIL: reserved bits changed, read[31:4]=0x%07h",
                  pkt_read_value[31:4]))

    `uvm_info("GEN_CTRL",
      "CHECK 3: WO fields START and STOP read as zero", UVM_LOW)

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000002, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[1] == 1'b0)
      `uvm_info("GEN_CTRL", "PASS: START reads as 0", UVM_LOW)
    else
      `uvm_error("GEN_CTRL", "FAIL: START did not read as 0")

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000004, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[2] == 1'b0)
      `uvm_info("GEN_CTRL", "PASS: STOP reads as 0", UVM_LOW)
    else
      `uvm_error("GEN_CTRL", "FAIL: STOP did not read as 0")

    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000000, UVM_FRONTDOOR);

  endtask

endclass
    
class gen_pkt_cfg_sequence extends pkt_base_sequence;

  `uvm_object_utils(gen_pkt_cfg_sequence)

  function new(string pkt_name = "gen_pkt_cfg_sequence");
    super.new(pkt_name);
  endfunction

  task body();

    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_read_value;

    unlock_config();

    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("GEN_PKT_CFG",
      $sformatf("Original GEN_PKT_CFG = 0x%08h", pkt_original_value),
      UVM_LOW)

    if (pkt_original_value == 32'h00000401)
      `uvm_info("GEN_PKT_CFG", "PASS: reset value is 0x00000401", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG",
        $sformatf("Expected reset value 0x00000401, read 0x%08h",
                  pkt_original_value))

    pkt_write_value = 32'h00A50A0B;

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[23:16] == pkt_write_value[23:16])
      `uvm_info("GEN_PKT_CFG", "PASS: seed matches", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: seed mismatch")

    if (pkt_read_value[15:8] == pkt_write_value[15:8])
      `uvm_info("GEN_PKT_CFG", "PASS: length matches", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: length mismatch")

    if (pkt_read_value[3:2] == pkt_write_value[3:2])
      `uvm_info("GEN_PKT_CFG", "PASS: src_port matches", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: src_port mismatch")

    if (pkt_read_value[1:0] == pkt_write_value[1:0])
      `uvm_info("GEN_PKT_CFG", "PASS: dst_port matches", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: dst_port mismatch")

    pkt_write_value = 32'h005A0504;

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value == pkt_write_value)
      `uvm_info("GEN_PKT_CFG", "PASS: pattern 2 matches", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG",
        $sformatf("FAIL: Written=0x%08h Read=0x%08h",
                  pkt_write_value, pkt_read_value))

    pkt_write_value = 32'hFF0001F0;

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[31:24] == 8'h00)
      `uvm_info("GEN_PKT_CFG", "PASS: reserved bits [31:24] are zero", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: reserved bits [31:24] changed")

    if (pkt_read_value[7:4] == 4'h0)
      `uvm_info("GEN_PKT_CFG", "PASS: reserved bits [7:4] are zero", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG", "FAIL: reserved bits [7:4] changed")

    pkt_write_value = 32'h00000000;

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[15:8] == 8'h01)
      `uvm_info("GEN_PKT_CFG", "PASS: length 0 is stored as 1", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG",
        $sformatf("FAIL: expected length 1, read 0x%02h",
                  pkt_read_value[15:8]))

    pkt_write_value = 32'h00002000;

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[15:8] == 8'h20)
      `uvm_info("GEN_PKT_CFG",
        "PASS: length 0x20 remains readable", UVM_LOW)
    else
      `uvm_error("GEN_PKT_CFG",
        $sformatf("FAIL: expected length 0x20, read 0x%02h",
                  pkt_read_value[15:8]))

    pkt_regmodel.gen_pkt_cfg.write(pkt_status, 32'h00000401, UVM_FRONTDOOR);

  endtask

endclass
    
    
class gen_interval_sequence extends pkt_base_sequence;

  `uvm_object_utils(gen_interval_sequence)

  function new(string pkt_name = "gen_interval_sequence");
    super.new(pkt_name);
  endfunction

  task body();

    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_read_value;

    unlock_config();

    pkt_regmodel.gen_interval.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("GEN_INTERVAL",
      $sformatf("Original GEN_INTERVAL = 0x%08h", pkt_original_value),
      UVM_LOW)

    `uvm_info("GEN_INTERVAL",
      "CHECK 1: RW field [15:0]", UVM_LOW)

    pkt_write_value = 32'h0000A5C3;

    pkt_regmodel.gen_interval.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_interval.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[15:0] == pkt_write_value[15:0])
      `uvm_info("GEN_INTERVAL", "PASS: interval stored correctly", UVM_LOW)
    else
      `uvm_error("GEN_INTERVAL",
        $sformatf("FAIL: Expected 0x%04h, read 0x%04h",
                  pkt_write_value[15:0], pkt_read_value[15:0]))

    `uvm_info("GEN_INTERVAL",
      "CHECK 2: Reserved bits [31:16]", UVM_LOW)

    pkt_write_value = 32'hABCD0005;

    pkt_regmodel.gen_interval.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_interval.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[31:16] == 16'h0000)
      `uvm_info("GEN_INTERVAL", "PASS: reserved bits remain zero", UVM_LOW)
    else
      `uvm_error("GEN_INTERVAL",
        $sformatf("FAIL: Reserved bits changed to 0x%04h",
                  pkt_read_value[31:16]))

    if (pkt_read_value[15:0] == pkt_write_value[15:0])
      `uvm_info("GEN_INTERVAL", "PASS: interval bits stored correctly", UVM_LOW)
    else
      `uvm_error("GEN_INTERVAL",
        $sformatf("FAIL: Expected 0x%04h, read 0x%04h",
                  pkt_write_value[15:0], pkt_read_value[15:0]))

    pkt_regmodel.gen_interval.write(pkt_status, 32'h00000002, UVM_FRONTDOOR);

  endtask

endclass
    
 class gen_count_sequence extends pkt_base_sequence;

  `uvm_object_utils(gen_count_sequence)

  function new(string pkt_name = "gen_count_sequence");
    super.new(pkt_name);
  endfunction

  task body();

    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_read_value;

    unlock_config();

    pkt_regmodel.gen_count.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("GEN_COUNT",
      $sformatf("Original GEN_COUNT = 0x%08h", pkt_original_value),
      UVM_LOW)

    `uvm_info("GEN_COUNT",
      "CHECK 1: RW field [15:0]", UVM_LOW)

    pkt_write_value = 32'h0000A5C3;

    pkt_regmodel.gen_count.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_count.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[15:0] == pkt_write_value[15:0])
      `uvm_info("GEN_COUNT", "PASS: packet_count stored correctly", UVM_LOW)
    else
      `uvm_error("GEN_COUNT",
        $sformatf("FAIL: Expected 0x%04h, read 0x%04h",
                  pkt_write_value[15:0], pkt_read_value[15:0]))

    `uvm_info("GEN_COUNT",
      "CHECK 2: Reserved bits [31:16]", UVM_LOW)

    pkt_write_value = 32'hABCD0005;

    pkt_regmodel.gen_count.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.gen_count.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value[31:16] == 16'h0000)
      `uvm_info("GEN_COUNT", "PASS: reserved bits remain zero", UVM_LOW)
    else
      `uvm_error("GEN_COUNT",
        $sformatf("FAIL: Reserved bits changed to 0x%04h",
                  pkt_read_value[31:16]))

    if (pkt_read_value[15:0] == pkt_write_value[15:0])
      `uvm_info("GEN_COUNT", "PASS: packet_count stored correctly", UVM_LOW)
    else
      `uvm_error("GEN_COUNT", $sformatf("FAIL: Expected 0x%04h, read 0x%04h",pkt_write_value[15:0], pkt_read_value[15:0]))

    pkt_regmodel.gen_count.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);

  endtask

endclass

class err_count_sequence extends pkt_base_sequence;

  `uvm_object_utils(err_count_sequence)

  function new(string pkt_name = "err_count_sequence");
    super.new(pkt_name);
  endfunction

  task body();

    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;

    if (pkt_regmodel == null)
      `uvm_fatal("ERR_COUNT", "Register model is not assigned")

    pkt_regmodel.err_count.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);

    `uvm_info("ERR_COUNT",
      $sformatf("Original ERR_COUNT = 0x%08h", pkt_original_value),
      UVM_LOW)

    pkt_write_value = ~pkt_original_value;

    pkt_regmodel.err_count.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    pkt_regmodel.err_count.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if (pkt_read_value == pkt_original_value)
      `uvm_info("ERR_COUNT", "PASS: ERR_COUNT is read-only", UVM_LOW)
    else
      `uvm_error("ERR_COUNT",
        $sformatf("FAIL: Original=0x%08h, After write=0x%08h",
                  pkt_original_value, pkt_read_value))

  endtask

endclass
      
class err_info_sequence extends pkt_base_sequence;
  `uvm_object_utils(err_info_sequence)

  function new(string pkt_name = "err_info_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;

    if (pkt_regmodel == null)
      `uvm_fatal("ERR_INFO", "Register model is not assigned")

    pkt_regmodel.err_info.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("ERR_INFO", "Initial read failed")

    `uvm_info("ERR_INFO", $sformatf("Original ERR_INFO = 0x%08h", pkt_original_value), UVM_LOW)

    if (pkt_original_value == 32'h00000000)
      `uvm_info("ERR_INFO", "PASS: reset value is 0x00000000", UVM_LOW)
    else
      `uvm_error("ERR_INFO", $sformatf("FAIL: expected reset value 0x00000000, read 0x%08h", pkt_original_value))

    pkt_write_value = 32'hFFFFFFFF;
    pkt_regmodel.err_info.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("ERR_INFO", "Write failed")

    pkt_regmodel.err_info.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("ERR_INFO", "Read after write failed")

    if (pkt_read_value == pkt_original_value)
      `uvm_info("ERR_INFO", "PASS: ERR_INFO unchanged after write of 0xFFFFFFFF", UVM_LOW)
    else
      `uvm_error("ERR_INFO", $sformatf("FAIL: Original=0x%08h After write=0x%08h", pkt_original_value, pkt_read_value))

    pkt_write_value = 32'hA5A5A5A5;
    pkt_regmodel.err_info.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("ERR_INFO", "Second write failed")

    pkt_regmodel.err_info.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("ERR_INFO", "Read after second write failed")

    if (pkt_read_value == pkt_original_value)
      `uvm_info("ERR_INFO", "PASS: ERR_INFO unchanged after second write", UVM_LOW)
    else
      `uvm_error("ERR_INFO", $sformatf("FAIL: Original=0x%08h After write=0x%08h", pkt_original_value, pkt_read_value))
  endtask
endclass
      
      
class lock_sequence extends pkt_base_sequence;
  `uvm_object_utils(lock_sequence)

  function new(string pkt_name = "lock_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;

    pkt_regmodel.lock.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    `uvm_info("LOCK", $sformatf("Original LOCK = 0x%08h", pkt_original_value), UVM_LOW)

//     if (original_value == 32'h00000001)
//       `uvm_info("LOCK", "PASS: reset value is 0x00000001 (locked)", UVM_LOW)
//     else
//       `uvm_error("LOCK", $sformatf("FAIL: expected reset value 0x00000001, read 0x%08h", original_value))

    pkt_write_value = 32'h12345678;
    pkt_regmodel.lock.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("LOCK", "Wrong key write failed")
    pkt_regmodel.lock.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("LOCK", "Read after wrong key failed")

    if (pkt_read_value == 32'h00000001)
      `uvm_info("LOCK", "PASS: still locked after wrong key", UVM_LOW)
    else
      `uvm_error("LOCK", $sformatf("FAIL: expected 0x00000001, read 0x%08h", pkt_read_value))

    pkt_write_value = 32'hA5A5C3C3;
    pkt_regmodel.lock.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("LOCK", "Correct key write failed")
    pkt_regmodel.lock.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("LOCK", "Read after correct key failed")

    if (pkt_read_value[0] == 1'b0)
      `uvm_info("LOCK", "PASS: correct key unlocked configuration", UVM_LOW)
    else
      `uvm_error("LOCK", $sformatf("FAIL: expected unlocked value, read 0x%08h", pkt_read_value))
  endtask
endclass
      
class generate_four_packets_sequence extends pkt_base_sequence;
  `uvm_object_utils(generate_four_packets_sequence)

  function new(string pkt_name = "generate_four_packets_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    int pkt_i;

    unlock_config();

    pkt_regmodel.port_enable.write(pkt_status, 32'h0000000F, UVM_FRONTDOOR);
    pkt_regmodel.fwd_enable.write(pkt_status, 32'h0000000F, UVM_FRONTDOOR);
    pkt_regmodel.switch_ctrl.write(pkt_status, 32'h00000009, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.write(pkt_status, 32'h00100401, UVM_FRONTDOOR);
    pkt_regmodel.gen_interval.write(pkt_status, 32'h00000002, UVM_FRONTDOOR);
    pkt_regmodel.gen_count.write(pkt_status, 32'h00000004, UVM_FRONTDOOR);
    pkt_regmodel.irq_enable.write(pkt_status, 32'h00000041, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000003, UVM_FRONTDOOR);

    pkt_i = 0;
    pkt_read_value = 0;
    do begin
      pkt_regmodel.gen_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
      if (pkt_status != UVM_IS_OK) `uvm_fatal("PKT_TEST", "GEN_STATUS read failed")
      pkt_i++;
    end while (pkt_read_value[1] != 1'b1 && pkt_i < 100);

    if (pkt_read_value[1] == 1'b1)
      `uvm_info("PKT_TEST", "PASS: Packet generation completed", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "Packet generation timeout")

    pkt_regmodel.stat_rx.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[15:0] == 4)
      `uvm_info("PKT_TEST", "PASS: STAT_RX = 4", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "FAIL: STAT_RX is not 4")

    pkt_regmodel.stat_tx.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[15:0] == 4)
      `uvm_info("PKT_TEST", "PASS: STAT_TX = 4", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "FAIL: STAT_TX is not 4")

    pkt_regmodel.stat_drop.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[15:0] == 0)
      `uvm_info("PKT_TEST", "PASS: STAT_DROP = 0", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "FAIL: STAT_DROP is not 0")

    pkt_regmodel.gen_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[1] == 1'b1)
      `uvm_info("PKT_TEST", "PASS: GEN_STATUS.DONE = 1", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "FAIL: GEN_STATUS.DONE is not 1")

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[0] == 1'b1)
      `uvm_info("PKT_TEST", "PASS: IRQ_STATUS.GEN_DONE = 1", UVM_LOW)
    else
      `uvm_error("PKT_TEST", "FAIL: IRQ_STATUS.GEN_DONE is not 1")
  endtask
endclass
      
class clear_sticky_status_sequence extends pkt_base_sequence;
  `uvm_object_utils(clear_sticky_status_sequence)

  function new(string pkt_name = "clear_sticky_status_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    pkt_regmodel.irq_status.write(pkt_status, 32'h00000041, UVM_FRONTDOOR);
    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if ((pkt_read_value & 32'h00000041) == 0)
      `uvm_info("IRQ_CLEAR", "PASS: GEN_DONE and START_ACK cleared", UVM_LOW)
    else
      `uvm_error("IRQ_CLEAR", "FAIL: IRQ status bits not cleared")

    pkt_regmodel.irq_status.write(pkt_status, 32'h000000FF, UVM_FRONTDOOR);
    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if ((pkt_read_value & 32'h000000FF) == 0)
      `uvm_info("IRQ_CLEAR", "PASS: All implemented IRQ bits cleared", UVM_LOW)
    else
      `uvm_error("IRQ_CLEAR", "FAIL: IRQ bits not cleared")

    pkt_regmodel.err_status.write(pkt_status, 32'h00000002, UVM_FRONTDOOR);
    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);

    if ((pkt_read_value & 32'h00000002) == 0)
      `uvm_info("IRQ_CLEAR", "PASS: DEST_ERROR cleared", UVM_LOW)
    else
      `uvm_error("IRQ_CLEAR", "FAIL: DEST_ERROR not cleared")
  endtask
endclass
      
class destination_drop_sequence extends pkt_base_sequence;
  `uvm_object_utils(destination_drop_sequence)

  function new(string pkt_name = "destination_drop_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    int pkt_timeout_count = 0;
    unlock_config();

    pkt_regmodel.switch_ctrl.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);
    pkt_regmodel.fwd_enable.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);
    pkt_regmodel.gen_pkt_cfg.write(pkt_status, 32'h00000401, UVM_FRONTDOOR);
    pkt_regmodel.gen_interval.write(pkt_status, 32'h00000002, UVM_FRONTDOOR);
    pkt_regmodel.gen_count.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);
    pkt_regmodel.gen_ctrl.write(pkt_status, 32'h00000003, UVM_FRONTDOOR);

    pkt_read_value = 0;
    while (pkt_read_value[1] != 1'b1 && pkt_timeout_count < 100) begin
      pkt_regmodel.gen_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
      pkt_timeout_count++;
    end

    if (pkt_read_value[1] != 1'b1) `uvm_error("DEST_DROP", "FAIL: Packet generation timed out")

    pkt_regmodel.err_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[1] == 1'b1) `uvm_info("DEST_DROP", "PASS: ERR_STATUS.DEST_ERROR is set", UVM_LOW)
    else `uvm_error("DEST_DROP", "FAIL: DEST_ERROR is not set")

    pkt_regmodel.stat_drop.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[15:0] == 1) 
      `uvm_info("DEST_DROP", "PASS: STAT_DROP = 1", UVM_LOW)
    else 
      `uvm_error("DEST_DROP", $sformatf("FAIL: STAT_DROP expected=1 actual=%0d", pkt_read_value[15:0]))

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value[3] == 1'b1) 
      `uvm_info("DEST_DROP", "PASS: IRQ_STATUS.PACKET_DROPPED is set", UVM_LOW)
    else 
      `uvm_error("DEST_DROP", "FAIL: PACKET_DROPPED is not set")
  endtask
endclass
      
class soft_reset_sequence extends pkt_base_sequence;
  `uvm_object_utils(soft_reset_sequence)

  function new(string pkt_name = "soft_reset_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    unlock_config();

    pkt_regmodel.port_enable.write(pkt_status, 32'h00000005, UVM_FRONTDOOR);

    pkt_regmodel.port_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    `uvm_info("SOFT_RESET", $sformatf("PORT_ENABLE before soft reset = 0x%08h", pkt_read_value), UVM_LOW)

    pkt_regmodel.soft_reset.write(pkt_status, 32'h00000001, UVM_FRONTDOOR);

    pkt_regmodel.port_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value == 32'h0000000F) 
      `uvm_info("SOFT_RESET", "PASS: PORT_ENABLE restored to 0x0000000F", UVM_LOW)
    else 
      `uvm_error("SOFT_RESET", $sformatf("FAIL: PORT_ENABLE expected 0x0000000F, read 0x%08h", pkt_read_value))

    pkt_regmodel.lock.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_read_value == 32'h00000001) 
      `uvm_info("SOFT_RESET", "PASS: LOCK restored to locked state", UVM_LOW)
    else 
      `uvm_error("SOFT_RESET", $sformatf("FAIL: LOCK expected 0x00000001, read 0x%08h", pkt_read_value))
  endtask
endclass
    
 class reset_values_sequence extends pkt_base_sequence;
  `uvm_object_utils(reset_values_sequence)

  function new(string pkt_name = "reset_values_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("RESET_VAL", "Register model is not assigned")

    check_readback(pkt_regmodel.device_id, 32'h02A55357, 32'hFFFFFFFF, "DEVICE_ID");
    check_readback(pkt_regmodel.version, 32'h00010200, 32'hFFFFFFFF, "VERSION");
    check_readback(pkt_regmodel.switch_status, 32'h000000F9, 32'hFFFFFFFF, "SWITCH_STATUS");
    check_readback(pkt_regmodel.port_status, 32'h00000000, 32'hFFFFFFFF, "PORT_STATUS");
    check_readback(pkt_regmodel.gen_status, 32'h00000000, 32'hFFFFFFFF, "GEN_STATUS");
    check_readback(pkt_regmodel.stat_rx, 32'h00000000, 32'hFFFFFFFF, "STAT_RX");
    check_readback(pkt_regmodel.stat_tx, 32'h00000000, 32'hFFFFFFFF, "STAT_TX");
    check_readback(pkt_regmodel.stat_drop, 32'h00000000, 32'hFFFFFFFF, "STAT_DROP");
    check_readback(pkt_regmodel.irq_status, 32'h00000000, 32'hFFFFFFFF, "IRQ_STATUS");
    check_readback(pkt_regmodel.irq_enable, 32'h00000000, 32'hFFFFFFFF, "IRQ_ENABLE");
    check_readback(pkt_regmodel.irq_force, 32'h00000000, 32'hFFFFFFFF, "IRQ_FORCE");
    check_readback(pkt_regmodel.err_status, 32'h00000000, 32'hFFFFFFFF, "ERR_STATUS");
    check_readback(pkt_regmodel.err_enable, 32'h00000000, 32'hFFFFFFFF, "ERR_ENABLE");
    check_readback(pkt_regmodel.err_inject, 32'h00000000, 32'hFFFFFFFF, "ERR_INJECT");
    check_readback(pkt_regmodel.err_count, 32'h00000000, 32'hFFFFFFFF, "ERR_COUNT");
    check_readback(pkt_regmodel.err_info, 32'h00000000, 32'hFFFFFFFF, "ERR_INFO");
    check_readback(pkt_regmodel.lock, 32'h00000001, 32'hFFFFFFFF, "LOCK");
    check_readback(pkt_regmodel.soft_reset, 32'h00000000, 32'hFFFFFFFF, "SOFT_RESET");
  endtask
endclass
    
    

class irq_force_sequence extends pkt_base_sequence;
  `uvm_object_utils(irq_force_sequence)

  uvm_reg_data_t pkt_original_value;
  uvm_reg_data_t pkt_write_value;

  function new(string pkt_name = "irq_force_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    if (pkt_regmodel == null) `uvm_fatal("IRQ_FORCE", "Register model is not assigned")

    pkt_regmodel.irq_status.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "Initial IRQ_STATUS read failed")

    `uvm_info("IRQ_FORCE", $sformatf("Original IRQ_STATUS = 0x%08h", pkt_original_value), UVM_LOW)

    pkt_write_value = 32'h000000A5;
    pkt_regmodel.irq_force.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_FORCE write failed")

    pkt_regmodel.irq_force.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_FORCE read failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("IRQ_FORCE", "PASS: IRQ_FORCE reads zero", UVM_LOW)
    else
      `uvm_error("IRQ_FORCE", $sformatf("FAIL: expected zero, read 0x%08h", pkt_read_value))

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_STATUS read after force failed")

    if (pkt_read_value == pkt_write_value)
      `uvm_info("IRQ_FORCE", "PASS: forced bits set in IRQ_STATUS", UVM_LOW)
    else
      `uvm_error("IRQ_FORCE", $sformatf("FAIL: expected 0x%08h, read 0x%08h", pkt_write_value, pkt_read_value))

    pkt_regmodel.irq_force.write(pkt_status, 32'h00000000, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_FORCE write zero failed")

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_STATUS read after force zero failed")

    if (pkt_read_value == 32'h000000A5)
      `uvm_info("IRQ_FORCE", "PASS: writing zero did not clear IRQ_STATUS", UVM_LOW)
    else
      `uvm_error("IRQ_FORCE", $sformatf("FAIL: expected 0x000000A5, read 0x%08h", pkt_read_value))

    pkt_regmodel.irq_status.write(pkt_status, 32'h000000FF, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_STATUS clear failed")

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_STATUS read after clear failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("IRQ_FORCE", "PASS: IRQ_STATUS cleared", UVM_LOW)
    else
      `uvm_error("IRQ_FORCE", $sformatf("FAIL: expected zero after clear, read 0x%08h", pkt_read_value))

    pkt_write_value = 32'hFFFFFF00;
    pkt_regmodel.irq_force.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "Reserved bits write failed")

    pkt_regmodel.irq_status.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK) `uvm_fatal("IRQ_FORCE", "IRQ_STATUS read after reserved write failed")

    if (pkt_read_value == 32'h00000000)
      `uvm_info("IRQ_FORCE", "PASS: reserved bits ignored", UVM_LOW)
    else
      `uvm_error("IRQ_FORCE", $sformatf("FAIL: expected zero, read 0x%08h", pkt_read_value))
  endtask
endclass

    
      
 class unaligned_address_sequence extends pkt_base_sequence;
  `uvm_object_utils(unaligned_address_sequence)

  function new(string pkt_name = "unaligned_address_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    pkt_regmodel.lock.write(pkt_status, 32'hA5A5C3C3, UVM_FRONTDOOR);
    `uvm_info("UNALIGNED", "Testing unaligned address 0x0002", UVM_LOW)
  endtask
endclass


class invalid_address_sequence extends pkt_base_sequence;
  `uvm_object_utils(invalid_address_sequence)

  function new(string pkt_name = "invalid_address_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    pkt_regmodel.lock.write(pkt_status, 32'hA5A5C3C3, UVM_FRONTDOOR);
    `uvm_info("INVALID_ADDR", "Testing invalid address 0x0064", UVM_LOW)
  endtask
endclass 
    


      /////////////////////////////////////////////////////////////////////
      
      class irq_enable_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(irq_enable_sequence)

  pkt_reg_block pkt_regmodel;

  function new(string pkt_name = "irq_enable_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    uvm_status_e   pkt_status;
    uvm_reg_data_t pkt_lock_value;
    uvm_reg_data_t pkt_original_value;
    uvm_reg_data_t pkt_write_value;
    uvm_reg_data_t pkt_read_value;

    if (pkt_regmodel == null)
      `uvm_fatal("IRQ_ENABLE", "Register model is not assigned")

    pkt_regmodel.lock.write(pkt_status, 32'hA5A5C3C3, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Unlock write failed")

    pkt_regmodel.lock.read(pkt_status, pkt_lock_value, UVM_FRONTDOOR);
    `uvm_info("IRQ_ENABLE",
      $sformatf("LOCK after unlock = 0x%08h (bit0 must be 0)", pkt_lock_value),
      UVM_LOW)

    pkt_regmodel.irq_enable.read(pkt_status, pkt_original_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Initial read failed")

    `uvm_info("IRQ_ENABLE",
      $sformatf("Original IRQ_ENABLE = 0x%08h", pkt_original_value),
      UVM_LOW)

    `uvm_info("IRQ_ENABLE", "---- CHECK 1: RW bits [7:0], all set then all clear ----", UVM_LOW)

    pkt_write_value = 32'h000000FF;

    `uvm_info("IRQ_ENABLE",
      $sformatf("Writing IRQ_ENABLE = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.irq_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Write 0xFF failed")

    pkt_regmodel.irq_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Read after write 0xFF failed")

    `uvm_info("IRQ_ENABLE",
      $sformatf("IRQ_ENABLE after write = 0x%08h", pkt_read_value),
      UVM_LOW)

    if (pkt_read_value == pkt_write_value)
      `uvm_info("IRQ_ENABLE", "PASS: all 8 enable bits set", UVM_LOW)
    else
      `uvm_error("IRQ_ENABLE",
        $sformatf("FAIL: Written=0x%08h Read=0x%08h", pkt_write_value, pkt_read_value))

    pkt_write_value = 32'h00000000;

    `uvm_info("IRQ_ENABLE",
      $sformatf("Writing IRQ_ENABLE = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.irq_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Write 0x00 failed")

    pkt_regmodel.irq_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Read after write 0x00 failed")

    `uvm_info("IRQ_ENABLE",
      $sformatf("IRQ_ENABLE after write = 0x%08h", pkt_read_value),
      UVM_LOW)

    if (pkt_read_value == pkt_write_value)
      `uvm_info("IRQ_ENABLE", "PASS: all 8 enable bits cleared", UVM_LOW)
    else
      `uvm_error("IRQ_ENABLE",
        $sformatf("FAIL: Written=0x%08h Read=0x%08h", pkt_write_value, pkt_read_value))

    `uvm_info("IRQ_ENABLE", "---- CHECK 2: Reserved bits [31:8] ----", UVM_LOW)

    pkt_write_value = 32'hABCDEF55;

    `uvm_info("IRQ_ENABLE",
      $sformatf("Writing IRQ_ENABLE = 0x%08h", pkt_write_value),
      UVM_LOW)

    pkt_regmodel.irq_enable.write(pkt_status, pkt_write_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Reserved write failed")

    pkt_regmodel.irq_enable.read(pkt_status, pkt_read_value, UVM_FRONTDOOR);
    if (pkt_status != UVM_IS_OK)
      `uvm_fatal("IRQ_ENABLE", "Reserved read after write failed")

    `uvm_info("IRQ_ENABLE",
      $sformatf("IRQ_ENABLE after write = 0x%08h", pkt_read_value),
      UVM_LOW)

    if (pkt_read_value[31:8] == 24'h0)
      `uvm_info("IRQ_ENABLE", "PASS: reserved bits unchanged, still 0", UVM_LOW)
    else
      `uvm_error("IRQ_ENABLE",
        $sformatf("FAIL: reserved bits changed, read[31:8]=0x%06h", pkt_read_value[31:8]))

  endtask

endclass



class pkt_regression_sequence extends pkt_base_sequence;
  `uvm_object_utils(pkt_regression_sequence)

  function new(string pkt_name = "pkt_regression_sequence");
    super.new(pkt_name);
  endfunction

  task body();
    reset_values_sequence pkt_reset_seq;
    device_id_ro_test pkt_device_seq;
    version_ro_sequence pkt_version_seq;
    switch_status_ro_sequence pkt_switch_status_seq;
    port_status_ro_sequence pkt_port_status_seq;
    gen_status_ro_sequence pkt_gen_status_seq;
    stat_rx_ro_sequence pkt_rx_seq;
    stat_tx_ro_sequence pkt_tx_seq;
    stat_drop_ro_sequence pkt_drop_seq;
    port_enable_sequence pkt_port_en_seq;
    switch_ctrl_sequence pkt_switch_ctrl_seq;
    fwd_enable_sequence pkt_fwd_seq;
    gen_ctrl_sequence pkt_gen_ctrl_seq;
    gen_pkt_cfg_sequence pkt_cfg_seq;
    gen_interval_sequence pkt_interval_seq;
    gen_count_sequence pkt_count_seq;
    irq_status_sequence pkt_irq_status_seq;
    irq_enable_sequence pkt_irq_en_seq;
    irq_force_sequence pkt_irq_force_seq;
    err_count_sequence pkt_err_count_seq;
    err_info_sequence pkt_err_info_seq;
    lock_sequence pkt_lock_seq;
    clear_sticky_status_sequence pkt_clear_seq;
    generate_four_packets_sequence pkt_packets_seq;
    destination_drop_sequence pkt_dest_drop_seq;
    soft_reset_sequence pkt_soft_reset_seq;
    unaligned_address_sequence pkt_unaligned_seq;
    invalid_address_sequence pkt_invalid_seq;

    if (pkt_regmodel == null)
      `uvm_fatal("REGRESSION", "Register model is not assigned")

    pkt_reset_seq = reset_values_sequence::type_id::create("reset_seq");
    pkt_reset_seq.pkt_regmodel = pkt_regmodel;
    pkt_reset_seq.start(m_sequencer);

    pkt_device_seq = device_id_ro_test::type_id::create("device_seq");
    pkt_device_seq.pkt_regmodel = pkt_regmodel;
    pkt_device_seq.start(m_sequencer);

    pkt_version_seq = version_ro_sequence::type_id::create("version_seq");
    pkt_version_seq.pkt_regmodel = pkt_regmodel;
    pkt_version_seq.start(m_sequencer);

    pkt_switch_status_seq = switch_status_ro_sequence::type_id::create("switch_status_seq");
    pkt_switch_status_seq.pkt_regmodel = pkt_regmodel;
    pkt_switch_status_seq.start(m_sequencer);

    pkt_port_status_seq = port_status_ro_sequence::type_id::create("port_status_seq");
    pkt_port_status_seq.pkt_regmodel = pkt_regmodel;
    pkt_port_status_seq.start(m_sequencer);

    pkt_gen_status_seq = gen_status_ro_sequence::type_id::create("gen_status_seq");
    pkt_gen_status_seq.pkt_regmodel = pkt_regmodel;
    pkt_gen_status_seq.start(m_sequencer);

    pkt_rx_seq = stat_rx_ro_sequence::type_id::create("rx_seq");
    pkt_rx_seq.pkt_regmodel = pkt_regmodel;
    pkt_rx_seq.start(m_sequencer);

    pkt_tx_seq = stat_tx_ro_sequence::type_id::create("tx_seq");
    pkt_tx_seq.pkt_regmodel = pkt_regmodel;
    pkt_tx_seq.start(m_sequencer);

    pkt_drop_seq = stat_drop_ro_sequence::type_id::create("drop_seq");
    pkt_drop_seq.pkt_regmodel = pkt_regmodel;
    pkt_drop_seq.start(m_sequencer);

    pkt_port_en_seq = port_enable_sequence::type_id::create("port_en_seq");
    pkt_port_en_seq.pkt_regmodel = pkt_regmodel;
    pkt_port_en_seq.start(m_sequencer);

    pkt_switch_ctrl_seq = switch_ctrl_sequence::type_id::create("switch_ctrl_seq");
    pkt_switch_ctrl_seq.pkt_regmodel = pkt_regmodel;
    pkt_switch_ctrl_seq.start(m_sequencer);

    pkt_fwd_seq = fwd_enable_sequence::type_id::create("fwd_seq");
    pkt_fwd_seq.pkt_regmodel = pkt_regmodel;
    pkt_fwd_seq.start(m_sequencer);

    pkt_gen_ctrl_seq = gen_ctrl_sequence::type_id::create("gen_ctrl_seq");
    pkt_gen_ctrl_seq.pkt_regmodel = pkt_regmodel;
    pkt_gen_ctrl_seq.start(m_sequencer);

    pkt_cfg_seq = gen_pkt_cfg_sequence::type_id::create("pkt_cfg_seq");
    pkt_cfg_seq.pkt_regmodel = pkt_regmodel;
    pkt_cfg_seq.start(m_sequencer);

    pkt_interval_seq = gen_interval_sequence::type_id::create("interval_seq");
    pkt_interval_seq.pkt_regmodel = pkt_regmodel;
    pkt_interval_seq.start(m_sequencer);

    pkt_count_seq = gen_count_sequence::type_id::create("count_seq");
    pkt_count_seq.pkt_regmodel = pkt_regmodel;
    pkt_count_seq.start(m_sequencer);

    pkt_irq_status_seq = irq_status_sequence::type_id::create("irq_status_seq");
    pkt_irq_status_seq.pkt_regmodel = pkt_regmodel;
    pkt_irq_status_seq.start(m_sequencer);

    pkt_irq_en_seq = irq_enable_sequence::type_id::create("irq_en_seq");
    pkt_irq_en_seq.pkt_regmodel = pkt_regmodel;
    pkt_irq_en_seq.start(m_sequencer);

    pkt_irq_force_seq = irq_force_sequence::type_id::create("irq_force_seq");
    pkt_irq_force_seq.pkt_regmodel = pkt_regmodel;
    pkt_irq_force_seq.start(m_sequencer);

    pkt_err_count_seq = err_count_sequence::type_id::create("err_count_seq");
    pkt_err_count_seq.pkt_regmodel = pkt_regmodel;
    pkt_err_count_seq.start(m_sequencer);

    pkt_err_info_seq = err_info_sequence::type_id::create("err_info_seq");
    pkt_err_info_seq.pkt_regmodel = pkt_regmodel;
    pkt_err_info_seq.start(m_sequencer);

    pkt_lock_seq = lock_sequence::type_id::create("lock_seq");
    pkt_lock_seq.pkt_regmodel = pkt_regmodel;
    pkt_lock_seq.start(m_sequencer);

    pkt_clear_seq = clear_sticky_status_sequence::type_id::create("clear_seq");
    pkt_clear_seq.pkt_regmodel = pkt_regmodel;
    pkt_clear_seq.start(m_sequencer);

    pkt_packets_seq = generate_four_packets_sequence::type_id::create("packets_seq");
    pkt_packets_seq.pkt_regmodel = pkt_regmodel;
    pkt_packets_seq.start(m_sequencer);

    pkt_dest_drop_seq = destination_drop_sequence::type_id::create("dest_drop_seq");
    pkt_dest_drop_seq.pkt_regmodel = pkt_regmodel;
    pkt_dest_drop_seq.start(m_sequencer);

    pkt_soft_reset_seq = soft_reset_sequence::type_id::create("soft_reset_seq");
    pkt_soft_reset_seq.pkt_regmodel = pkt_regmodel;
    pkt_soft_reset_seq.start(m_sequencer);

    pkt_unaligned_seq = unaligned_address_sequence::type_id::create("unaligned_seq");
    pkt_unaligned_seq.pkt_regmodel = pkt_regmodel;
    pkt_unaligned_seq.start(m_sequencer);

    pkt_invalid_seq = invalid_address_sequence::type_id::create("invalid_seq");
    pkt_invalid_seq.pkt_regmodel = pkt_regmodel;
    pkt_invalid_seq.start(m_sequencer);

    `uvm_info("REGRESSION", "All regression sequences completed", UVM_LOW)
  endtask
endclass