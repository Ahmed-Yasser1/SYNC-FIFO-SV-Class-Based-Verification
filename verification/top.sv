module top ();
    import pkg::*;

    logic clk;

    test_class test;

    virtual FIFO_if vif;

    FIFO_if fifo_if (clk);

    FIFO dut (fifo_if);

    bind FIFO assertions fifo_sva (intf);

    initial begin
        clk = 0;
        forever
            #5 clk = ~ clk;
    end

    initial begin
        vif = fifo_if;
        test = new(vif);
        test.run_test();
    end

    initial begin
        #1420;
        $stop;
    end

    final begin
        test.env.scb.report();
    end
endmodule