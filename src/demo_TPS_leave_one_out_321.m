%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo TPS:
%   The following code is to demo TPS-based illumiantion estimation(leave-one-out). 
% Reference:
%     L. Shi, W. Xiong and B. Funt, "Illumination Estimation via Thin-Plate 
% Spline Interpolation," Journal of the Optical Society of America A(JOSA A), 
% Vol. 28, 5, pp. 940-948, 2011 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
addpath('util');
addpath('data');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  load test dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataset = '321';  % specify the dataset to test on
% load the images, stored as an NxD matrix,
% where N is the number of images, D is the dimensionality of each image
load(['thumbnails_sb_321_192']);  
% use only r and g coponents
S = RGB_vector(:,1:end/3) + RGB_vector(:,end/3+1:end/3*2)+ RGB_vector(:,end/3*2+1:end);
DATA = [RGB_vector(:,1:end/3)./S, RGB_vector(:,end/3+1:end/3*2)./S]; 
% load the illuminations
load(['REAL_ILLUM_321'],'-mat');  
REAL_ILLUM = REAL_ILLUM./repmat(sum(REAL_ILLUM,2),[1 3]);
subset = 1:321;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  define the testing sets and training sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(subset);
TEST_SETS = mat2cell(subset', ones(N,1),[1]);   % a vector of test sets
for i=1:size(TEST_SETS,1)
    training_set_indices = subset;
    training_set_indices(i) = [];
    TRAINING_SETS(i,1) = {training_set_indices};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  start training and testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:length(TEST_SETS)
    
    training_set = TRAINING_SETS{i};
    training_data = DATA(training_set,:);
    training_data_illum = REAL_ILLUM(training_set,:);
    
    test_set = TEST_SETS{i};
    test_data = DATA(test_set,:);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %    Starting Training TPS     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('Training TPS %d out of %d.\n',i,N);
    U = compute_U_matrix(training_data);
    
    % train with TPS
    params_r = TPS(training_data,training_data_illum(:,1),U);
    params_g = TPS(training_data,training_data_illum(:,2),U);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  evaluating test data with TPS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tps_illum(1,1) = TPS_estimate(test_data,params_r,training_data);
    tps_illum(1,2) = TPS_estimate(test_data,params_g,training_data);
    
    TPS_ILLUM(TEST_SETS{i},:) = [tps_illum 1-sum(tps_illum)];
end


[L2 Ang] = comp_error(TPS_ILLUM, REAL_ILLUM);
[median(Ang) mean(Ang) max(Ang)]
