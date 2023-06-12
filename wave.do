onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/key_i
add wave -noupdate -radix hexadecimal /tb/PERIOD_100MHZ
add wave -noupdate -radix hexadecimal /tb/start
add wave -noupdate -radix hexadecimal /tb/enc_dec
add wave -noupdate -radix hexadecimal /tb/reset
add wave -noupdate -radix hexadecimal /tb/clock
add wave -noupdate -radix hexadecimal /tb/data_i
add wave -noupdate -radix hexadecimal /tb/key_i
add wave -noupdate -radix hexadecimal /tb/busy
add wave -noupdate -radix hexadecimal /tb/ready
add wave -noupdate -radix hexadecimal /tb/data_o
add wave -noupdate -radix hexadecimal /tb/cripto/EA
add wave -noupdate -radix hexadecimal /tb/cripto/EF
add wave -noupdate -radix hexadecimal /tb/cripto/for_num
add wave -noupdate -radix hexadecimal /tb/cripto/done_sig_1
add wave -noupdate -radix hexadecimal /tb/cripto/done_sig_2
add wave -noupdate -radix hexadecimal /tb/cripto/K
add wave -noupdate -radix hexadecimal /tb/cripto/I
add wave -noupdate -radix hexadecimal /tb/cripto/J
add wave -noupdate -radix hexadecimal /tb/cripto/CONT
add wave -noupdate -radix hexadecimal /tb/cripto/CM1
add wave -noupdate -radix hexadecimal /tb/cripto/N1
add wave -noupdate -radix hexadecimal /tb/cripto/N2
add wave -noupdate -radix hexadecimal /tb/cripto/SN
add wave -noupdate -radix hexadecimal /tb/cripto/NI
add wave -noupdate -radix hexadecimal /tb/cripto/s_box
add wave -noupdate -radix hexadecimal /tb/cripto/KEY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {560 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {2048 ns}
