module assertions (FIFO_if.ASSERTIONS asrt);
    //output signals properties
    property prop1;
	    @(posedge asrt.clk) (! asrt.rst_n) |=> ((dut.wr_ptr === 0) && (dut.rd_ptr === 0) && (dut.count === 0));
    endproperty
 
    property prop2;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (asrt.wr_en && ! asrt.full) |=> (asrt.wr_ack);
    endproperty

    property prop3;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (asrt.wr_en && asrt.full) |=> (asrt.wr_ack === 0);
    endproperty

    property prop4;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (asrt.wr_en && asrt.full) |=> (asrt.overflow);
    endproperty

    property prop5;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (asrt.rd_en && asrt.empty) |=> (asrt.underflow);
    endproperty

    property prop6;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (dut.count == 0) |-> (asrt.empty);
    endproperty

    property prop7;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (dut.count == asrt.FIFO_DEPTH) |-> (asrt.full);
    endproperty

    property prop8;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (dut.count == asrt.FIFO_DEPTH - 1) |-> (asrt.almostfull);
    endproperty

    property prop9;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) (dut.count == 1) |-> (asrt.almostempty);
    endproperty

    //internal counters properties
    property prop10;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n) 
	    (asrt.wr_en && ! asrt.rd_en && ! asrt.full) |=> ($stable(dut.rd_ptr) && ((dut.wr_ptr == $past(dut.wr_ptr) + 1'b1) || ($past(dut.wr_ptr) ==7 && 
        dut.wr_ptr == 0)) && (dut.count == $past(dut.count) + 1'b1));
    endproperty

    property prop11;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n)
	    (! asrt.wr_en && asrt.rd_en && ! asrt.empty) |=> ($stable(dut.wr_ptr) && ((dut.rd_ptr == $past(dut.rd_ptr) + 1'b1) || ($past(dut.rd_ptr) ==7 && 
        dut.rd_ptr == 0)) && (dut.count == $past(dut.count) - 1'b1));
    endproperty

    property prop12;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n)
	    (asrt.wr_en && asrt.rd_en && asrt.full) |=> ($stable(dut.wr_ptr) && ((dut.rd_ptr == $past(dut.rd_ptr) + 1'b1) || ($past(dut.rd_ptr) ==7 && dut.rd_ptr == 0)) && 
        (dut.count == $past(dut.count) - 1'b1));
    endproperty

    property prop13;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n)
	    (asrt.wr_en && asrt.rd_en && asrt.empty) |=> ($stable(dut.rd_ptr) && ((dut.wr_ptr == $past(dut.wr_ptr) + 1'b1) || ($past(dut.wr_ptr) ==7 && dut.wr_ptr == 0)) &&
        (dut.count == $past(dut.count) + 1'b1));
    endproperty

    property prop14;
	    @(posedge asrt.clk) disable iff (! asrt.rst_n)
	    (! asrt.wr_en && ! asrt.rd_en && ! asrt.full && ! asrt.empty) |=> ($stable(dut.wr_ptr) && $stable(dut.rd_ptr) && $stable(dut.count));
    endproperty
	  
    prop1_assert : assert property (prop1);
    prop2_assert : assert property (prop2);
    prop3_assert : assert property (prop3);
    prop4_assert : assert property (prop4);
    prop5_assert : assert property (prop5);
    prop6_assert : assert property (prop6);
    prop7_assert : assert property (prop7);
    prop8_assert : assert property (prop8);  
    prop9_assert : assert property (prop9);
    prop10_assert : assert property (prop10);
    prop11_assert : assert property (prop11);
    prop12_assert : assert property (prop12);
    prop13_assert : assert property (prop13);
    prop14_assert : assert property (prop14);

    prop1_cover : cover property (prop1);
    prop2_cover : cover property (prop2);
    prop3_cover : cover property (prop3);
    prop4_cover : cover property (prop4);
    prop5_cover : cover property (prop5);
    prop6_cover : cover property (prop6);
    prop7_cover : cover property (prop7); 
    prop8_cover : cover property (prop8);
    prop9_cover : cover property (prop9);
    prop10_cover : cover property (prop10);
    prop11_cover : cover property (prop11);
    prop12_cover : cover property (prop12);
    prop13_cover : cover property (prop13);
    prop14_cover : cover property (prop14);
endmodule
