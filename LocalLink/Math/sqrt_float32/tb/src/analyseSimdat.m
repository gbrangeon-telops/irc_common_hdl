function analyseSimdat(NumbOElementsInFrame)
%%
%% usage: generate_stimuli_file(NumbOElementsInFrame);
%%     where : NumbOElementsInFrame is a number of elements per frames
%%

global A_orig

generate_data(NumbOElementsInFrame);
FID = fopen('./dat/stimulo.dat','r');
A_sim = fread(FID,(NumbOElementsInFrame),'single=>single');
A_orig = sqrt(single(A_orig));
Res = sum(abs(A_orig - A_sim)>eps);
if(Res(1)==0)
        disp('The simulation output file and the expected result match');
    else
        warning('The simulation output file does NOT match the expected result!!!!');
end
    
fclose(FID);
clear A_orig A_sim; 
end