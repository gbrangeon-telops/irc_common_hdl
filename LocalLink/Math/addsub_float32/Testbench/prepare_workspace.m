n = 1000;

A_exp = 10;
A_base = fix((rand(1,n)-0.5)*2*2^20); % Random vector from -2^20 to 2^20

B_exp = 12;
B_base = fix((rand(1,n)-0.5)*2*2^20);
operation = 0;

AddSub = (A_base.*2.^A_exp) + (B_base.*2.^B_exp);

% Figure out the correct exponent for the 21-bit block floating-point representation
bit_range = ceil(log2(max(abs(AddSub)))) + 1;
fi_expon = bit_range-21;

A_hdl = [A_exp A_base];
B_hdl = [B_exp B_base];

% Use the exponent for easier Matlab/HDL comparison
A = single(A_base.*2^A_exp);
B = single(B_base.*2^B_exp);
AddSub = A + B;

