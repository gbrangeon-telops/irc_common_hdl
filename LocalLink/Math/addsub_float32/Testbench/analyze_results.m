AddSub = A + B;

n = length(AddSub);

k = 1:n;

AddSub = repmat(AddSub,valid_vectors,1);
Error = hdl_out(1:valid_vectors,:)-AddSub;

% Find first error and plot it
[i,j] = find(abs(Error)>2^fi_expon);
m = min(i);
if isempty(i)
   m = 1;
   figure, plot(k, AddSub, k, hdl_out(m,:)); title(['Result of vector #' num2str(m) ' (no error in ' num2str(valid_vectors) ' vectors)']);
   legend('Matlab', 'VHDL');
   figure, plot(k, Error(m,:)); title(['Error in vector #' num2str(m) ' (no error in ' num2str(valid_vectors) ' vectors)']);
else
   figure, plot(k, AddSub, k, hdl_out(m,:)); title(['Result of vector #' num2str(m)]);
   legend('Matlab', 'VHDL');
   figure, plot(k, Error(m,:)); title(['Error in vector #' num2str(m)]);
end
return

Error = zeros(1,n);
Error(err_k) = 1;
figure, plot(k, Error); title('Error');
ylim([0 1.2]);