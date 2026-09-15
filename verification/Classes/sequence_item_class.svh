class sequence_item_class;
    // Inputs
    rand logic [15 : 0] data_in;
    logic rst_n;
    rand logic wr_en;
    rand logic rd_en;
    
    // Actual Outpus
    logic [15 : 0] data_out;
    logic wr_ack;
    logic overflow;
    logic full;
    logic empty;
    logic almostfull;
    logic almostempty;
    logic underflow;
    
    // Excecated Outputs
    logic [15 : 0] expected_data_out;
    logic expected_wr_ack;
    logic expected_overflow;
    logic expected_full;
    logic expected_empty;
    logic expected_almostfull;
    logic expected_almostempty;
    logic expected_underflow;
    
    function new ();
        data_in = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
    endfunction

    constraint data_patterns {
        data_in dist {
            16'h0000 := 5,
            16'hFFFF := 5,
            16'hAAAA := 5,
            16'h5555 := 5,
            [16'h0001:16'h00FF] := 20,
            [16'h0100:16'hFFFF] := 60
        };
    }

    function print_tr (string name);
        $display("[%0p] Time : %0t | Inputs : DATA_IN = %0d , WR_EN = %0d , RD_EN = %0d RST_N = %0d", 
                  name, $realtime, data_in, wr_en, rd_en, rst_n);
    endfunction

    function print_actual (string name);
        $display("[%0p] Time : %0t | Outputs : DATA_OUT = %0d , WR_ACK = %0d , OVERFLOW = %0d , FULL = %0d , EMPTY = %0d , ALMOSTFULL = %0d , ALMOSTEMPTY = %0d , UNDERFLOW = %0d",
                  name, $realtime, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    endfunction

    function print_expected (string name);
        $display("[%0p] Time : %0t | Outputs : DATA_OUT = %0d , WR_ACK = %0d , OVERFLOW = %0d , FULL = %0d , EMPTY = %0d , ALMOSTFULL = %0d , ALMOSTEMPTY = %0d , UNDERFLOW = %0d",
                  name, $realtime, expected_data_out, expected_wr_ack, expected_overflow, expected_full, expected_empty,
                  expected_almostfull, expected_almostempty, expected_underflow);
    endfunction
endclass