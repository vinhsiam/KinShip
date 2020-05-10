function J = RGB_Lab(I)

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) || (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

J = zeros(size(I));

%Illuminant D65_ITU
I=double(I);
Ima_int(:,:,1)=0.412*I(:,:,1) + 0.358*I(:,:,2) + 0.180*I(:,:,3);
Ima_int(:,:,2)=0.213*I(:,:,1) + 0.715*I(:,:,2) + 0.072*I(:,:,3);
Ima_int(:,:,3)=0.019*I(:,:,1) + 0.119*I(:,:,2) + 0.950*I(:,:,3);

mini_1=0;
mini_2=0;
mini_3=0;
maxi_1=242.25;
maxi_2=255;
maxi_3=277.44;

mini1=0;
mini2=-431.034482758621;
mini3=-431.034482758621;
maxi1=100;
maxi2=431.034482758621;
maxi3=431.034482758621;
    
Ima_int(:,:,1)=255*(Ima_int(:,:,1)-mini_1)./(maxi_1-mini_1);
Ima_int(:,:,2)=255*(Ima_int(:,:,2)-mini_2)./(maxi_2-mini_2);
Ima_int(:,:,3)=255*(Ima_int(:,:,3)-mini_3)./(maxi_3-mini_3);
if(Ima_int(:,:,2)>(0.008856*255))
    J(:,:,1)=116.*((Ima_int(:,:,2)./255).^(1/3))-16;
else
    J(:,:,1)=903.3.*(Ima_int(:,:,2)./255);
end
if(Ima_int(:,:,1)>(0.008856*255))
    res1=double(Ima_int(:,:,1)./255).^(1/3);
else
    res1=7.787*double(Ima_int(:,:,1)./255)+16/116;
end
if(Ima_int(:,:,2)>(0.008856*255))
    res2=double(Ima_int(:,:,2)./255).^(1/3);
else
    res2=7.787*double(Ima_int(:,:,2)./255)+16/116;
end
if(Ima_int(:,:,3)>(0.008856*255))
    res3=double(Ima_int(:,:,3)./255).^(1/3);
else
    res3=7.787*double(Ima_int(:,:,3)./255)+16/116;
end
J(:,:,2)=500.*(res1-res2);
J(:,:,3)=500.*(res2-res3);
J(:,:,1)=255*(J(:,:,1)-mini1)./(maxi1-mini1);
J(:,:,2)=255*(J(:,:,2)-mini2)./(maxi2-mini2);
J(:,:,3)=255*(J(:,:,3)-mini3)./(maxi3-mini3);
J = uint8(J);

end
