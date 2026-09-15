class scoreboard_class;
    sequence_item_class in_seq_item;
    sequence_item_class out_seq_item;
    sequence_item_class ex_seq_item;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic [FIFO_WIDTH-1:0] golden_mem[$];
    logic [15 : 0] last_data_out = 16'hxxxx;

    mailbox #(sequence_item_class) mon_out_2_scb = new(1);
    mailbox #(sequence_item_class) mon_in_2_scb = new(1);

    int wr_ptr = 0;
    int rd_ptr = 0;
    int count = 0;
    
    int complete_operation = 0;
    int correct_count = 0;
    int error_count = 0;

    function void golden_model(sequence_item_class in_seq_item, sequence_item_class ex_seq_item);
        parameter FIFO_DEPTH = 8;

        if (!in_seq_item.rst_n) begin
            golden_mem.delete();
            ex_seq_item.expected_wr_ack = 0;
            ex_seq_item.expected_overflow = 0;
            ex_seq_item.expected_underflow = 0;
            ex_seq_item.expected_full = 0;
            ex_seq_item.expected_empty = 1;
            ex_seq_item.expected_almostfull = 0;
            ex_seq_item.expected_almostempty = 0;
        end
        else begin
            int current_size = golden_mem.size();
            logic current_full = (current_size == FIFO_DEPTH);
            logic current_empty = (current_size == 0);
            logic write_allowed = (current_size < FIFO_DEPTH);
            logic read_allowed = (current_size != 0);
        
            // WRITE OPERATION
            if (in_seq_item.wr_en && write_allowed) begin
                golden_mem.push_back(in_seq_item.data_in);
                ex_seq_item.expected_wr_ack = 1;
                ex_seq_item.expected_overflow = 0;
            end
            else begin
                ex_seq_item.expected_wr_ack = 0;
                if (current_full && in_seq_item.wr_en)
                    ex_seq_item.expected_overflow = 1;
                else
                    ex_seq_item.expected_overflow = 0;
            end
        
            // READ OPERATION
            if (in_seq_item.rd_en && read_allowed) begin
                ex_seq_item.expected_data_out = golden_mem.pop_front();
                last_data_out = ex_seq_item.expected_data_out;
                ex_seq_item.expected_underflow = 0;
            end
            else begin
                if (current_empty && in_seq_item.rd_en)
                    ex_seq_item.expected_underflow = 1;
                else
                    ex_seq_item.expected_underflow = 0;
                
                ex_seq_item.expected_data_out = last_data_out;
            end
        end
    
        ex_seq_item.expected_full = (golden_mem.size() == FIFO_DEPTH) ? 1 : 0;
        ex_seq_item.expected_empty = (golden_mem.size() == 0) ? 1 : 0;
        ex_seq_item.expected_almostfull = (golden_mem.size() == (FIFO_DEPTH - 1)) ? 1 : 0;
        ex_seq_item.expected_almostempty = (golden_mem.size() == 1) ? 1 : 0;
    endfunction


    function void compare (sequence_item_class in_seq_item, sequence_item_class out_seq_item, sequence_item_class ex_seq_item);
        if (ex_seq_item.expected_data_out === out_seq_item.data_out &&
            ex_seq_item.expected_wr_ack === out_seq_item.wr_ack &&
            ex_seq_item.expected_overflow === out_seq_item.overflow &&
            ex_seq_item.expected_full === out_seq_item.full &&
            ex_seq_item.expected_empty === out_seq_item.empty &&
            ex_seq_item.expected_almostfull === out_seq_item.almostfull &&
            ex_seq_item.expected_almostempty === out_seq_item.almostempty &&
            ex_seq_item.expected_underflow === out_seq_item.underflow) begin
            
            in_seq_item.print_tr("TRANSACTION");
            out_seq_item.print_actual("ACTUAL");
            ex_seq_item.print_expected("EXPECTED");
            $display("[PASS] Time: %0t | All outputs matched!", $realtime);
            $display("");
            complete_operation++;
            correct_count++;
        end
        else begin
            in_seq_item.print_tr("TRANSACTION");
            out_seq_item.print_actual("ACTUAL");
            ex_seq_item.print_expected("EXPECTED");
            $display("[FAIL] Time: %0t", $realtime);
            $display("");
            complete_operation++;
            error_count++;
        end
    endfunction

    task run_scoreboard ();
        forever begin
            in_seq_item = new();
            out_seq_item = new();
            ex_seq_item = new();

            mon_out_2_scb.get(out_seq_item);
            mon_in_2_scb.get(in_seq_item);

            golden_model(in_seq_item, ex_seq_item);
            compare(in_seq_item, out_seq_item, ex_seq_item);
        end
    endtask

    function void report();
        $display("\n==================================================");
        $display("               FINAL TESTBENCH REPORT             ");
        $display("==================================================");
		$display(" Total Operations Completed Successfully : %0d", complete_operation);
        $display(" Total Operations Executed Successfully  : %0d", correct_count);
        $display(" Total Errors Detected                   : %0d", error_count);
        $display("==================================================\n");
    endfunction
endclass