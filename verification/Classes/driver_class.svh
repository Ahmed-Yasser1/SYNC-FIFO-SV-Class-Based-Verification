class driver_class;
    sequence_item_class seq_item;
    sequencer_class seqr;

    virtual FIFO_if vif;

    function new (virtual FIFO_if vif);
        this.vif = vif;
    endfunction

    task run_driv ();
        forever begin
            seq_item = new();

            @(vif.driv_cb);
            seqr.seqr_mb.get(seq_item);

            vif.driv_cb.rst_n <= seq_item.rst_n;
            vif.driv_cb.data_in <= seq_item.data_in;
            vif.driv_cb.wr_en <= seq_item.wr_en;
            vif.driv_cb.rd_en <= seq_item.rd_en;
        end
    endtask
endclass