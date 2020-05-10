function J = RGB_bwrgby(I,varargin)

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) || (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end
maxi1=255;
maxi2=220.8365;
maxi3=255;
mini1=0;
mini2=-220.8365;
mini3=-255;

Ima_sce=double(I);
Ima_des(:,:,1)=(1/3)*Ima_sce(:,:,1) + (1/3)*Ima_sce(:,:,2) + (1/3)*Ima_sce(:,:,3);
Ima_des(:,:,2)=(sqrt(3)/2)*Ima_sce(:,:,1) - (sqrt(3)/2)*Ima_sce(:,:,2);
Ima_des(:,:,3)= -0.5*Ima_sce(:,:,1) - 0.5*Ima_sce(:,:,2) + Ima_sce(:,:,3);
Ima_des(:,:,1)=255*(Ima_des(:,:,1)-mini1)./(maxi1-mini1);
Ima_des(:,:,2)=255*(Ima_des(:,:,2)-mini2)./(maxi2-mini2);
Ima_des(:,:,3)=255*(Ima_des(:,:,3)-mini3)./(maxi3-mini3);
J = uint8(Ima_des);