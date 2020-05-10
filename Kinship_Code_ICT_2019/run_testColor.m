clear all
% need change link based on you put the folder
% for arrFolder_mat and arrFolder
arrFolder_mat = {'D:\Study\MATLAB\KinFaceW-I\meta_data\','D:\Study\MATLAB\KinFaceW-II\meta_data\'};
arrFolder = {'D:\Study\MATLAB\KinFaceW-I\images\','D:\Study\MATLAB\KinFaceW-II\images\'};
arrSubFolder_mat = {'fd_pairs.mat','fs_pairs.mat','md_pairs.mat','ms_pairs.mat'};
arrSubFolder = {'father-dau','father-son','mother-dau','mother-son'};

for i = 1 : 2 % Folder
    for j = 1 : 4 %SubFolder
        % load database
        f = strcat(arrFolder_mat(i),arrSubFolder_mat(j));
        d = strcat(arrFolder(i),arrSubFolder(j));
        filename_mat = load(char(f));
        dir = char(d);
        %%%
        
        % First Color Space
        [features_train1_64_1,features_train2_64_1,features_test1_64_1,features_test2_64_1,d_train_64,d_test_64,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(64,'RGB_YUV','u2',filename_mat,dir);
        [features_train1_32_1,features_train2_32_1,features_test1_32_1,features_test2_32_1,d_train_32,d_test_32,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(32,'RGB_YUV','u2',filename_mat,dir);
        [features_train1_16_1,features_train2_16_1,features_test1_16_1,features_test2_16_1,d_train_16,d_test_16,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(16,'RGB_YUV','u2',filename_mat,dir);
        [features_train1_8_1,features_train2_8_1,features_test1_8_1,features_test2_8_1,d_train_08,d_test_08,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(8,'RGB_YUV','u2',filename_mat,dir);
        % Second Color Space
        [features_train1_64_2,features_train2_64_2,features_test1_64_2,features_test2_64_2,d_train_64,d_test_64,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(64,'RGB_bwrgby','u2',filename_mat,dir);
        [features_train1_32_2,features_train2_32_2,features_test1_32_2,features_test2_32_2,d_train_32,d_test_32,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(32,'RGB_bwrgby','u2',filename_mat,dir);
        [features_train1_16_2,features_train2_16_2,features_test1_16_2,features_test2_16_2,d_train_16,d_test_16,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(16,'RGB_bwrgby','u2',filename_mat,dir);
        [features_train1_8_2,features_train2_8_2,features_test1_8_2,features_test2_8_2,d_train_08,d_test_08,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(8,'RGB_bwrgby','u2',filename_mat,dir);
        % cast color
        Images_train1_64 = cat(2,features_train1_64_1,features_train1_64_2);
        Images_train2_64 = cat(2,features_train2_64_1,features_train2_64_2);
        Images_test1_64 = cat(2,features_test1_64_1,features_test1_64_2);
        Images_test2_64 = cat(2,features_test2_64_1,features_test2_64_2);

        Images_train1_32 = cat(2,features_train1_32_1,features_train1_32_2);
        Images_train2_32 = cat(2,features_train2_32_1,features_train2_32_2);
        Images_test1_32 = cat(2,features_test1_32_1,features_test1_32_2);
        Images_test2_32 = cat(2,features_test2_32_1,features_test2_32_2);

        Images_train1_16 = cat(2,features_train1_16_1,features_train1_16_2);
        Images_train2_16 = cat(2,features_train2_16_1,features_train2_16_2);
        Images_test1_16 = cat(2,features_test1_16_1,features_test1_16_2);
        Images_test2_16 = cat(2,features_test2_16_1,features_test2_16_2);

        Images_train1_8 = cat(2,features_train1_8_1,features_train1_8_2);
        Images_train2_8 = cat(2,features_train2_8_1,features_train2_8_2);
        Images_test1_8 = cat(2,features_test1_8_1,features_test1_8_2);
        Images_test2_8 = cat(2,features_test2_8_1,features_test2_8_2);

        % Concating all blocks
        Images_train1 = cat(2,Images_train1_64,Images_train1_32,Images_train1_16,Images_train1_8);
        Images_train2 = cat(2,Images_train2_64,Images_train2_32,Images_train2_16,Images_train2_8);
        Images_test1 = cat(2,Images_test1_64,Images_test1_32,Images_test1_16,Images_test1_8);
        Images_test2 = cat(2,Images_test2_64,Images_test2_32,Images_test2_16,Images_test2_8);
        % Chi_Square Distance
        for d = 1:size(Images_train1,1)
            d_train_chi(d,:) = chi_square_copy(Images_train1(d,:),Images_train2(d,:));  
        end
        for d = 1:size(Images_test1,1)
            d_test_chi(d,:) = chi_square_copy(Images_test1(d,:),Images_test2(d,:));  
        end

        %%%%%%%%%%%%%%%% Fisher Score %%%%%%%%%%
        [new_feature_train,new_feature_test,score_train] = fisher_Score(d_train_chi,d_test_chi,Labels_Train);
        [~,n] = size(d_train_chi);
        for f = 1 : 200
            clear tmp train test 
            tmp = floor(f*0.005 * n); 
            train = new_feature_train(:,1:tmp); test = new_feature_test(:,1:tmp);
            if i == 1
                Accuracy(j,f) = using_SVM2(train,test,Labels_Train',Labels_Test')
            elseif i == 2
                Accuracy(j + 4,f) = using_SVM2(train,test,Labels_Train',Labels_Test')
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CLEAR OLD DATABASE %
            
        %First Color Space
        clear features_train1_64_1 features_train2_64_1 features_test1_64_1 features_test2_64_1 d_train_64 d_test_64
        clear features_train1_32_1 features_train2_32_1 features_test1_32_1 features_test2_32_1 d_train_32 d_test_32
        clear features_train1_16_1 features_train2_16_1 features_test1_16_1 features_test2_16_1 d_train_16 d_test_16
        clear features_train1_8_1 features_train2_8_1 features_test1_8_1 features_test2_8_1 d_train_08 d_test_08
        %Second Color Space
        clear features_train1_64_2 features_train2_64_2 features_test1_64_2 features_test2_64_2  
        clear features_train1_32_2 features_train2_32_2 features_test1_32_2 features_test2_32_2  
        clear features_train1_16_2 features_train2_16_2 features_test1_16_2 features_test2_16_1
        clear features_train1_8_2 features_train2_8_2 features_test1_8_2 features_test2_8_2
        clear Images_train1_64 Images_train2_64 Images_test1_64 Images_test2_64
        clear Images_train1_32 Images_train2_32 Images_test1_32 Images_test2_32
        clear Images_train1_16 Images_train2_16 Images_test1_16 Images_test2_16
        clear Images_train1_8 Images_train2_8 Images_test1_8 Images_test2_8
        %
        clear Images_train1 Images_train2 Images_test1 Images_test2
        clear d_train_chi d_test_chi
        clear new_feature_train new_feature_test score_train
        clear tmp train test
        %                    %
    end
end



