function [ w_scores] = fscore(globalImg, positiveImg, negativeImg)
    %
    [~,bp] = size(positiveImg);
    positive_length = length(positiveImg(:,1));
    negative_length = length(negativeImg(:,1));

    %
    for i = 1 : bp
        clear meanGlobal meanPositive varPostitive meanNegative varNegative top_1 top_2
        meanGlobal = mean(globalImg(:,i));
        meanPositive = mean(positiveImg(:,i));
        varPostitive = variance(positiveImg(:,i));
        meanNegative = mean(negativeImg(:,i));
        varNegative = variance(negativeImg(:,i));

        top_1 = (positive_length*((meanPositive - meanGlobal)^2));
        top_2 = (negative_length*((meanNegative - meanGlobal)^2));
        w_scores(i) = ((top_1 + top_2) / ((positive_length*(varPostitive^2) + negative_length*(varNegative^2) )));
    end %end for column
end % end function