function [params_r, params_g] = TPS_training(r,lambda_val, image_size_val, kmedian_index_files, thumbnail_file_list)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    Starting Training TPS     %%%%%%%%%%%%%%%%%
%%    Compute U Matrix & Params Vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k_index = 1:size(kmedian_index_files,1)
   for thumbnail_files_index = 1:size(thumbnail_file_list,1)
            load(thumbnail_file_list(thumbnail_files_index,:));
            kmedians_index = load(kmedian_index_files(k_index,:));


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  Find PCA basis for dimenison reducation
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            rg_vector(61,:) = [];
            true_illum(61,:) = [];
            training_set_index = [1:899]'; %kmedians_index; %[1:5343];
            rg_vector_mean = mean(rg_vector(training_set_index,:),1);
            %rg_vector = rg_vector - repmat(rg_vector_mean, [size(rg_vector,1) 1]);
            B = princomp(rg_vector(training_set_index,:));
            %rg_vector = rg_vector*B(:,1:r);

            for lambda_index = 1:size(lambda_val,2)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  testing images that are not in the training set
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                training_data = rg_vector(training_set_index,:);
                training_data_illum = true_illum(training_set_index,:);

                test_data_index = 1:size(rg_vector,1);
                test_data_index(training_set_index) = [];%[5344:11346]; %Larger_5degree_Ind;
                test_data = rg_vector(test_data_index,:);
                test_data_illum = true_illum(test_data_index,:);

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  Solving TPS
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                fprintf('Training TPS %d out of %d.\n',thumbnail_files_index,size(thumbnail_file_list,1));
                %if(lambda_index == 1)                    
                    U_matrix = compute_U_matrix(training_data);
                %end
                lambda = lambda_val(lambda_index);
                U_matrix = U_matrix+lambda*eye(size(U_matrix,1));
                params_r = TPS(training_data,training_data_illum(:,1),U_matrix);
                params_g = TPS(training_data,training_data_illum(:,2),U_matrix);


                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  test_data
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                TPS_dis = []; TPS_ang = [];
                fprintf('Evaluating Input\n');
                for j = 1:length(test_data_index)
                    TPS_r = TPS_estimate(test_data(j,:),params_r,training_data);
                    TPS_g = TPS_estimate(test_data(j,:),params_g,training_data);
                    TPS_illum = [TPS_r TPS_g 1-TPS_r-TPS_g];
                    img_illum = [test_data_illum(j,1) test_data_illum(j,2) 1-test_data_illum(j,1)-test_data_illum(j,2)];
                    [TPS_dis(end+1,1) TPS_ang(end+1,1)] = comp_error(TPS_illum,img_illum);
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %  testing images that are in the training set
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                test_data_index = training_set_index;
                test_data = rg_vector(test_data_index,:);
                test_data_illum = true_illum(training_set_index,:);
                for j = 1:length(test_data_index)

                    %% Updating k-medians
                    %                 candidate_medians_index = [1:size(rg_vector,1)]';
                    %                 candidate_medians_index(training_set_index) = [];
                    %                 cur_kmedians = repmat(test_data(j,:),[size(candidate_medians_index,1) 1]);
                    %                 diff = sqrt(sum(((rg_vector(candidate_medians_index,:) - cur_kmedians).^2),2));
                    %                 [min_val ind] = min(diff,[],1);

                    new_training_set_index = training_set_index;
                    new_training_set_index(j) = [];% candidate_medians_index(ind);
                    new_training_data = rg_vector(new_training_set_index,:);
                    new_training_data_illum = true_illum(new_training_set_index,:);

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %  Solving TPS
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    fprintf('Training TPS %d out of %d.\n',j,size(test_data,1));
                    %if(lambda_index == 1)                        
                        new_U_matrix = compute_U_matrix(new_training_data);
                    %end
                    lambda = lambda_val(lambda_index);
                    new_U_matrix = new_U_matrix+lambda*eye(size(new_U_matrix,1));
                    params_r = TPS(new_training_data,new_training_data_illum(:,1),new_U_matrix);
                    params_g = TPS(new_training_data,new_training_data_illum(:,2),new_U_matrix);


                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %  test_data
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    TPS_r = TPS_estimate(test_data(j,:),params_r,new_training_data);
                    TPS_g = TPS_estimate(test_data(j,:),params_g,new_training_data);
                    TPS_illum = [TPS_r TPS_g 1-TPS_r-TPS_g];
                    img_illum = [test_data_illum(j,1) test_data_illum(j,2) 1-test_data_illum(j,1)-test_data_illum(j,2)];
                    [TPS_dis(end+1,1) TPS_ang(end+1,1)] = comp_error(TPS_illum,img_illum);
                    %[max(TPS_ang) norm(TPS_ang)/sqrt(size(test_data,1)) median(TPS_ang)  max(TPS_dis) norm(TPS_dis)/sqrt(size(test_data,1)) median(TPS_dis)]
                end

                stat_result = stat_result + 1;
                stat_result_stored(stat_result,1:8) = [r lambda max(TPS_ang) norm(TPS_ang)/sqrt(size(test_data,1)) median(TPS_ang)  max(TPS_dis) norm(TPS_dis)/sqrt(size(test_data,1)) median(TPS_dis)]
                return
            end
        end
    end
end
return;
