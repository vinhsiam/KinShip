function J = RGB_XYZ(I)

if nargin < 1, error('Not enough input arguments.'); end

if((ndims(I) ~= 3) || (~isa(I,'uint8')))
    error('No 8 bits unsigned integer color image!\n Please use a 8 bits unsigned integer color image...');
end

%Illuminant D65_ITU
Ima_sce=double(I);
Ima_des(:,:,1)=0.412*Ima_sce(:,:,1) + 0.358*Ima_sce(:,:,2) + 0.180*Ima_sce(:,:,3);
Ima_des(:,:,2)=0.213*Ima_sce(:,:,1) + 0.715*Ima_sce(:,:,2) + 0.072*Ima_sce(:,:,3);
Ima_des(:,:,3)=0.019*Ima_sce(:,:,1) + 0.119*Ima_sce(:,:,2) + 0.950*Ima_sce(:,:,3);
Ima_des(:,:,1)=255*(Ima_des(:,:,1)-0)./(242.25-0);
Ima_des(:,:,2)=255*(Ima_des(:,:,2)-0)./(255-0);
Ima_des(:,:,3)=255*(Ima_des(:,:,3)-0)./(277.44-0);
J = uint8(Ima_des);

end
