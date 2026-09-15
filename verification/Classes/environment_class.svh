class environment_class;
    agent_class agt;
    scoreboard_class scb;
    coverage_collector_class cvg;

    virtual FIFO_if vif;


    // mailbox #(sequence_item_class) mon_out_2_scb = new(1);
    // mailbox #(sequence_item_class) mon_out_2_cov = new(1);

    // mailbox #(sequence_item_class) mon_in_2_scb = new(1);
    // mailbox #(sequence_item_class) mon_in_2_cov = new(1);

    function new (virtual FIFO_if vif);
        this.vif = vif;
        build_env();
        connect_env();
    endfunction

    function build_env ();
        agt = new(vif);
        scb = new();
        cvg = new();
    endfunction

    function connect_env ();
        agt.mon.mon_out_2_scb = scb.mon_out_2_scb;
        agt.mon.mon_in_2_scb = scb.mon_in_2_scb;

        agt.mon.mon_out_2_cov = cvg.mon_out_2_cov;
        agt.mon.mon_in_2_cov = cvg.mon_in_2_cov;
    endfunction

    task run_env ();
        fork
            agt.run_agent();
            scb.run_scoreboard();
            cvg.run_coverage();
        join_any
    endtask
endclass