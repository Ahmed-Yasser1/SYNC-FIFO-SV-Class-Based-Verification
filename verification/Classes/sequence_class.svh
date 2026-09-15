class sequence_class;
    sequence_item_class seq_item;
    sequencer_class seqr;

    int num_transaction = 100;

    task Assert_reset ();
        repeat (2) begin
            seq_item = new();
            seq_item.rst_n = 1'b0;
            seq_item.wr_en = 1'b0;
            seq_item.rd_en = 1'b0;
            seq_item.data_in = $random;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    task Release_reset ();
        repeat (2) begin
            seq_item = new();
            seq_item.rst_n = 1'b1;
            seq_item.wr_en = 1'b0;
            seq_item.rd_en = 1'b0;
            seq_item.data_in = $random;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    // Initialize FIFO
    task Initialize_FIFO ();
        repeat (8) begin
            seq_item = new();
            seq_item.rst_n = 1'b1;
            seq_item.wr_en = 1'b1;
            seq_item.rd_en = 1'b0;
            seq_item.data_in = 0;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    // write to full FIFO
    task write_to_full_FIFO ();
        repeat (8) begin
            seq_item = new();
            seq_item.rst_n = 1'b1;
            seq_item.wr_en = 1'b1;
            seq_item.rd_en = 1'b0;
            seq_item.data_in = $random;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    // read operations
    task read_operations ();
        repeat (8) begin
            seq_item = new();
            seq_item.rst_n = 1'b1;
            seq_item.wr_en = 1'b0;
            seq_item.rd_en = 1'b1;
            seq_item.data_in = 0;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    // read from empty FIFO
    task read_from_empty_FIFO ();
        repeat (8) begin
            seq_item = new();
            seq_item.rst_n = 1'b1;
            seq_item.wr_en = 1'b0;
            seq_item.rd_en = 1'b1;
            seq_item.data_in = 0;

            seqr.seqr_mb.put(seq_item);
        end
    endtask

    // Randomized test cases
    task Randomized_test_cases ();
        repeat (num_transaction) begin
            seq_item = new();
            assert(seq_item.randomize());
            seq_item.rst_n = 1'b1;
            
            seqr.seqr_mb.put(seq_item);
        end
    endtask
endclass