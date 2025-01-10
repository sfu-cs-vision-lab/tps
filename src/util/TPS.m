function TPS_params = TPS(source_data,target_data,U)

data_size = size(source_data,1);
zeros_num = size(source_data,2)+1;

Q = [ones(data_size,1) source_data];
L = [U Q; Q' zeros(zeros_num,zeros_num)];

K = [target_data ; zeros(size(source_data,2)+1,size(target_data,2))];

TPS_params = L\K;
%TPS_params = (K'/L)';
%TPS_params = pinv(L)*K;
%TPS_params = (K*pinv(L))';


