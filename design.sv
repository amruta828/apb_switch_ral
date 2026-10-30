
// -----------------------------------------------------------------------------
// apb_pkt_pkg.sv
// Constants for the APB 4-port packet switch + packet generator.
// -----------------------------------------------------------------------------
package apb_pkt_pkg;

  localparam int unsigned ADDR_W  = 16;
  localparam int unsigned DATA_W  = 32;
  localparam int unsigned N_PORTS = 4;
  localparam int unsigned Q_DEPTH = 16;
  localparam int unsigned LEN_MAX = 16;

  localparam logic [ADDR_W-1:0] ADDR_DEVICE_ID     = 16'h0000;
  localparam logic [ADDR_W-1:0] ADDR_VERSION       = 16'h0004;
  localparam logic [ADDR_W-1:0] ADDR_SWITCH_STATUS = 16'h0008;
  localparam logic [ADDR_W-1:0] ADDR_PORT_STATUS   = 16'h000C;
  localparam logic [ADDR_W-1:0] ADDR_GEN_STATUS    = 16'h0010;
  localparam logic [ADDR_W-1:0] ADDR_STAT_RX       = 16'h0014;
  localparam logic [ADDR_W-1:0] ADDR_STAT_TX       = 16'h0018;
  localparam logic [ADDR_W-1:0] ADDR_STAT_DROP     = 16'h001C;
  localparam logic [ADDR_W-1:0] ADDR_SWITCH_CTRL   = 16'h0020;
  localparam logic [ADDR_W-1:0] ADDR_PORT_ENABLE   = 16'h0024;
  localparam logic [ADDR_W-1:0] ADDR_FWD_ENABLE    = 16'h0028;
  localparam logic [ADDR_W-1:0] ADDR_GEN_CTRL      = 16'h002C;
  localparam logic [ADDR_W-1:0] ADDR_GEN_PKT_CFG   = 16'h0030;
  localparam logic [ADDR_W-1:0] ADDR_GEN_INTERVAL  = 16'h0034;
  localparam logic [ADDR_W-1:0] ADDR_GEN_COUNT     = 16'h0038;
  localparam logic [ADDR_W-1:0] ADDR_IRQ_STATUS    = 16'h003C;
  localparam logic [ADDR_W-1:0] ADDR_IRQ_ENABLE    = 16'h0040;
  localparam logic [ADDR_W-1:0] ADDR_IRQ_FORCE     = 16'h0044;
  localparam logic [ADDR_W-1:0] ADDR_ERR_STATUS    = 16'h0048;
  localparam logic [ADDR_W-1:0] ADDR_ERR_ENABLE    = 16'h004C;
  localparam logic [ADDR_W-1:0] ADDR_ERR_INJECT    = 16'h0050;
  localparam logic [ADDR_W-1:0] ADDR_ERR_COUNT     = 16'h0054;
  localparam logic [ADDR_W-1:0] ADDR_ERR_INFO      = 16'h0058;
  localparam logic [ADDR_W-1:0] ADDR_LOCK          = 16'h005C;
  localparam logic [ADDR_W-1:0] ADDR_SOFT_RESET    = 16'h0060;
  localparam logic [ADDR_W-1:0] ADDR_MAX           = 16'h0060;

  localparam logic [DATA_W-1:0] RST_DEVICE_ID    = 32'h02A5_5357;
  localparam logic [DATA_W-1:0] RST_VERSION      = 32'h0001_0200;
  localparam logic [DATA_W-1:0] RST_PORT_ENABLE  = 32'h0000_000F;
  localparam logic [DATA_W-1:0] RST_FWD_ENABLE   = 32'h0000_000F;
  localparam logic [DATA_W-1:0] RST_GEN_PKT_CFG  = 32'h0000_0401;
  localparam logic [DATA_W-1:0] RST_GEN_INTERVAL = 32'h0000_0002;
  localparam logic [DATA_W-1:0] RST_GEN_COUNT    = 32'h0000_0004;

  localparam logic [DATA_W-1:0] UNLOCK_KEY = 32'hA5A5_C3C3;

  localparam logic [DATA_W-1:0] MASK_SWITCH_CTRL = 32'h0000_0009;
  localparam logic [DATA_W-1:0] MASK_PORT_ENABLE = 32'h0000_000F;
  localparam logic [DATA_W-1:0] MASK_FWD_ENABLE  = 32'h0000_000F;
  localparam logic [DATA_W-1:0] MASK_GEN_CTRL    = 32'h0000_0009;
  localparam logic [DATA_W-1:0] MASK_GEN_PKT_CFG = 32'h00FF_FF0F;
  localparam logic [DATA_W-1:0] MASK_GEN_INTERVAL = 32'h0000_FFFF;
  localparam logic [DATA_W-1:0] MASK_GEN_COUNT   = 32'h0000_FFFF;
  localparam logic [DATA_W-1:0] MASK_IRQ         = 32'h0000_00FF;
  localparam logic [DATA_W-1:0] MASK_ERR         = 32'h0000_00FF;

  localparam logic [1:0] GEN_IDLE = 2'd0;
  localparam logic [1:0] GEN_SEND = 2'd1;
  localparam logic [1:0] GEN_GAP  = 2'd2;
  localparam logic [1:0] GEN_DONE = 2'd3;

endpackage




// -----------------------------------------------------------------------------
// pkt_generator.sv
// Programmable packet generator: emits counted packets onto the switch fabric.
// -----------------------------------------------------------------------------
module pkt_generator
  import apb_pkt_pkg::*;
(
  input  logic         clk,
  input  logic         rst_n,
  input  logic         enable,
  input  logic         start_pulse_v,
  input  logic         stop_pulse_v,
  input  logic         continuous,
  input  logic [1:0]   cfg_dst,
  input  logic [1:0]   cfg_src,
  input  logic [7:0]   cfg_len,
  input  logic [7:0]   cfg_seed,
  input  logic [15:0]  cfg_interval,
  input  logic [15:0]  cfg_count,
  input  logic         out_ready,
  output logic         out_valid,
  output logic         out_sop,
  output logic         out_eop,
  output logic [1:0]   out_dst,
  output logic [1:0]   out_src,
  output logic [7:0]   out_len,
  output logic [31:0]  out_data,
  output logic         running,
  output logic [15:0]  remaining,
  output logic [1:0]   fsm,
  output logic         done_pulse,
  output logic         start_ack
);

  logic [1:0]  fsm_q_v;
  logic [7:0]  beat_q_v;
  logic [15:0] gap_q_v;
  logic [15:0] left_q_v;
  logic [15:0] pkt_idx_q_v;

  logic [7:0] len_n_v;

  assign len_n_v = (cfg_len == 8'd0) ? 8'd1 :
                 (cfg_len > LEN_MAX[7:0]) ? LEN_MAX[7:0] :
                 cfg_len;

  logic [15:0] n_pkts_v;
  assign n_pkts_v = (cfg_count == 16'd0) ? 16'd1 : cfg_count;

  logic last_beat_v;
  assign last_beat_v = (beat_q_v + 8'd1) >= len_n_v;

  assign fsm       = fsm_q_v;
  assign remaining = left_q_v;
  assign running   = (fsm_q_v == GEN_SEND) || (fsm_q_v == GEN_GAP);
  assign out_dst   = cfg_dst;
  assign out_src   = cfg_src;
  assign out_len   = len_n_v;

  assign out_valid = (fsm_q_v == GEN_SEND) && enable;
  assign out_sop   = out_valid && (beat_q_v == 8'd0);
  assign out_eop   = out_valid && last_beat_v;
  assign out_data  = {cfg_seed, pkt_idx_q_v[7:0], beat_q_v, 8'hA5};

  logic fire_start_v;

  assign fire_start_v = start_pulse_v && enable &&
                      (fsm_q_v == GEN_IDLE || fsm_q_v == GEN_DONE);

  assign start_ack = fire_start_v;

  assign done_pulse = (fsm_q_v == GEN_SEND) && enable && last_beat_v &&
                      (out_ready || 1'b1) &&
                      !continuous && (left_q_v == 16'd1);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fsm_q_v     <= GEN_IDLE;
      beat_q_v    <= 8'd0;
      gap_q_v     <= 16'd0;
      left_q_v    <= 16'd0;
      pkt_idx_q_v <= 16'd0;
    end
    else if (!enable || stop_pulse_v) begin
      fsm_q_v  <= GEN_IDLE;
      beat_q_v <= 8'd0;
      gap_q_v  <= 16'd0;
      left_q_v <= 16'd0;
    end
    else begin
      unique case (fsm_q_v)

        GEN_IDLE: begin
          beat_q_v <= 8'd0;
          gap_q_v  <= 16'd0;

          if (fire_start_v) begin
            fsm_q_v     <= GEN_SEND;
            left_q_v    <= n_pkts_v;
            pkt_idx_q_v <= 16'd0;
          end
        end

        GEN_SEND: begin
          if (out_ready || 1'b1) begin
            if (last_beat_v) begin
              pkt_idx_q_v <= pkt_idx_q_v + 16'd1;

              if (!continuous && left_q_v == 16'd1) begin
                left_q_v <= 16'd0;
                fsm_q_v  <= GEN_DONE;
              end
              else begin
                if (!continuous)
                  left_q_v <= left_q_v - 16'd1;

                beat_q_v <= 8'd0;

                if (cfg_interval == 16'd0)
                  fsm_q_v <= GEN_SEND;
                else begin
                  gap_q_v <= 16'd1;
                  fsm_q_v <= GEN_GAP;
                end
              end
            end
            else begin
              beat_q_v <= beat_q_v + 8'd1;
            end
          end
        end

        GEN_GAP: begin
          if (gap_q_v >= cfg_interval) begin
            gap_q_v  <= 16'd0;
            beat_q_v <= 8'd0;
            fsm_q_v  <= GEN_SEND;
          end
          else begin
            gap_q_v <= gap_q_v + 16'd1;
          end
        end

        GEN_DONE: begin
          if (fire_start_v) begin
            fsm_q_v     <= GEN_SEND;
            left_q_v    <= n_pkts_v;
            pkt_idx_q_v <= 16'd0;
            beat_q_v    <= 8'd0;
          end
        end

        default: fsm_q_v <= GEN_IDLE;

      endcase
    end
  end

endmodule






// -----------------------------------------------------------------------------
// pkt_switch.sv
// Four-port packet switch: dest-port lookup, per-port queues, RX/TX/drop stats.
// -----------------------------------------------------------------------------
module pkt_switch
  import apb_pkt_pkg::*;
(
  input  logic               clk,
  input  logic               rst_n,
  input  logic               switch_en_v,
  input  logic [N_PORTS-1:0] port_en,
  input  logic [N_PORTS-1:0] fwd_en,
  input  logic               stat_clr,
  input  logic               in_valid,
  input  logic               in_sop,
  input  logic               in_eop,
  input  logic [1:0]         in_dst,
  input  logic [1:0]         in_src,
  input  logic [7:0]         in_len,
  input  logic [31:0]        in_data,
  output logic               in_ready,
  output logic [7:0]         q_level_v [N_PORTS],
  output logic [15:0]        stat_rx_v,
  output logic [15:0]        stat_tx_v,
  output logic [15:0]        stat_drop_v,
  output logic               ovf_evt_v,
  output logic               dest_err_evt_v,
  output logic               drop_evt_v,
  output logic               fwd_eop_evt_v
);

  logic dropping_q_v;
  logic [7:0] q_q_v [N_PORTS];
  logic [15:0] rx_q_v, tx_q_v, drop_q_v;

  assign in_ready = 1'b1;
  assign stat_rx_v   = rx_q_v;
  assign stat_tx_v   = tx_q_v;
  assign stat_drop_v = drop_q_v;

  genvar gi_v;
  generate
    for (gi_v = 0; gi_v < N_PORTS; gi_v++) begin : g_ql
      assign q_level_v[gi_v] = q_q_v[gi_v];
    end
  endgenerate

  logic dest_ok_v;
  logic queue_ok_v;
  logic accept_v;
  logic [1:0] d_v;

  assign d_v         = in_dst;
  assign dest_ok_v   = port_en[d_v] && fwd_en[d_v] && switch_en_v;
  assign queue_ok_v  = (q_q_v[d_v] < Q_DEPTH[7:0]);
  assign accept_v    = in_valid && dest_ok_v && queue_ok_v && !dropping_q_v;

  always_comb begin
    ovf_evt_v      = 1'b0;
    dest_err_evt_v = 1'b0;
    drop_evt_v     = 1'b0;
    fwd_eop_evt_v  = 1'b0;

    if (in_valid && in_sop) begin
      if (!dest_ok_v)
        dest_err_evt_v = 1'b1;
      else if (!queue_ok_v)
        ovf_evt_v = 1'b1;
    end

    if (in_valid && in_eop) begin
      if (accept_v)
        fwd_eop_evt_v = 1'b1;
      else
        drop_evt_v = 1'b1;
    end
  end

  integer i_v;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      dropping_q_v <= 1'b0;
      rx_q_v       <= 16'd0;
      tx_q_v       <= 16'd0;
      drop_q_v     <= 16'd0;

      for (i_v = 0; i_v < N_PORTS; i_v++)
        q_q_v[i_v] <= 8'd0;
    end
    else if (stat_clr) begin
      dropping_q_v <= 1'b0;
      rx_q_v       <= 16'd0;
      tx_q_v       <= 16'd0;
      drop_q_v     <= 16'd0;

      for (i_v = 0; i_v < N_PORTS; i_v++)
        q_q_v[i_v] <= 8'd0;
    end
    else begin

      if (in_valid && in_sop)
        dropping_q_v <= !(dest_ok_v && queue_ok_v);
      else if (in_valid && in_eop)
        dropping_q_v <= 1'b0;

      if (accept_v) begin
        if (in_eop) begin
          if (rx_q_v != 16'hFFFF)
            rx_q_v <= rx_q_v + 16'd1;

          if (tx_q_v != 16'hFFFF)
            tx_q_v <= tx_q_v + 16'd1;
        end
      end
      else if (in_valid && in_eop) begin
        if (drop_q_v != 16'hFFFF)
          drop_q_v <= drop_q_v + 16'd1;
      end

      for (i_v = 0; i_v < N_PORTS; i_v++) begin
        if (accept_v && (d_v == i_v[1:0])) begin
          if (q_q_v[i_v] < Q_DEPTH[7:0])
            q_q_v[i_v] <= q_q_v[i_v] + 8'd1;
        end
        else if (q_q_v[i_v] > 8'd0) begin
          q_q_v[i_v] <= q_q_v[i_v] - 8'd1;
        end
      end

    end
  end

  logic _unused_src_v;
  logic [7:0] _unused_len_v;
  logic [31:0] _unused_data_v;

  assign _unused_src_v  = in_src[0];
  assign _unused_len_v  = in_len;
  assign _unused_data_v = in_data;

endmodule





// -----------------------------------------------------------------------------
// apb_pkt_switch.sv
// AMBA APB3 CSR front-end for a 4-port packet switch + packet generator.
// -----------------------------------------------------------------------------
module apb_pkt_switch
  import apb_pkt_pkg::*;
(
  input  logic              pclk,
  input  logic              presetn,
  input  logic              psel,
  input  logic              penable,
  input  logic              pwrite,
  input  logic [ADDR_W-1:0] paddr,
  input  logic [DATA_W-1:0] pwdata,
  output logic [DATA_W-1:0] prdata,
  output logic              pready,
  output logic              pslverr,
  output logic              irq
);

  assign pready = 1'b1;

  logic acc_v, wr_v, rd_v, unaligned_v, unmapped_v;
  logic [15:0] word_addr_v;

  assign acc_v       = psel & penable & pready;
  assign wr_v        = acc_v & pwrite;
  assign rd_v        = acc_v & ~pwrite;
  assign unaligned_v = |paddr[1:0];
  assign unmapped_v  = paddr > ADDR_MAX;
  assign word_addr_v = {paddr[15:2], 2'b00};

  logic wr_ok_v, rd_ok_v;

  assign wr_ok_v   = wr_v & ~unaligned_v & ~unmapped_v;
  assign rd_ok_v   = rd_v & ~unaligned_v & ~unmapped_v;
  assign pslverr = acc_v & (unaligned_v | unmapped_v);

  logic locked_v;

  logic [31:0] switch_ctrl_q_v;
  logic [3:0]  port_enable_q_v;
  logic [3:0]  fwd_enable_q_v;
  logic [31:0] gen_ctrl_q_v;
  logic [31:0] gen_pkt_cfg_q_v;
  logic [15:0] gen_interval_q_v;
  logic [15:0] gen_count_q_v;
  logic [7:0]  irq_status_q_v;
  logic [7:0]  irq_enable_q_v;
  logic [7:0]  err_status_q_v;
  logic [7:0]  err_enable_q_v;
  logic [15:0] err_count_q_v;
  logic [31:0] err_info_q_v;

  logic wr_switch_ctrl_v, wr_port_en_v, wr_fwd_en_v, wr_gen_ctrl_v;
  logic wr_gen_pkt_v, wr_gen_int_v, wr_gen_cnt_v;
  logic wr_irq_status_v, wr_irq_enable_v, wr_irq_force_v;
  logic wr_err_status_v, wr_err_enable_v, wr_err_inject_v;
  logic wr_lock_v, wr_soft_reset_v;

  always_comb begin
    wr_switch_ctrl_v = 1'b0;
    wr_port_en_v     = 1'b0;
    wr_fwd_en_v      = 1'b0;
    wr_gen_ctrl_v    = 1'b0;
    wr_gen_pkt_v     = 1'b0;
    wr_gen_int_v     = 1'b0;
    wr_gen_cnt_v     = 1'b0;
    wr_irq_status_v  = 1'b0;
    wr_irq_enable_v  = 1'b0;
    wr_irq_force_v   = 1'b0;
    wr_err_status_v  = 1'b0;
    wr_err_enable_v  = 1'b0;
    wr_err_inject_v  = 1'b0;
    wr_lock_v        = 1'b0;
    wr_soft_reset_v  = 1'b0;

    if (wr_ok_v) begin
      unique case (word_addr_v)
        ADDR_SWITCH_CTRL:  wr_switch_ctrl_v = 1'b1;
        ADDR_PORT_ENABLE:  wr_port_en_v     = 1'b1;
        ADDR_FWD_ENABLE:   wr_fwd_en_v      = 1'b1;
        ADDR_GEN_CTRL:     wr_gen_ctrl_v    = 1'b1;
        ADDR_GEN_PKT_CFG:  wr_gen_pkt_v     = 1'b1;
        ADDR_GEN_INTERVAL: wr_gen_int_v     = 1'b1;
        ADDR_GEN_COUNT:    wr_gen_cnt_v     = 1'b1;
        ADDR_IRQ_STATUS:   wr_irq_status_v  = 1'b1;
        ADDR_IRQ_ENABLE:   wr_irq_enable_v  = 1'b1;
        ADDR_IRQ_FORCE:    wr_irq_force_v   = 1'b1;
        ADDR_ERR_STATUS:   wr_err_status_v  = 1'b1;
        ADDR_ERR_ENABLE:   wr_err_enable_v  = 1'b1;
        ADDR_ERR_INJECT:   wr_err_inject_v  = 1'b1;
        ADDR_LOCK:         wr_lock_v        = 1'b1;
        ADDR_SOFT_RESET:   wr_soft_reset_v  = 1'b1;
        default: ;
      endcase
    end
  end

  logic cfg_wr_ok_v;

  assign cfg_wr_ok_v = wr_ok_v & ~locked_v;

  logic srst_pulse_v, stat_clr_pulse_v, start_pulse_v, stop_pulse_v;

  assign srst_pulse_v     = wr_soft_reset_v & pwdata[0];
  assign stat_clr_pulse_v = wr_switch_ctrl_v & cfg_wr_ok_v & pwdata[1];
  assign start_pulse_v    = wr_gen_ctrl_v & cfg_wr_ok_v & pwdata[1];
  assign stop_pulse_v     = wr_gen_ctrl_v & cfg_wr_ok_v & pwdata[2];

  logic [7:0] irq_force_w_v, err_inject_w_v;
  logic err_clr_count_v;

  assign irq_force_w_v   = wr_irq_force_v  ? pwdata[7:0] : 8'h00;
  assign err_inject_w_v  = wr_err_inject_v ? pwdata[7:0] : 8'h00;
  assign err_clr_count_v = wr_err_inject_v & pwdata[31];

  logic switch_en_v, irq_gen_en_v, gen_en_v, gen_cont_v;

  assign switch_en_v = switch_ctrl_q_v[0];
  assign irq_gen_en_v = switch_ctrl_q_v[3];
  assign gen_en_v = gen_ctrl_q_v[0];
  assign gen_cont_v = gen_ctrl_q_v[3];

  logic        gen_valid_v, gen_sop_v, gen_eop_v, gen_ready_v;
  logic [1:0]  gen_dst_v, gen_src_v, gen_fsm_v;
  logic [7:0]  gen_len_v;
  logic [31:0] gen_data_v;
  logic        gen_running_v, gen_done_pulse_v, gen_start_ack_v;
  logic [15:0] gen_left_v;

  logic gen_en_eff_v;

  assign gen_en_eff_v = (cfg_wr_ok_v && wr_gen_ctrl_v)
                    ? pwdata[0] : gen_en_v;

  pkt_generator u_gen (
    .clk          (pclk),
    .rst_n        (presetn),
    .enable       (gen_en_eff_v),
    .start_pulse_v  (start_pulse_v),
    .stop_pulse_v   (stop_pulse_v | srst_pulse_v),
    .continuous   (gen_cont_v),
    .cfg_dst      (gen_pkt_cfg_q_v[1:0]),
    .cfg_src      (gen_pkt_cfg_q_v[3:2]),
    .cfg_len      (gen_pkt_cfg_q_v[15:8]),
    .cfg_seed     (gen_pkt_cfg_q_v[23:16]),
    .cfg_interval (gen_interval_q_v),
    .cfg_count    (gen_count_q_v),
    .out_ready    (gen_ready_v),
    .out_valid    (gen_valid_v),
    .out_sop      (gen_sop_v),
    .out_eop      (gen_eop_v),
    .out_dst      (gen_dst_v),
    .out_src      (gen_src_v),
    .out_len      (gen_len_v),
    .out_data     (gen_data_v),
    .running      (gen_running_v),
    .remaining    (gen_left_v),
    .fsm          (gen_fsm_v),
    .done_pulse   (gen_done_pulse_v),
    .start_ack    (gen_start_ack_v)
  );

  logic [7:0] q_level_v [N_PORTS];
  logic [15:0] stat_rx_v, stat_tx_v, stat_drop_v;
  logic ovf_evt_v, dest_err_evt_v, drop_evt_v, fwd_eop_evt_v;

  pkt_switch u_sw (
    .clk          (pclk),
    .rst_n        (presetn),
    .switch_en_v    (switch_en_v),
    .port_en      (port_enable_q_v),
    .fwd_en       (fwd_enable_q_v),
    .stat_clr     (stat_clr_pulse_v | srst_pulse_v),
    .in_valid     (gen_valid_v),
    .in_sop       (gen_sop_v),
    .in_eop       (gen_eop_v),
    .in_dst       (gen_dst_v),
    .in_src       (gen_src_v),
    .in_len       (gen_len_v),
    .in_data      (gen_data_v),
    .in_ready     (gen_ready_v),
    .q_level_v      (q_level_v),
    .stat_rx_v      (stat_rx_v),
    .stat_tx_v      (stat_tx_v),
    .stat_drop_v    (stat_drop_v),
    .ovf_evt_v      (ovf_evt_v),
    .dest_err_evt_v (dest_err_evt_v),
    .drop_evt_v     (drop_evt_v),
    .fwd_eop_evt_v  (fwd_eop_evt_v)
  );

  logic busy_v;

  assign busy_v = gen_running_v ||
                (q_level_v[0] != 8'd0) ||
                (q_level_v[1] != 8'd0) ||
                (q_level_v[2] != 8'd0) ||
                (q_level_v[3] != 8'd0);

  logic [31:0] switch_status_r_v;

  always_comb begin
    switch_status_r_v = 32'h0;
    switch_status_r_v[0]     = ~gen_running_v;
    switch_status_r_v[1]     = busy_v;
    switch_status_r_v[2]     = switch_en_v;
    switch_status_r_v[3]     = locked_v;
    switch_status_r_v[7:4]   = port_enable_q_v;
    switch_status_r_v[8]     = gen_running_v;
    switch_status_r_v[9]     = |err_status_q_v;
    switch_status_r_v[17:16] = gen_fsm_v;
  end

  logic [31:0] port_status_r_v;

  always_comb begin
    port_status_r_v = 32'h0;
    port_status_r_v[7:0]   = q_level_v[0];
    port_status_r_v[15:8]  = q_level_v[1];
    port_status_r_v[23:16] = q_level_v[2];
    port_status_r_v[31:24] = q_level_v[3];
  end

  logic [31:0] gen_status_r_v;

  always_comb begin
    gen_status_r_v = 32'h0;
    gen_status_r_v[0]    = gen_running_v;
    gen_status_r_v[1]    = (gen_fsm_v == GEN_DONE);
    gen_status_r_v[3:2]  = gen_fsm_v;
    gen_status_r_v[23:8] = gen_left_v;
  end

  logic [7:0] irq_w1c_v, err_w1c_v, err_set_v, irq_set_v;

  assign irq_w1c_v = wr_irq_status_v ? pwdata[7:0] : 8'h00;
  assign err_w1c_v = wr_err_status_v ? pwdata[7:0] : 8'h00;

  always_comb begin
    err_set_v = 8'h00;

    if (dest_err_evt_v)
      err_set_v[1] = 1'b1;

    if (ovf_evt_v)
      err_set_v[2] = 1'b1;

    if (|err_inject_w_v[6:0]) begin
      err_set_v = err_set_v | err_inject_w_v;
      err_set_v[7] = 1'b1;
    end
    else if (err_inject_w_v[7]) begin
      err_set_v[7] = 1'b1;
    end
  end

  logic [7:0] err_next_v;

  assign err_next_v = (err_status_q_v | err_set_v) & ~err_w1c_v;

  logic err_promote_v;

  assign err_promote_v = |((err_status_q_v | err_set_v) & err_enable_q_v);

  always_comb begin
    irq_set_v = irq_force_w_v;

    if (gen_done_pulse_v) irq_set_v[0] = 1'b1;
    if (err_promote_v)    irq_set_v[1] = 1'b1;
    if (ovf_evt_v)        irq_set_v[2] = 1'b1;
    if (drop_evt_v)       irq_set_v[3] = 1'b1;
    if (fwd_eop_evt_v)    irq_set_v[4] = 1'b1;
    if (gen_start_ack_v)  irq_set_v[6] = 1'b1;

    if ((q_level_v[0] >= 8'd8) ||
        (q_level_v[1] >= 8'd8) ||
        (q_level_v[2] >= 8'd8) ||
        (q_level_v[3] >= 8'd8))
      irq_set_v[5] = 1'b1;
  end

  logic [7:0] irq_next;

  assign irq_next = (irq_status_q_v | irq_set_v) & ~irq_w1c_v;

  int unsigned inj_i_v, code_i_v;
  logic [15:0] inject_pop_v;
  logic [7:0] last_code_v;

  always_comb begin
    inject_pop_v = 16'd0;

    for (inj_i_v = 0; inj_i_v < 7; inj_i_v++)
      inject_pop_v = inject_pop_v + {15'd0, err_inject_w_v[inj_i_v]};
  end

  always_comb begin
    last_code_v = 8'hFF;

    for (code_i_v = 0; code_i_v < 8; code_i_v++)
      if (err_set_v[code_i_v] && last_code_v == 8'hFF)
        last_code_v = code_i_v[7:0];
  end

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      locked_v          <= 1'b1;
      switch_ctrl_q_v   <= 32'h0;
      port_enable_q_v   <= RST_PORT_ENABLE[3:0];
      fwd_enable_q_v    <= RST_FWD_ENABLE[3:0];
      gen_ctrl_q_v      <= 32'h0;
      gen_pkt_cfg_q_v   <= RST_GEN_PKT_CFG;
      gen_interval_q_v  <= RST_GEN_INTERVAL[15:0];
      gen_count_q_v     <= RST_GEN_COUNT[15:0];
      irq_status_q_v    <= 8'h0;
      irq_enable_q_v    <= 8'h0;
      err_status_q_v    <= 8'h0;
      err_enable_q_v    <= 8'h0;
      err_count_q_v     <= 16'h0;
      err_info_q_v      <= 32'h0;
    end
    else if (srst_pulse_v) begin
      locked_v          <= 1'b1;
      switch_ctrl_q_v   <= 32'h0;
      port_enable_q_v   <= RST_PORT_ENABLE[3:0];
      fwd_enable_q_v    <= RST_FWD_ENABLE[3:0];
      gen_ctrl_q_v      <= 32'h0;
      gen_pkt_cfg_q_v   <= RST_GEN_PKT_CFG;
      gen_interval_q_v  <= RST_GEN_INTERVAL[15:0];
      gen_count_q_v     <= RST_GEN_COUNT[15:0];
      irq_status_q_v    <= 8'h0;
      irq_enable_q_v    <= 8'h0;
      err_status_q_v    <= 8'h0;
      err_enable_q_v    <= 8'h0;
      err_count_q_v     <= 16'h0;
      err_info_q_v      <= 32'h0;
    end
    else begin
      if (wr_lock_v)
        locked_v <= (pwdata != UNLOCK_KEY);

      if (cfg_wr_ok_v) begin
        if (wr_switch_ctrl_v)
          switch_ctrl_q_v <= pwdata & MASK_SWITCH_CTRL;

        if (wr_port_en_v)
          port_enable_q_v <= pwdata[3:0];

        if (wr_fwd_en_v)
          fwd_enable_q_v <= pwdata[3:0];

        if (wr_gen_ctrl_v)
          gen_ctrl_q_v <= pwdata & MASK_GEN_CTRL;

        if (wr_gen_pkt_v) begin
          gen_pkt_cfg_q_v <= pwdata & MASK_GEN_PKT_CFG;

          if (pwdata[15:8] == 8'd0)
            gen_pkt_cfg_q_v[15:8] <= 8'd1;
        end

        if (wr_gen_int_v)
          gen_interval_q_v <= pwdata[15:0];

        if (wr_gen_cnt_v)
          gen_count_q_v <= pwdata[15:0];

        if (wr_irq_enable_v)
          irq_enable_q_v <= pwdata[7:0];

        if (wr_err_enable_v)
          err_enable_q_v <= pwdata[7:0];
      end

      irq_status_q_v <= irq_next;
      err_status_q_v <= err_next_v;

      if (err_clr_count_v) begin
        err_count_q_v <= 16'h0;
        err_info_q_v  <= 32'h0;
      end
      else if (|err_set_v) begin
        if (|err_inject_w_v[6:0]) begin
          if (err_count_q_v > (16'hFFFF - inject_pop_v))
            err_count_q_v <= 16'hFFFF;
          else
            err_count_q_v <= err_count_q_v + inject_pop_v;
        end
        else if (err_count_q_v != 16'hFFFF) begin
          err_count_q_v <= err_count_q_v + 16'd1;
        end

        err_info_q_v[7:0]   <= last_code_v;
        err_info_q_v[15:8]  <= (|err_inject_w_v) ? 8'd1 : 8'd0;
        err_info_q_v[17:16] <= gen_dst_v;
        err_info_q_v[31:20] <= stat_tx_v[11:0];
      end
    end
  end

  assign irq = irq_gen_en_v & |(irq_status_q_v & irq_enable_q_v);

  logic [31:0] rdata_mux_v;

  always_comb begin
    rdata_mux_v = 32'h0;

    unique case (word_addr_v)
      ADDR_DEVICE_ID:     rdata_mux_v = RST_DEVICE_ID;
      ADDR_VERSION:       rdata_mux_v = RST_VERSION;
      ADDR_SWITCH_STATUS: rdata_mux_v = switch_status_r_v;
      ADDR_PORT_STATUS:   rdata_mux_v = port_status_r_v;
      ADDR_GEN_STATUS:    rdata_mux_v = gen_status_r_v;
      ADDR_STAT_RX:       rdata_mux_v = {16'h0, stat_rx_v};
      ADDR_STAT_TX:       rdata_mux_v = {16'h0, stat_tx_v};
      ADDR_STAT_DROP:     rdata_mux_v = {16'h0, stat_drop_v};
      ADDR_SWITCH_CTRL:   rdata_mux_v = switch_ctrl_q_v;
      ADDR_PORT_ENABLE:   rdata_mux_v = {28'h0, port_enable_q_v};
      ADDR_FWD_ENABLE:    rdata_mux_v = {28'h0, fwd_enable_q_v};
      ADDR_GEN_CTRL:      rdata_mux_v = gen_ctrl_q_v;
      ADDR_GEN_PKT_CFG:   rdata_mux_v = gen_pkt_cfg_q_v;
      ADDR_GEN_INTERVAL:  rdata_mux_v = {16'h0, gen_interval_q_v};
      ADDR_GEN_COUNT:     rdata_mux_v = {16'h0, gen_count_q_v};
      ADDR_IRQ_STATUS:    rdata_mux_v = {24'h0, irq_status_q_v};
      ADDR_IRQ_ENABLE:    rdata_mux_v = {24'h0, irq_enable_q_v};
      ADDR_IRQ_FORCE:     rdata_mux_v = 32'h0;
      ADDR_ERR_STATUS:    rdata_mux_v = {24'h0, err_status_q_v};
      ADDR_ERR_ENABLE:    rdata_mux_v = {24'h0, err_enable_q_v};
      ADDR_ERR_INJECT:    rdata_mux_v = 32'h0;
      ADDR_ERR_COUNT:     rdata_mux_v = {16'h0, err_count_q_v};
      ADDR_ERR_INFO:      rdata_mux_v = err_info_q_v;
      ADDR_LOCK:          rdata_mux_v = {31'h0, locked_v};
      ADDR_SOFT_RESET:    rdata_mux_v = 32'h0;
      default:            rdata_mux_v = 32'h0;
    endcase
  end

  always_comb begin
    if (psel && !pwrite) begin
      if (unaligned_v || unmapped_v)
        prdata = 32'h0;
      else
        prdata = rdata_mux_v;
    end
    else begin
      prdata = 32'h0;
    end
  end

endmodule
