%%This file Initialize the histogram before the model generation

Ts = 1;
Nb_bin = 1024;
Nbit_length = 16;
MaxHistValue_bit = ceil(log2(1280*1024));

%TestVector for activeHDL sim
RandData=round(rand([1 2^Nbit_length])*(2^Nbit_length-1));
TestData=[RandData];
H1=hist(RandData,Nb_bin);
edges=0:64:2^Nbit_length;
H2=histc(RandData,edges);
H=[H1 0;H2];

% %% Test Vector A
% %Write en mem clear
% 
% Rx_data = [0:1:2^Nbit_length-1;0:1:2^Nbit_length-1]';
% Rx_dval = [0:1:2^Nbit_length-1;ones(1,2^Nbit_length)]';
% Rx_sof_value = [1 zeros(1,2^(Nbit_length-2)-1)];
% Rx_eof_value = [zeros(1,2^(Nbit_length-2)-1) 1];
% Rx_sof = [0:1:2^Nbit_length-1;Rx_sof_value Rx_sof_value Rx_sof_value Rx_sof_value]';
% Rx_eof = [0:1:2^Nbit_length-1;Rx_eof_value Rx_eof_value Rx_eof_value Rx_eof_value]';
% 
% Clear_Mem =[0:1:2^Nbit_length-1;zeros(1,2^(Nbit_length-1)+25) 1 zeros(1,2^(Nbit_length-1)-26)]';

%% Test Vector B
% Write then read
% 
% 
% Rx_data = [0:1:2^Nbit_length-1;0:1:(2^(Nbit_length-1)-1) 0 1*2^6 2*2^6 3*2^6 4*2^6 5*2^6 6*2^6 7*2^6 0:1:(2^(Nbit_length-1)-9)]';
% Rx_dval = [0:1:2^Nbit_length-1;ones(1,2^(Nbit_length-1)) zeros(1,2^(Nbit_length-1))]';
% Rx_sof_value = [1 zeros(1,2^(Nbit_length-2)-1)];
% Rx_eof_value = [zeros(1,2^(Nbit_length-2)-1) 1];
% Rx_sof = [0:1:2^Nbit_length-1;Rx_sof_value Rx_sof_value zeros(1,2^(Nbit_length-1)) ]';
% Rx_eof = [0:1:2^Nbit_length-1;Rx_eof_value Rx_eof_value zeros(1,2^(Nbit_length-1))]';
% Clear_Mem =[0:1:2^Nbit_length-1;zeros(1,2^Nbit_length)]';

%% Test Vector C
%Write
% 
% Rx_data = [0:1:2^(Nbit_length+1)-1;0:1:2^Nbit_length-1 0:1:2^Nbit_length-1]';
% Rx_dval = [0:1:2^(Nbit_length+1)-1;ones(1,2^(Nbit_length+1))]';
% Rx_sof_value = [1 zeros(1,2^(Nbit_length)-1) 1 zeros(1,2^(Nbit_length)-1)];
% Rx_eof_value = [zeros(1,2^(Nbit_length)-1) 1 zeros(1,2^(Nbit_length)-1) 1];
% Rx_sof = [0:1:2^(Nbit_length+1)-1;Rx_sof_value]';
% Rx_eof = [0:1:2^(Nbit_length+1)-1;Rx_eof_value]';
% 
% Clear_Mem =[0:1:2^(Nbit_length+1)-1;zeros(1,2^(Nbit_length+1))]';

%% Test Vector D
%WRite with Dval that go to 0 during a write.
% Rx_data = [0:1:2^(Nbit_length+1); 0:1:2^(Nbit_length-1)-21 ones(1,10)*(2^(Nbit_length-1)-21) 2^(Nbit_length-1)-20:1:2^(Nbit_length+1)-10 ]';
% Rx_dval = [0:1:2^(Nbit_length+1); ones(1,2^(Nbit_length-1)-20) zeros(1,10) ones(1,2^(Nbit_length-1)) ones(1,2^Nbit_length+11)]';
% Rx_sof_value = [1 zeros(1,2^(Nbit_length+1))];
% Rx_eof_value = [zeros(1,2^(Nbit_length+1)) 1];
% Rx_sof = [0:1:2^(Nbit_length+1);Rx_sof_value]';
% Rx_eof = [0:1:2^(Nbit_length+1);Rx_eof_value]';
% 
% Clear_Mem =[0:1:2^(Nbit_length+1)-1;zeros(1,2^(Nbit_length+1))]';

%% Test VEctor E
% TEST TMI
%WRite with Dval that go to 0 during a write. No clear Mem. Then Read via TMI
Rx_data = [0:1:2^(Nbit_length+1); 0:1:2^(Nbit_length-1)-21 ones(1,10)*(2^(Nbit_length-1)-21) 2^(Nbit_length-1)-20:1:2^(Nbit_length+1)-10 ]';
Rx_dval = [0:1:2^(Nbit_length+1); ones(1,2^(Nbit_length-1)-20) zeros(1,10) ones(1,2^(Nbit_length-1)) ones(1,2^Nbit_length+11)]';
Rx_sof_value = [1 zeros(1,2^(Nbit_length+1))];
Rx_eof_value = [zeros(1,2^(Nbit_length+1)) 1];
Rx_sof = [0:1:2^(Nbit_length+1);Rx_sof_value]';
Rx_eof = [0:1:2^(Nbit_length+1);Rx_eof_value]';
Clear_Mem =[0:1:2^(Nbit_length+1)-1;zeros(1,2^(Nbit_length+1))]';
% 
tmi_add = [0:1:(2^(Nbit_length+1)-1 + Nb_bin+7); zeros(1,2^(Nbit_length+1)+2) 0:1:(Nb_bin-1) 0 0 0 0 0]';
tmi_dval = [0:1:(2^(Nbit_length+1)-1 + Nb_bin+7); zeros(1,2^(Nbit_length+1)+2) ones(1,Nb_bin) 0 0 0 0 0]';
% 
% %%Test Matrix
MOSI = [Rx_data(:,2) Rx_dval(:,2) Rx_sof(:,2) Rx_eof(:,2)]';
TMI = [tmi_add(:,2) tmi_dval(:,2)];