function [new_feature] = newFeatureByScore(dataImg, score)
    [dump1,index] = sort(score);
    new_feature=dataImg(:,index(1:end));
end