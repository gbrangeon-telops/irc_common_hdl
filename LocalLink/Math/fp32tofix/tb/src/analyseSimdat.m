
function analyseSimdat(NumbOfFrames, NumbOElementsInFrame, signed)
%%
%%     usage: generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed);
%%     where : NumbOfFrames is a number of Frames to generate
%%             NumbOElementsInFrame is a number of elements per frames
%%             signed is either 's' for signed numbers or 'u' for unsigned
%%             numbers
global A_orig
Res = 0;
generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed)
% FID = fopen('./dat/bfp_stimulo.dat','r');
% A_sim = fread(FID,[NumbOElementsInFrame,NumbOfFrames],'single');
A_sim_tmp = importdata('./dat/bfp_stimulo.dat');
%A_sim_tmp = A_sim_tmp';
len = size(A_sim_tmp);
NumOfloops = floor(len(1,1)/NumbOfFrames);
if NumOfloops == 0
    warning('There is not enough simulation points to compare with');
else
    for L=0:NumOfloops-1
        for k=1:NumbOfFrames
            A_sim(:,k)=A_sim_tmp(k+(L*NumbOfFrames),:);
        end
        Res = Res + sum(sum(abs(A_orig - A_sim)>eps));
    end
    if(Res(1)==0)
        disp('The simulation output file and the expected result match');
    else
        warning('The simulation output file does NOT match the expected result!!!!');
    end
end
%fclose(FID);
clear A_orig A_sim;
