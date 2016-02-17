filename = 'D:\Telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge\tb\src\input_data_1.raw';

fid = fopen(filename,'w');

number_of_point = 2^8;

for i = 1 : number_of_point
    random = floor(rand() * 10000);
    fwrite(fid, [num2str(random), ' ']);
    if (mod(i,16) == 0)
       fseek(fid, -1, 'cof');
       fprintf(fid,'\n');
    end;
end;

fclose(fid);
