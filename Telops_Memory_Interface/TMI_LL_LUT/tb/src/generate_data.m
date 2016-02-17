filename = 'D:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\tb\src\input_data.raw';

fid = fopen(filename,'w');

number_of_point = 25000;

for i = 1 : number_of_point
    random = floor(rand() * 10000);
    fwrite(fid, random,'single');
    %fseek(fid, -1, 'cof');
    %fprintf(fid, '\n');
end;

fclose(fid);
