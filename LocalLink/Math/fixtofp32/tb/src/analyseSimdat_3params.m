
function analyseSimdat_3params(NumbOfFrames, NumbOElementsInFrame)
%% NumbOfFrames: number of local link frames to generate.

%clear all;
global A_orig B_orig C_orig
Sim1 =0 ; Sim2 = 0; Sim3 = 0; % Init values

generate_3params_file(NumbOfFrames, NumbOElementsInFrame); % this function generates the globales variables A_orig B_orig C_orig
FID1 = fopen('./dat/bfp_stimulo_par1.dat','r');
FID2 = fopen('./dat/bfp_stimulo_par2.dat','r');
FID3 = fopen('./dat/bfp_stimulo_par3.dat','r');
A_sim = fread(FID1,[NumbOElementsInFrame,NumbOfFrames],'single');
B_sim = fread(FID2,[NumbOElementsInFrame,NumbOfFrames],'single');
C_sim = fread(FID3,[NumbOElementsInFrame,NumbOfFrames],'single');

%%Uncomment the following line to introduce an error.
%A_sim(3)=0;

%sum(sum(abs(A_orig - A_sim)>eps));

    Res1 = sum(sum(abs(A_orig - A_sim)>eps));
Res2 = sum(sum(abs(B_orig - B_sim)>eps));
Res3 = sum(sum(abs(C_orig - C_sim)>eps));
if(Res1(1)==0)
    Sim1 = 1;
else
    warning('error: The simulation output file 1 does NOT match the expected result!!!!');
end

if(Res2(1)==0)
    Sim2 = 1;
else
    warning('error: The simulation output file 2 does NOT match the expected result!!!!');
end

if(Res3(1)==0)
    Sim3 = 1;
else
    warning('error: The simulation output file 3 does NOT match the expected result!!!!');
end

if(Sim1 == 1 && Sim2 == 1 && Sim3 == 1) disp('The simulation output files and the expected result files match'); end
clear A_orig B_orig C_orig;
clear A_sim B_sim C_sim;

fclose(FID1);
fclose(FID2);
fclose(FID3);