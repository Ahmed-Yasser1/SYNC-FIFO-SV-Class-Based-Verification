class test_class;
    environment_class env;
    sequence_class seq;

    virtual FIFO_if vif;


    function new (virtual FIFO_if vif);
        this.vif = vif;
        build_test();
        connect_test();
    endfunction

    function build_test ();
        env = new(vif);
        seq = new();
    endfunction

    function connect_test ();
        seq.seqr = env.agt.seqr;
    endfunction

    task run_seq ();
        $display("");
        $display("--------------- Assert Reset ---------------");
        $display("");
        seq.Assert_reset();
        repeat (2) @(posedge vif.clk);

        seq.Release_reset();
        #1;
        $display("");
        $display("--------------- Release Reset ---------------");
        $display("");
        repeat (2) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- FIFO Intialization ---------------");
        $display("");
        seq.Initialize_FIFO();
        repeat (3) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- Try to Write ---------------");
        $display("");
        seq.write_to_full_FIFO();
        repeat (2) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- Read Operation ---------------");
        $display("");
        seq.read_operations();
        repeat (3) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- Try to Read ---------------");
        $display("");
        seq.read_from_empty_FIFO();
        repeat (2) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- Random Test Casses ---------------");
        $display("");
        seq.Randomized_test_cases();
        repeat (2) @(posedge vif.clk);
        
        #1;
        $display("");
        $display("--------------- Assert Reset ---------------");
        $display("");
        seq.Assert_reset();
        repeat (2) @(posedge vif.clk);
    endtask

    task run_test ();        
        fork
            env.run_env();
            run_seq();
        join_none
    endtask
endclass