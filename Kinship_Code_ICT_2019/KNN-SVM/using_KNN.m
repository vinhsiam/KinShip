function Accuracy=using_KNN(Training_input,Sample_input,Labels_Train,Labels_Test)
 
%%INPUT:
%% Labels_Train, Labels_Test : Vector 1 x N
%% LBP_RGB_BARK_Train        : Matrix N x d (d features) 
distance='cityblock';%'euclidean';;'cosine';'correlation'}; 

rule='nearest' ;
i_Number_KNN=10;
 
warning('off','bioinfo:knnclassify:incompatibility');
Class = knnclassify(Sample_input, Training_input, Labels_Train, i_Number_KNN,distance,rule);
Diff=Class -Labels_Test;
ADiff=abs(Diff);
 number=0;
 for i=1:length(ADiff)
    if(ADiff(i)==0)
      number=number+1;
    end
 end
Accuracy=(number/length(ADiff));
end

