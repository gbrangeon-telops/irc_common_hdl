function []= mat2rom(x, filename, table_name, values_per_line, hex)
% This function takes a vector as an argument and writes the equivalent
% VHDL ROM constant in a file.
%
% Patrick Dubois
% August 2007

mpath = mfilename();

if nargin < 3
   table_name = 'igm_vector';
end

if nargin < 4
   values_per_line = 10;
end

if nargin < 5
   hex = false;
end

% Make sure than length(x) is a power of 2
lenx = length(x);
p = nextpow2(lenx);
len2 = 2^p;
if lenx < len2
    % Extend x with zeros
    x = [x; zeros(len2 - lenx, 1)];
end

fid = fopen(filename, 'wt');
fprintf(fid, 'type ROM_TABLE is array (0 to %d) of integer range 0 to 65535;\n', length(x)-1);
fprintf(fid, ['-- This table was generated with ' mpath '.m\n']);
fprintf(fid, ['constant ' table_name ' : ROM_TABLE := (\n']);

for i = 1:length(x), 
   if hex
      if i == length(x)
         fprintf(fid, 'x"%8.8X");', x(i)); % No comma for last one
      else
         fprintf(fid, 'x"%8.8X", ', x(i));
      end    
   else
      if i == length(x)
         fprintf(fid, '%d);', x(i)); % No comma for last one
      else
         fprintf(fid, '%d, ', x(i));
      end
   end

   % Line return every x points
   if mod(i,values_per_line) == 0
      fprintf(fid, '\n');    
   end
end

fprintf(fid, '\n');    
fclose(fid);