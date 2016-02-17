function []= mat2vhdl(x, filename, permission)
% This function takes a vector as an argument and writes this variable
% into a file suitable for vhdl simulation entry.
%
% Patrick Dubois
% August 2007

if nargin < 3
    permission = 'wt';
end

width = size(x,2);
height = size(x,1);

x = int32(x)

fid = fopen(filename, permission);
for i = 1:height, 
   for j = 1:width,
      fprintf(fid, '%d', x(i,j));
      if (j ~= width)
         fprintf(fid, ' ');  
      end      
   end   

   if (i ~= height)
      fprintf(fid, '\n');  
   end
end
fprintf(fid, '\n');  
fclose(fid);