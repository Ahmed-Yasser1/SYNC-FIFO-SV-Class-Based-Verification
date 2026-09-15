interface FIFO_if (clk);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    localparam max_fifo_addr = $clog2(FIFO_DEPTH);

    input logic clk;

    logic [FIFO_WIDTH - 1 : 0] data_in;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    
    logic [FIFO_WIDTH - 1 : 0] data_out;
    logic wr_ack;
    logic overflow;
    logic full;
    logic empty;
    logic almostfull; 
    logic almostempty;
    logic underflow;

    clocking driv_cb @ (posedge clk);
        default output #0;
        output data_in;
        output rst_n;
        output wr_en;
        output rd_en;
    endclocking

    clocking mon_cb @ (posedge clk);
        default input #0;
        input data_in;
        input rst_n;
        input wr_en;
        input rd_en;
        input data_out;
        input wr_ack;
        input overflow;
        input full;
        input empty;
        input almostfull;
        input almostempty;
        input underflow;
    endclocking

    modport DUT (
        input clk, data_in, rst_n, wr_en, rd_en,
        output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );

    modport ASSERTIONS (
        input clk, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );
endinterface
