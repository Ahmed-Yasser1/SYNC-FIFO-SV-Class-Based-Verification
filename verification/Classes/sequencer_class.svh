class sequencer_class;
    sequence_item_class seq_item;

    mailbox #(sequence_item_class) seqr_mb;

    function new ();
        seqr_mb = new(1);
    endfunction
endclass