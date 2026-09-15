class coverage_collector_class;
    sequence_item_class in_seq_item;
    sequence_item_class out_seq_item;

    mailbox #(sequence_item_class) mon_out_2_cov = new(1);
    mailbox #(sequence_item_class) mon_in_2_cov = new(1);

    covergroup covg;
        cp_rst_n : coverpoint in_seq_item.rst_n;

        cp_wr_en : coverpoint in_seq_item.wr_en {
            bins wr_en_high = {1};
            bins wr_en_low = {0};
        }

        cp_rd_en : coverpoint in_seq_item.rd_en {
            bins rd_en_high = {1};
            bins rd_en_low = {0};
        }

        cp_full : coverpoint out_seq_item.full {
            bins full_high = {1};
            bins full_low = {0};
        }

        cp_almostfull : coverpoint out_seq_item.almostfull {
            bins almostfull_high = {1};
            bins almostfull_low = {0};
        }

        cp_empty : coverpoint out_seq_item.empty {
            bins empty_high = {1};
            bins empty_low = {0};
        }

        cp_almostempty : coverpoint out_seq_item.almostempty {
            bins almostempty_high = {1};
            bins almostempty_low = {0};
        }

        cp_overflow : coverpoint out_seq_item.overflow {
            bins overflow_high = {1};
            bins overflow_low = {0};
        }

        cp_underflow : coverpoint out_seq_item.underflow {
            bins underflow_high = {1};
            bins underflow_low = {0};
        }

        cp_wr_ack : coverpoint out_seq_item.wr_ack {
            bins wr_ack_high = {1};
            bins wr_ack_low = {0};
        }

        illegal_wr : cross cp_wr_en, cp_full, cp_wr_ack, cp_overflow {
            bins wr_to_full = binsof(cp_wr_en.wr_en_high) && binsof(cp_full.full_high) && 
                              binsof(cp_wr_ack.wr_ack_low) && binsof(cp_overflow.overflow_high);
            option.cross_auto_bin_max = 0;
        }

        legal_wr : cross cp_wr_en, cp_full, cp_wr_ack, cp_overflow {
            bins wr_to_not_full = binsof(cp_wr_en.wr_en_high) && binsof(cp_full.full_low) &&
                                  binsof(cp_wr_ack.wr_ack_high) && binsof(cp_overflow.overflow_low);
            option.cross_auto_bin_max = 0;
        }

        almost_full_wr : cross cp_wr_en, cp_almostfull {
            bins almostfull_wr = binsof(cp_wr_en.wr_en_high) && binsof(cp_almostfull.almostfull_high);
            option.cross_auto_bin_max = 0;
        }

        illegal_rd : cross cp_rd_en, cp_empty, cp_underflow {
            bins wr_from_empty = binsof(cp_rd_en.rd_en_high) && binsof(cp_empty.empty_high) && binsof(cp_underflow.underflow_high);
            option.cross_auto_bin_max = 0;
        }

        legal_rd : cross cp_rd_en, cp_empty, cp_underflow {
            bins wr_from_empty = binsof(cp_rd_en.rd_en_high) && binsof(cp_empty.empty_low) && binsof(cp_underflow.underflow_low);
            option.cross_auto_bin_max = 0;
        }

        almost_empty_rd : cross cp_rd_en, cp_almostempty {
            bins almostempty_rd = binsof(cp_rd_en.rd_en_high) && binsof(cp_almostempty.almostempty_high);
            option.cross_auto_bin_max = 0;
        }

        wr_rd_empty : cross cp_wr_en, cp_rd_en, cp_wr_ack, cp_empty {
            bins wr_op = binsof(cp_wr_en.wr_en_high) && binsof(cp_rd_en.rd_en_high) && binsof(cp_empty.empty_low);
            option.cross_auto_bin_max = 0;
        }

        wr_rd_full : cross cp_wr_en, cp_rd_en, cp_wr_ack, cp_full {
            bins wr_op = binsof(cp_wr_en.wr_en_high) && binsof(cp_rd_en.rd_en_high) && binsof(cp_full.full_low);
            option.cross_auto_bin_max = 0;
        }
    endgroup

    function new ();
        covg = new();
    endfunction

    task run_coverage ();
        forever begin
            mon_out_2_cov.get(out_seq_item);
            mon_in_2_cov.get(in_seq_item);
            covg.sample();
        end
    endtask
endclass