vlib work
vlog *.sv +cover -covercells
vsim -voptargs=+acc work.top -cover -l sim.log
add wave -position insertpoint  \
sim:/top/fifo_if/clk
add wave -position insertpoint  \
sim:/top/fifo_if/rst_n
add wave -position insertpoint  \
sim:/top/fifo_if/wr_en
add wave -position insertpoint  \
sim:/top/fifo_if/rd_en
add wave -position insertpoint  \
sim:/top/fifo_if/data_in
add wave -position insertpoint  \
sim:/top/fifo_if/full
add wave -position insertpoint  \
sim:/top/fifo_if/almostfull
add wave -position insertpoint  \
sim:/top/fifo_if/empty
add wave -position insertpoint  \
sim:/top/fifo_if/almostempty
add wave -position insertpoint  \
sim:/top/fifo_if/overflow
add wave -position insertpoint  \
sim:/top/fifo_if/underflow
add wave -position insertpoint  \
sim:/top/fifo_if/wr_ack
add wave -position insertpoint  \
sim:/top/fifo_if/data_out
add wave -position insertpoint  \
sim:/top/dut/wr_ptr \
sim:/top/dut/rd_ptr
add wave -position insertpoint  \
sim:/top/dut/count
add wave -position insertpoint  \
sim:/top/dut/mem 
run -all
coverage save coverage_save.ucdb -onexit
#quit -sim 
