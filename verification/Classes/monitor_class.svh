class monitor_class;
    sequence_item_class in_seq_item;
    sequence_item_class out_seq_item;

    virtual FIFO_if vif;

    mailbox #(sequence_item_class) mon_out_2_scb = new(1);
    mailbox #(sequence_item_class) mon_out_2_cov = new(1);

    mailbox #(sequence_item_class) mon_in_2_scb = new(1);
    mailbox #(sequence_item_class) mon_in_2_cov = new(1);

    function new (virtual FIFO_if vif);
        this.vif = vif;
    endfunction

    task run_mon ();
        @(vif.mon_cb);
        
        forever begin
            in_seq_item = new();
            out_seq_item = new();

            @(vif.mon_cb);
            
            // Capture INPUTS
            in_seq_item.rst_n = vif.mon_cb.rst_n;
            in_seq_item.data_in = vif.mon_cb.data_in;
            in_seq_item.wr_en = vif.mon_cb.wr_en;
            in_seq_item.rd_en = vif.mon_cb.rd_en;
            
            // Capture OUTPUTS
            out_seq_item.data_out = vif.mon_cb.data_out;
            out_seq_item.wr_ack = vif.mon_cb.wr_ack;
            out_seq_item.overflow = vif.mon_cb.overflow;
            out_seq_item.full = vif.mon_cb.full;
            out_seq_item.empty = vif.mon_cb.empty;
            out_seq_item.almostfull = vif.mon_cb.almostfull; 
            out_seq_item.almostempty = vif.mon_cb.almostempty;
            out_seq_item.underflow = vif.mon_cb.underflow;

            mon_out_2_scb.put(out_seq_item);
            mon_out_2_cov.put(out_seq_item);

            mon_in_2_scb.put(in_seq_item);
            mon_in_2_cov.put(in_seq_item);
        end
    endtask
endclass