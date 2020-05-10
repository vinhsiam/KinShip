function [positiveImg,nagativeImg] = seperateImg(globalImg,Label)
    [a,b] = size(globalImg);
    temp_true = 1;
    temp_false = 1;
    for i = 1 : a
       if( Label(i) == 1)
           positiveImg(temp_true,:) = globalImg(i,:);
           temp_true = temp_true + 1;
       else
           nagativeImg(temp_false,:) = globalImg(i,:);
           temp_false = temp_false + 1;
       end % end if
    end % end for
    
end %end function