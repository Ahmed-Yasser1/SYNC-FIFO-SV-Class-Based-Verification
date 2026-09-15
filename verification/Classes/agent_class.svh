class agent_class;
    sequencer_class seqr;
    driver_class driv;
    monitor_class mon;

    virtual FIFO_if vif;

    function new (virtual FIFO_if vif);
        this.vif = vif;

        build_agent();
        connect_agent();
    endfunction

    function build_agent ();
        driv = new(vif);
        mon = new(vif);
        seqr = new();
    endfunction

    function connect_agent ();
        driv.seqr = seqr;
    endfunction

    task run_agent ();
        fork
            driv.run_driv();
            mon.run_mon();
        join_any
    endtask
endclass