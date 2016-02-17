function [Result]= Comparefile(filename1,filename2)
fid1 = fopen(filename1);
fid2 = fopen(filename2);
ref = fread(fid1);
out = fread(fid2);
Result = isequal(ref, out);
fclose(fid1);
fclose(fid2);