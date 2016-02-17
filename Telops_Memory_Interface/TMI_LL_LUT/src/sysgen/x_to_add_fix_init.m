%%This file Initialize the histogram before the model generation

Ts = 1;
x_data_nb = 16;
x_min_nb = 16;
x_range_nb = 16;
lut_size_m1_nb = 16;
start_add_nb = 16;
end_add_nb = 16;

%fraction_nb = 16;



% %% Test Vector A
% %Write en mem 
% rx_data=[0 21000];
% rx_dval=[0 1];
% rx_sof=[0 1];
% rx_eof=[0 0];
% y_busy=[0 0];
% y_afull=[0 0];
% x_min=[0 0];
% x_range=[0 35000];
% lut_size_m1=[0 255];
% start_add=[0 0];
% end_add=[0 255];

%% Test Vector B
%Valider le générateur d'adresse

% simlength = 1100;
% datalength = 1000;
% 
% x_min=[0 5000];
% x_range=[0 25000];
% lut_size_m1=[0 255];
% start_add=[0 0];
% end_add=[0 255];
% 
% time = 0:1:datalength-1;
% data = 0:35000/datalength:35000-1;
% dval = ones(1,datalength);
% sof  = [1 zeros(1,datalength-1)];
% eof  = [zeros(1,datalength-1) 1];
% busy = zeros(1,datalength);
% afull = zeros(1,datalength);
% 
% rx_data=[time' data'];
% rx_dval=[time' dval'];
% rx_sof=[time' sof'];
% rx_eof=[time' eof'];
% y_busy=[time' busy'];
% y_afull=[time' afull'];
% 
% sim('X_to_ADD_fix', simlength);
% 
% dataout=zeros(simlength,2);
% j=1;
% for i=1:1:simlength
%     if(simout.signals.values(i,2) == 1 && j<=datalength)
%         dataout(j,1)=simout.signals.values(i,1);
%         dataout(j,2)=floor(min([(data(j)-x_min(2))/x_range(2)*lut_size_m1(2)+start_add(2) end_add(2)]));
%         j=j+1;
%     end
% end

%% Test Vector C
% %Valider le flow Locallink(dval)
% 
% simlength = 1100;
% datalength = 1000;
% 
% x_min=[0 0];
% x_range=[0 35000];
% lut_size_m1=[0 255];
% start_add=[0 0];
% end_add=[0 255];
% 
% time = 0:1:datalength-1;
% data = 0:35000/datalength:35000-1;
% dval = [ones(1,datalength/2) zeros(1,datalength/10) ones(1,4*datalength/10)];
% sof  = [1 zeros(1,datalength-1)];
% eof  = [zeros(1,datalength-1) 1];
% busy = zeros(1,datalength);
% afull = zeros(1,datalength);
% 
% rx_data=[time' data'];
% rx_dval=[time' dval'];
% rx_sof=[time' sof'];
% rx_eof=[time' eof'];
% y_busy=[time' busy'];
% y_afull=[time' afull'];
% 
% sim('X_to_ADD_fix', simlength);
% 
% dataout=zeros(simlength,2);
% j=1;
% for i=1:1:simlength
%     if(simout.signals.values(i,2) == 1 && j<=datalength)
%         dataout(j,1)=simout.signals.values(i,1);
%         j=j+1;
%     end
% end
% 
% j=1;
% for i=1:1:datalength
%     if(dval(i) == 1 && j<=datalength)
%         dataout(j,2)=min([floor((data(i)-x_min(2))/x_range(2)*lut_size_m1(2))+start_add(2) end_add(2)]);
%         j=j+1;
%     end
% end

%% Test Vector D
%Valider le flow Locallink(BUSY)

simlength = 1100;
datalength = 1000;

x_min=[0 0];
x_range=[0 35000];
lut_size_m1=[0 255];
start_add=[0 0];
end_add=[0 255];

time = 0:1:datalength-1;
data = 0:35000/datalength:35000-1;
dval = [ones(1,datalength/2) zeros(1,datalength/10) ones(1,4*datalength/10)];
sof  = [1 zeros(1,datalength-1)];
eof  = [zeros(1,datalength-1) 1];
busy = [zeros(1,2*datalength/5) ones(1,datalength/5)  zeros(1,2*datalength/5)];
afull = zeros(1,datalength);

rx_data=[time' data'];
rx_dval=[time' dval'];
rx_sof=[time' sof'];
rx_eof=[time' eof'];
y_busy=[time' busy'];
y_afull=[time' afull'];

%% Test Vector E
%Valider le générateur d'adresse

simlength = 1100;
datalength = 1000;

x_min=[0 0];
x_range=[0 35000];
lut_size_m1=[0 255];
start_add=[0 0];
end_add=[0 255];

time = 0:1:datalength-1;
data = 0:35000/datalength:35000-1;
dval = [0 ones(1,datalength-1)];
sof  = [0 1 zeros(1,datalength-2)];
eof  = [zeros(1,datalength-1) 1];
busy = zeros(1,datalength);
afull = zeros(1,datalength);
sreset = [1 zeros(1,datalength-1)];

rx_data=[time' data'];
rx_dval=[time' dval'];
rx_sof=[time' sof'];
rx_eof=[time' eof'];
y_busy=[time' busy'];
y_afull=[time' afull'];
sreset_v=[time' sreset'];

sim('X_to_ADD_fix', simlength);

dataout=zeros(simlength,2);
j=1;
for i=1:1:simlength
    if(simout.signals.values(i,2) == 1 && j<=datalength)
        dataout(j,1)=simout.signals.values(i,1);
        dataout(j,2)=floor(min([(data(j)-x_min(2))/x_range(2)*lut_size_m1(2)+start_add(2) end_add(2)]));
        j=j+1;
    end
end





%sim('X_to_ADD_fix', simlength);

dataout=zeros(simlength,2);
j=1;
for i=1:1:simlength
    if(simout.signals.values(i,2) == 1 && simout.signals.values(i,5) == 0 && j<=datalength)
        dataout(j,1)=simout.signals.values(i,1);
        j=j+1;
    end
end

j=1;
for i=1:1:datalength
    if(dval(i) == 1 && busy(i) == 0 && j<=datalength)
        dataout(j,2)=min([floor((data(i)-x_min(2))/x_range(2)*lut_size_m1(2))+start_add(2) end_add(2)]);
        j=j+1;
    end
end



