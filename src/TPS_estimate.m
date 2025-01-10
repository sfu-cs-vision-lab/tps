%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Given an new input image, predict its r or g illumination value
%  X:  Input Image Information m * d: m is the size of test set, d is the dimension
%  params:       illumination r (or g) params, (N + d +1) * 1
%  C: Training Data Size  n *d 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = TPS_estimate(X,params,C)

U = compute_U_matrix(X,C);
f = [U ones(size(X,1),1) X] * params;