class subscriber extends uvm_subscriber #(pkt_seq_item);
  `uvm_component_utils(subscriber)

  uvm_tlm_analysis_fifo #(pkt_seq_item) pkt_analysis_fifo;

  pkt_seq_item pkt_tr;

  covergroup pkt_cg;
    option.per_instance = 1;

    cp_write: coverpoint pkt_tr.write {
      bins read  = {0};
      bins write = {1};
    }

    cp_addr: coverpoint pkt_tr.addr {
      bins valid_addr[] = {
        16'h0000, 16'h0004, 16'h0008, 16'h000C,
        16'h0010, 16'h0014, 16'h0018, 16'h001C,
        16'h0020, 16'h0024, 16'h0028, 16'h002C,
        16'h0030, 16'h0034, 16'h0038, 16'h003C,
        16'h0040, 16'h0044, 16'h0048, 16'h004C,
        16'h0050, 16'h0054, 16'h0058, 16'h005C,
        16'h0060
      };

      bins unaligned = {[16'h0001:16'h005F]}
        with (item[1:0] != 2'b00);

      bins out_of_range = {[16'h0061:16'hFFFF]};
    }

    cp_data: coverpoint pkt_tr.data {
      bins zero     = {32'h00000000};
      bins all_ones = {32'hFFFFFFFF};
      bins other    = default;
    }

    cp_rdata: coverpoint pkt_tr.rdata {
      bins zero    = {32'h00000000};
      bins nonzero = {[32'h00000001:32'hFFFFFFFF]};
    }

    cp_slverr: coverpoint pkt_tr.slverr {
      bins no_error = {0};
      bins error    = {1};
    }

    write_x_addr: cross cp_write, cp_addr;
    write_x_error: cross cp_write, cp_slverr;
  endgroup

  function new(string pkt_name = "pkt_subscriber",
               uvm_component pkt_parent = null);
    super.new(pkt_name, pkt_parent);
    pkt_analysis_fifo = new("analysis_fifo", this);
    pkt_cg = new();
  endfunction

  function void write(pkt_seq_item pkt_t);
    pkt_seq_item pkt_item;
    $cast(pkt_item, pkt_t.clone());
    pkt_analysis_fifo.write(pkt_item);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      pkt_analysis_fifo.get(pkt_tr);
      pkt_cg.sample();
    end
  endtask

endclass