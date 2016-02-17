
function analyseSimdat(NumbOfFrames, NumbOElementsInFrame, signed)
%%clear all;
global A_orig
generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed)
FID = fopen('./dat/bfp_stimulo.dat','r');
A_sim = fread(FID,[NumbOElementsInFrame,NumbOfFrames],'single');

%%Uncomment the following line to introduce an error.
%A_sim(3)=0; 

Res = sum(sum(abs(A_orig - A_sim)>eps));
if(Res(1)==0)
    disp('The simulation output file and the expected result match');
else
    warning('The simulation output file does NOT match the expected result!!!!');
end
fclose(FID);
clear A_orig A_sim;
