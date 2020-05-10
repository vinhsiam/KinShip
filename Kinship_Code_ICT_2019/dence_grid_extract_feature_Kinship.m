function[reshape_features_train1,reshape_features_train2,reshape_features_test1,reshape_features_test2,d_train,d_test,Labels_Train,Labels_Test] =  dence_grid_extract_feature_Kinship(size,color,type,filename_mat,dir)
n = length(filename_mat.pairs);
root = strcat(dir,'\');
n_un = [];
s = uint8(size);
for i = 1:length(filename_mat.pairs);
    n_un = [n_un;filename_mat.pairs{i,1}];
end
un = unique(n_un);
nfold = length(un);
count = 0;

for i = 1:n
    temp = filename_mat.pairs{i,1};
    I_metric(:,:,:,(i-1)*2+1) = imread(strcat(root,filename_mat.pairs{i,3})); % column 3
    I_metric(:,:,:,(i-1)*2+2) = imread(strcat(root,filename_mat.pairs{i,4})); % column 4

    
    if strcmp(color,'RGB_bwrgby') 
        I_metric(:,:,:,(i-1)*2+1) = RGB_bwrgby(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_bwrgby(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_HLS')
        I_metric(:,:,:,(i-1)*2+1) = RGB_HLS(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_HLS(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_HSV')
        I_metric(:,:,:,(i-1)*2+1) = RGB_HSV(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_HSV(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_I1I2I3')
        I_metric(:,:,:,(i-1)*2+1) = RGB_I1I2I3(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_I1I2I3(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_IHLS')
        I_metric(:,:,:,(i-1)*2+1) = RGB_IHLS(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_IHLS(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_ISH')
        I_metric(:,:,:,(i-1)*2+1) = RGB_ISH(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_ISH(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_Lab')
        I_metric(:,:,:,(i-1)*2+1) = RGB_Lab(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_Lab(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_Luv')
        I_metric(:,:,:,(i-1)*2+1) = RGB_Luv(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_Luv(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_rgb')
        I_metric(:,:,:,(i-1)*2+1) = RGB_rgb(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_rgb(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_XYZ')
        I_metric(:,:,:,(i-1)*2+1) = RGB_XYZ(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_XYZ(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_YCbCr')
        I_metric(:,:,:,(i-1)*2+1) = RGB_YCbCr(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_YCbCr(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_YIQ')
        I_metric(:,:,:,(i-1)*2+1) = RGB_YIQ(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_YIQ(I_metric(:,:,:,(i-1)*2+2));
    elseif strcmp(color,'RGB_YUV')
        I_metric(:,:,:,(i-1)*2+1) = RGB_YUV(I_metric(:,:,:,(i-1)*2+1));
        I_metric(:,:,:,(i-1)*2+2) = RGB_YUV(I_metric(:,:,:,(i-1)*2+2));
    end
    
    if( temp <= (nfold-1))
        n_count_train = i;
        Image1_train(:,:,:,i) = I_metric(:,:,:,(i-1)*2+1);      
        Image2_train(:,:,:,i) = I_metric(:,:,:,(i-1)*2+2); 
    else
        Image1_test(:,:,:,i - n_count_train) = I_metric(:,:,:,(i-1)*2+1);        
        Image2_test(:,:,:,i - n_count_train) = I_metric(:,:,:,(i-1)*2+2); 
    end
end
    if(strcmp(type,'u2'))
        features_train1 = lbp_dense_grid(Image1_train,s,1,8,'u2','h');
        features_train2 = lbp_dense_grid(Image2_train,s,1,8,'u2','h');
        features_test1 = lbp_dense_grid(Image1_test,s,1,8,'u2','h');
        features_test2 = lbp_dense_grid(Image2_test,s,1,8,'u2','h');
    else
        features_train1 = lbp_dense_grid(Image1_train,s,1,8,'','h');
        features_train2 = lbp_dense_grid(Image2_train,s,1,8,'','h');
        features_test1 = lbp_dense_grid(Image1_test,s,1,8,'','h');
        features_test2 = lbp_dense_grid(Image2_test,s,1,8,'','h');
    end

reshape_features_train1 = reshape(features_train1, n_count_train, []);
reshape_features_train2 = reshape(features_train2, n_count_train, []);
reshape_features_test1 = reshape(features_test1, i - n_count_train, []);
reshape_features_test2 = reshape(features_test2, i - n_count_train, []);

for i = 1:length(reshape_features_train1(:,1))
    d_train(i,:,:) = chi_square_statistics(reshape_features_train1(i,:),reshape_features_train2(i,:));  
end

for i = 1:length(reshape_features_test1(:,1))
    d_test(i,:,:) = chi_square_statistics(reshape_features_test1(i,:),reshape_features_test2(i,:));  
end

Labels_Train = [];
Labels_Test = [];
for i = 1:n
    if( i <= n_count_train)
        Labels_Train = [Labels_Train;filename_mat.pairs{i,2}];
    else
        Labels_Test = [Labels_Test;filename_mat.pairs{i,2}];
    end
end

end
