function generate_data(NumbOElementsInFrame)
%%
%% usage: generate_stimuli_file(NumbOElementsInFrame);
%%     where : NumbOElementsInFrame is a number of elements per frames
%%

global A_orig 
filename = '.\dat\stimuli.dat';

fid = fopen(filename,'w');

rand('twister', 5489); % Set rand to its initial state.
A_orig = rand(NumbOElementsInFrame,1);    
A_orig = A_orig * 1000;

fwrite(fid, A_orig,'single');
fclose(fid);
end
