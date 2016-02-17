out = out_hdl(1:out_hdl_col_len,1:out_hdl_row_len);

Err = out - repmat(Vin,out_hdl_col_len,1);

max_error = 1e-3;
[i,j] = find(abs(Err)>max_error);
m = min(i);
k = 1:out_hdl_row_len;
if isempty(i)
   m = 1;   
   figure,
   subplot(3,1,1), plot(k, Vin, k, out(m,:)); title(['Vector #' num2str(m) ' (no error in ' num2str(out_hdl_col_len) ' vectors)']);   
else
   figure,
   subplot(3,1,1), plot(k, Vin, k, out(m,:)); title(['Vector #' num2str(m)]);   
end
legend('Matlab', 'VHDL');
subplot(3,1,2), plot(k, Err(m,:)); title('Absolute error');
subplot(3,1,3), plot(k, Err(m,:)./out(m,:)*100); title('Relative error'); ylabel('%');
clear i; clear j;