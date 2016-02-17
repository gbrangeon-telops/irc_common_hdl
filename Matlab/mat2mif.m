function mat2mif(data, nbits, file)

data_b = dec2bin(data, nbits);
fid = fopen(file, 'w');
for k = 1:length(data),
    line = sprintf('%s\n', data_b(k,:));
    fwrite(fid, line, 'char');
end
fclose(fid);