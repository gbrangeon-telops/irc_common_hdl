function generate_3params_file(NumbOfFrames, NumbOElementsInFrame)
%% Function to generate 3 fixed point parametres and mix them into a single
%% LL stream.
%%     usage: generate_stimuli_file(NumbOfFrames, NumbOElementsInFrame, signed);
%%     where : NumbOfFrames is a number of Frames to generate
%%             NumbOElementsInFrame is a number of elements per frames

%Globale variables to share:
global A_orig B_orig C_orig

%% Parameters
len = NumbOElementsInFrame;               % Length of the block floating point vector (without exponent)
nexp = NumbOfFrames;     % Number of different lines in the file
rand('twister', 1111);  % Init random number generator
outputfile = 'D:\Telops\Common_HDL\LocalLink\Math\fixtofp32\tb\src\dat\bfp_3params.dat';

Toff_nbit = 11;
Toff_mode = 'fixed';

gamma_nbit = 9;
gamma_mode = 'fixed';

Coff_nbit = 12;
Coff_mode = 'ufixed';

if nexp == 1
    Coff_exp_v = 2;
    gamma_exp_v = -26;
    Toff_exp_v = -8;
else
    Coff_exp_v = fix(rand(nexp, 1)*30 - 15);
    gamma_exp_v = fix(rand(nexp, 1)*30 - 15);
    Toff_exp_v = fix(rand(nexp, 1)*30 - 15);
end

%% Init matrix
A_orig=zeros(len,nexp);
B_orig=zeros(len,nexp);
C_orig=zeros(len,nexp);


% Delete existing file
[status,result] = dos(['del ' outputfile]);

%% Generate block floating point vectors
for k = 1:nexp,
    Coff_exp = Coff_exp_v(k);
    gamma_exp = gamma_exp_v(k);
    Toff_exp = Coff_exp_v(k);

    [Toff_real, Toff_bfp] = gen_bfp_data(Toff_nbit, Toff_exp, Toff_mode, len, 5490+k);
    A_orig(:,k) = Toff_real.';

    [gamma_real, gamma_bfp] = gen_bfp_data(gamma_nbit, gamma_exp, gamma_mode, len, 6491+k);
    B_orig(:,k) = gamma_real.';

    [Coff_real, Coff_bfp] = gen_bfp_data(Coff_nbit, Coff_exp, Coff_mode, len, 7489+k);
    C_orig(:,k) = Coff_real.';
    
    % Declare quantizer objects for exponents    
    Coff_exp_q = quantizer('fixed','floor','wrap',[Coff_nbit,0]);
    Toff_exp_q = quantizer('fixed','floor','wrap',[Toff_nbit,0]);
    gamma_exp_q = quantizer('fixed','floor','wrap',[gamma_nbit,0]); 
    
    % First merging step for exponents
    q_out1 = quantizer('ufixed','floor','wrap',[Toff_nbit + gamma_nbit,0]);
    out1 = accel_bitmerge(gamma_bfp(1), Toff_bfp(1), gamma_exp_q, Toff_exp_q, q_out1);

    % Second merging step for exponents
    q_out = quantizer('fixed','floor','wrap',[32,0]);
    bfp_exp = accel_bitmerge(Coff_bfp(1), out1, Coff_exp_q, q_out1, q_out);    

    % Declare quantizer objects for mantissa
    Coff_q = quantizer(Coff_mode,'floor','wrap',[Coff_nbit,0]);
    Toff_q = quantizer(Toff_mode,'floor','wrap',[Toff_nbit,0]);
    gamma_q = quantizer(gamma_mode,'floor','wrap',[gamma_nbit,0]);    
    
    % First merging step for mantissa   
    out1 = accel_bitmerge(gamma_bfp(2:end), Toff_bfp(2:end), gamma_q, Toff_q, q_out1);

    % Second merging step for mantissa
    mantissa = accel_bitmerge(Coff_bfp(2:end), out1, Coff_q, q_out1, q_out);
    
    % Merge exponents and mantissa
    bfp = [bfp_exp; mantissa];

    % Generate the stimuli file (32 bit decimal) signed data, in append mode
    mat2vhdl(bfp.', outputfile, 'a');
end


%assignin('base','A_org',A_orig);
%assignin('base','B_org',B_orig);
%assignin('base','C_org',C_orig);

function [vec_real, bfp] = gen_bfp_data(nbits, blkexp, mode, len, seed)

%% Generate a random vector between 0 and 1 (or -1 to +1)
rand('twister', seed); % Set rand to its initial state.
vec = rand(len,1);

%% Scale the range considering nbits & signed
% For example, with nbits = 8, the possible values are from (-128 to 127)
if strcmp(mode, 'fixed')
    vec_fix = round(vec*2^(nbits)) - 2^(nbits-1);
    max_val = 2^(nbits-1) - 1;
elseif strcmp(mode, 'ufixed')
    vec_fix = round(vec*2^(nbits));
    max_val = 2^nbits - 1;
else
    error
end

% Make sure that there is no overflow
vec_fix(vec_fix>max_val) = max_val;

%% Now convert this vector to block floating point format
bfp = [blkexp; vec_fix];

%% Scale the range to the full real-world values considering blkexp
% For example, with nbits = 8 and blkexp = -4, the possible real-world
% values are from (-128 to 127)/16 = -8 to 7.9375
% vec_real are the values that we expect at the output of fixtofp32.
vec_real = vec_fix * 2^blkexp;


