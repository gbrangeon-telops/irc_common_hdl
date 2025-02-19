Version 4
SymbolType BLOCK
TEXT 32 32 LEFT 4 as_fifo_w36_d15
RECTANGLE Normal 32 32 544 640
LINE Wide 0 80 32 80
PIN 0 80 LEFT 36
PINATTR PinName din[35:0]
PINATTR Polarity IN
LINE Normal 0 144 32 144
PIN 0 144 LEFT 36
PINATTR PinName wr_en
PINATTR Polarity IN
LINE Normal 0 176 32 176
PIN 0 176 LEFT 36
PINATTR PinName wr_clk
PINATTR Polarity IN
LINE Normal 0 240 32 240
PIN 0 240 LEFT 36
PINATTR PinName rd_en
PINATTR Polarity IN
LINE Normal 0 272 32 272
PIN 0 272 LEFT 36
PINATTR PinName rd_clk
PINATTR Polarity IN
LINE Normal 144 672 144 640
PIN 144 672 BOTTOM 36
PINATTR PinName rst
PINATTR Polarity IN
LINE Wide 576 80 544 80
PIN 576 80 RIGHT 36
PINATTR PinName dout[35:0]
PINATTR Polarity OUT
LINE Normal 576 144 544 144
PIN 576 144 RIGHT 36
PINATTR PinName full
PINATTR Polarity OUT
LINE Normal 576 176 544 176
PIN 576 176 RIGHT 36
PINATTR PinName almost_full
PINATTR Polarity OUT
LINE Normal 576 272 544 272
PIN 576 272 RIGHT 36
PINATTR PinName overflow
PINATTR Polarity OUT
LINE Wide 576 304 544 304
PIN 576 304 RIGHT 36
PINATTR PinName wr_data_count[3:0]
PINATTR Polarity OUT
LINE Normal 576 368 544 368
PIN 576 368 RIGHT 36
PINATTR PinName empty
PINATTR Polarity OUT
LINE Normal 576 464 544 464
PIN 576 464 RIGHT 36
PINATTR PinName valid
PINATTR Polarity OUT

