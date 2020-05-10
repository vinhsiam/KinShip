function [Accuracy] = using_SVM(LBP_RGB_BARK_Train,LBP_RGB_BARK_Test,Labels_Train,Labels_Test)

%%INPUT:
%% Labels_Train, Labels_Test : Vector 1 x N
%% LBP_RGB_BARK_Train        : Matrix N x d (d features)

         gn                      = max(Labels_Train);
         testIdx                 = size(LBP_RGB_BARK_Test,1);
         pairwise                = nchoosek(0:gn,2);                    % 1-vs-1 pairwise models
         svmModel                = cell(size(pairwise,1),1);            % Store binary-classifers
         predTest                = zeros(testIdx,numel(svmModel));      % Store binary predictions
%# classify using one-against-one approach, SVM with 3rd degree poly kernel
for k=1:numel(svmModel)
    k_value=k;
    %# get only training instances belonging to this pair
    COMBINE_TRAIN=[Labels_Train' LBP_RGB_BARK_Train];
    k1=pairwise(k,:);
    dd1=COMBINE_TRAIN((COMBINE_TRAIN(:,1)==k1(1,1)),2:end);
    dd2=COMBINE_TRAIN((COMBINE_TRAIN(:,1)==k1(1,2)),2:end);
    TRAIN_paire=[dd1; dd2];  %Extract Training data for this paire
    Labels_Train_paire=[k1(1,1)*ones(size(dd1,1),1); k1(1,2)*ones(size(dd2,1),1)]; % Create vector Labels for this paire
    
    %# train
   % svmModel{k}             = svmtrain(meas(idx,:), g(idx), ...
    %    'BoxConstraint',2e-1, 'Kernel_Function','polynomial', 'Polyorder',3);
  % SVM model construct
    
     options.MaxIter = 10000000;
     svmModel{k}             = svmtrain(TRAIN_paire, Labels_Train_paire,'Options',options);% , ...
    %svmModel{k}             = svmtrain(TRAIN_paire, Labels_Train_paire);% , ...
    
    %   'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'rbf_sigma',3);
    clear dd1 dd2 TRAIN_paire Labels_Train_paire
    %# test
   
    predTest(:,k)           = svmclassify(svmModel{k}, LBP_RGB_BARK_Test);
end
pred = mode(predTest,2);   % Voting: clasify as the class receiving most votes

%# Calcul confusion matrix
cmat                        = confusionmat(Labels_Test',pred);
Accuracy                         = 100*sum(diag(cmat))./sum(cmat(:));
  fprintf('%.2f%%\n', Accuracy) 
  % fprintf('Confusion Matrix:\n'), disp(cmat)
end
