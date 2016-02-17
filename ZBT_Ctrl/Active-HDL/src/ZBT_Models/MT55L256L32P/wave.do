onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb/u1/clk
add wave -noupdate -format Logic /tb/u1/cke_n
add wave -noupdate -format Logic /tb/u1/ce_n
add wave -noupdate -format Logic /tb/u1/ce2_n
add wave -noupdate -format Logic /tb/u1/ce2
add wave -noupdate -format Logic /tb/u1/lbo_n
add wave -noupdate -format Logic /tb/u1/ld_n
add wave -noupdate -format Logic /tb/u1/bwa_n
add wave -noupdate -format Logic /tb/u1/bwb_n
add wave -noupdate -format Logic /tb/u1/bwc_n
add wave -noupdate -format Logic /tb/u1/bwd_n
add wave -noupdate -format Logic /tb/u1/rw_n
add wave -noupdate -format Literal -radix unsigned /tb/u1/addr
add wave -noupdate -format Literal -radix unsigned /tb/u1/dq
add wave -noupdate -format Logic /tb/u1/oe_n
add wave -noupdate -format Logic /tb/u1/zz
add wave -noupdate -divider {Internal Signals}
add wave -noupdate -format Literal -radix unsigned /tb/u1/dout
add wave -noupdate -format Logic -radix binary /tb/u1/doe
add wave -noupdate -format Literal -radix unsigned /tb/u1/main/addr_in
add wave -noupdate -format Literal -radix unsigned /tb/u1/main/addr_read
add wave -noupdate -format Literal -radix unsigned /tb/u1/main/addr_write
add wave -noupdate -format Logic /tb/u1/main/ce_in
add wave -noupdate -format Literal /tb/u1/main/rw_in
add wave -noupdate -format Literal /tb/u1/main/bwa_in
add wave -noupdate -format Literal /tb/u1/main/bwb_in
add wave -noupdate -format Literal /tb/u1/main/bwc_in
add wave -noupdate -format Literal /tb/u1/main/bwd_in
add wave -noupdate -format Literal /tb/u1/main/bcnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {75000 ps} {52500 ps}
WaveRestoreZoom {0 ps} {162750 ps}
configure wave -namecolwidth 165
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
