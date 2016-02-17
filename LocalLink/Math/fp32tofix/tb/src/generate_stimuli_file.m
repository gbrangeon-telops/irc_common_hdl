function generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed)
%%
%%     usage: generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed);
%%     where : NumbOfFrames is a number of Frames to generate
%%             NumbOElementsInFrame is a number of elements per frames
%%             signed is either 's' for signed numbers or 'u' for unsigned numbers

% Global variable to share:
global A_orig
%% Parameters
len = NumbOElementsInFrame;       % Length of the block floating point vector (without exponent)
nbits = 8;      % Number of bits for LocalLink
%signed = true;
nexp = NumbOfFrames;               % Number of different lines in the file
outputfile = 'D:\Telops\Common_HDL\LocalLink\Math\fp32tofix\tb\src\dat\bfp_stimuli.dat';

% Delete existing file
[status,result] = dos(['del ' outputfile]);

%% Init matrix that is used for later comparaison with sim data
A_orig=zeros(len,nexp);

%%generate random exponent
if nexp == 1
    blkexp = -4;    % Value of the block floating point exponent
else
    blkexp = fix(rand(nexp, 1)*30 - 15);
end

for k = 1:nexp,
    %% Generate a random vector between 0 and 1 (or -1 to +1)
    rand('twister', 5489+k); % Set rand to its initial state.
    vec = rand(len,1);

    %% Scale the range considering nbits & signed
    % For example, with nbits = 8, the possible values are from (-128 to 127)
    if signed =='s'
        vec_fix = round(vec*2^(nbits)) - 2^(nbits-1);
        max_val = 2^(nbits-1) - 1;
    elseif signed =='u'
            vec_fix = round(vec*2^(nbits));
            max_val = 2^nbits - 1;
    end

    % Make sure that there is no overflow
    vec_fix(vec_fix>max_val) = max_val;
    
    % Store generated data for later compare with sim data
    A_orig(:,k) = vec_fix;

    %% Now convert this vector to block floating point format
    bfp = [blkexp(k); vec_fix];

    %% Scale the range to the full real-world values considering blkexp
    % For example, with nbits = 8 and blkexp = -4, the possible real-world
    % values are from (-128 to 127)/16 = -8 to 7.9375
    % vec_real are the values that we expect at the output of fixtofp32.
   % vec_real = vec_fix * 2^blkexp(k);

    %% Generate the stimuli file
    mat2vhdl(bfp.', outputfile, 'a');
end
end