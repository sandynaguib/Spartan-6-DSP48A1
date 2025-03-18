vlib work
vlog DSP_v2.v DSP_tb_2.v
vsim -voptargs=+acc work.DSP_tb_2
add wave *
add wave   sim:/DSP_tb_2/DUT/A0_out
add wave   sim:/DSP_tb_2/DUT/A0REG
add wave   sim:/DSP_tb_2/DUT/A1_out
add wave   sim:/DSP_tb_2/DUT/A1REG
add wave   sim:/DSP_tb_2/DUT/Adder_2_out
add wave   sim:/DSP_tb_2/DUT/Adder_out
add wave   sim:/DSP_tb_2/DUT/B0_out
add wave   sim:/DSP_tb_2/DUT/B0REG
add wave   sim:/DSP_tb_2/DUT/B1_out
add wave   sim:/DSP_tb_2/DUT/B1REG
add wave   sim:/DSP_tb_2/DUT/B_INPUT
add wave   sim:/DSP_tb_2/DUT/C_out
add wave   sim:/DSP_tb_2/DUT/Carry_cascade
add wave   sim:/DSP_tb_2/DUT/Carry_cascade_out
add wave   sim:/DSP_tb_2/DUT/Carry_out_before_reg
add wave   sim:/DSP_tb_2/DUT/CARRYINREG
add wave   sim:/DSP_tb_2/DUT/CARRYINSEL
add wave   sim:/DSP_tb_2/DUT/CARRYOUTREG
add wave   sim:/DSP_tb_2/DUT/CREG
add wave   sim:/DSP_tb_2/DUT/D_out
add wave   sim:/DSP_tb_2/DUT/DREG
add wave   sim:/DSP_tb_2/DUT/M_out
add wave   sim:/DSP_tb_2/DUT/MREG
add wave   sim:/DSP_tb_2/DUT/Multiplier_out
add wave   sim:/DSP_tb_2/DUT/MUX_1_out
add wave   sim:/DSP_tb_2/DUT/MUX_X_out
add wave   sim:/DSP_tb_2/DUT/MUX_Z_out
add wave   sim:/DSP_tb_2/DUT/OPMODE_out
add wave   sim:/DSP_tb_2/DUT/OPMODEREG
add wave   sim:/DSP_tb_2/DUT/PREG
add wave   sim:/DSP_tb_2/DUT/RSTTYPE

run -all
#quit -sim