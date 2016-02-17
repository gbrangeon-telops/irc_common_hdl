clear all;


%% Getting the data
input_filename =  'D:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\tb\src\input_data.raw';
output_filename =  'D:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\tb\src\output_data.raw';

input_file = fopen(input_filename);
output_file = fopen(output_filename);

input_data = fread(input_file, 'single');
output_data = fread(output_file, 'uint32');

output_data(1) = [];  % To erase the first element.  To remove after the bug with fixpoint is fixed.

fclose('all');

%% Test parameter

xmin = 1000;
xmax = 7000;
lutsize = 1024;
filter_num = 0;

xrange = xmax-xmin;
lutsize_m1 = lutsize - 1;
start_add = lutsize * filter_num;
end_add = start_add + lutsize - 1;

%% Processing the data

data_processed = zeros(size(input_data));
for i = 1: length(input_data)
    data_processed(i) = min(max(floor(((input_data(i)- xmin)/xrange)*lutsize_m1),0) + start_add,end_add);
end;


%% Comparing data_processed with the output_data

k = 1;
error_line = [];
for i = 1 : length(output_data)
    if(output_data(i) ~= data_processed(mod(i-1,length(input_data))+1))
        error_line(k) = i;
        k = k + 1;
    end
end

fprintf('Min output_value = %d\n',min(output_data));
fprintf('Max output_value = %d\n',max(output_data));
fprintf('Min input_value = %d\n',min(input_data));
fprintf('Max input_value = %d\n',max(input_data));
fprintf('Number of data evaluated = %d\n',length(output_data));


if isempty(error_line)
    disp('No error found');
else
    disp('Error found at lines');
    disp(error_line);
end;




