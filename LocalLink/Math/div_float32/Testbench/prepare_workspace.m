n = 1000;

Num_exp = 10;
Num_base = fix((rand(1,n)-0.5)*2*2^20); % Random vector from -2^20 to 2^20

Den_exp = -3;
Den_base = fix((rand(1,n)-0.5)*2*2^20);

Quot = (Num_base.*2.^Num_exp) ./ (Den_base.*2.^Den_exp);

% % Find Quotients that are too large for 21 bits
% ind = find(abs(Quot)>2^20);

% % Make the numerator much smaller
% Num_base(ind) = fix(Num_base(ind)/100);
% Den_base(ind) = fix(Den_base(ind)*100);

% Figure out the correct exponent for the 21-bit block floating-point representation
bit_range = ceil(log2(max(abs(Quot)))) + 1;
fi_expon = bit_range-21;

Num_hdl = [Num_exp Num_base];
Den_hdl = [Den_exp Den_base];

% Use the exponent for easier Matlab/HDL comparison
Num = single(Num_base.*2^Num_exp);
Den = single(Den_base.*2^Den_exp);
Quot = Num ./ Den;

