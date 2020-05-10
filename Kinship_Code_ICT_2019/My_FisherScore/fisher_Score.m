function [new_feature_train, new_feature_test,score] = fisher_Score(globalImg_Train,globalImg_Test,Label)
    [a,~] = size(globalImg_Train);
    temp_true = 1;
    temp_false = 1;
    for i = 1 : a
       if( Label(i) == 1)
           positiveImg(temp_true,:) = globalImg_Train(i,:); 
           temp_true = temp_true + 1;
       else
           nagativeImg(temp_false,:) = globalImg_Train(i,:);
           temp_false = temp_false + 1;
       end % end if
    end % end for
    
    % fisher score
    [score] = fscore(globalImg_Train, positiveImg, nagativeImg);
    % new fisher train
    [new_feature_train] = newFeatureByScore(globalImg_Train, score);
    %new fisher test
    [new_feature_test] = newFeatureByScore(globalImg_Test, score);
end %end function