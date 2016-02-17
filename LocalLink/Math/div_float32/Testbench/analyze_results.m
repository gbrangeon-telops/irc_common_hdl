Quot = Num ./ Den;

n = length(Quot);

k = 1:n;

Quot = repmat(Quot,valid_vectors,1);
Error = hdl_out(1:valid_vectors,1:hdl_out_len)-Quot;

% Find first error and plot it
[i,j] = find(abs(Error)>2^fi_expon);
m = min(i);
if isempty(i)
   m = 1;
   figure, plot(k, Quot, k, hdl_out(m,1:hdl_out_len)); title(['Result of vector #' num2str(m) ' (no error in ' num2str(valid_vectors) ' vectors)']);
   legend('Matlab', 'VHDL');
   figure, plot(k, Error(m,:)); title(['Error in vector #' num2str(m) ' (no error in ' num2str(valid_vectors) ' vectors)']);
else
   figure, plot(k, Quot, k, hdl_out(m,1:hdl_out_len)); title(['Result of vector #' num2str(m)]);
   legend('Matlab', 'VHDL');
   figure, plot(k, Error(m,:)); title(['Error in vector #' num2str(m)]);
end
return

Error = zeros(1,n);
Error(err_k) = 1;
figure, plot(k, Error); title('Error');
ylim([0 1.2]);