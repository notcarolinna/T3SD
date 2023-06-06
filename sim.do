if {[file isdirectory work]} { vdel -all -lib work }
vlib work
vmap work work

vlog -work work cripto_module.vhd
vlog -work work tb.v

vsim -voptargs=+acc=lprn -t ns work.tb

set StdArithNoWarnings 1
set StdVitalGlitchNoWarnings 1

do wave.do 

run 50 us
