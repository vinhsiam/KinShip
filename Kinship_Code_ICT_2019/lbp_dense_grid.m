function [features] = lbp_dense_grid(Images,filter_size,lbp_radius,lbp_n_point,mappingtype,hist)
z = filter_size;
lbp_size = [lbp_radius lbp_n_point];
image_size = length(Images(:,1,1,1));
image_length = length(Images(1,1,1,:));
if strcmp(mappingtype, 'u2')
    mapping=getmapping(lbp_size(2),'u2');
else
    mapping='';
end

if lbp_size(2) == 8
    if strcmp(mappingtype, 'u2')
        n_feature = 59;
    else
        n_feature = 256;
    end
elseif lbp_size(2) == 16
    n_feature = 243;
end

if hist == 'h'
    features = zeros(image_length, n_feature, 1, image_size / z, image_size / z);
else
    features = zeros(image_length, image_size - 2, image_size - 2, 3, image_size / z, image_size / z);
end
%Image_global = LBP(Images(:,:,1),1,8,mapping,'h');
for i = 1:image_length
    for j = 0:image_size/z-1
        for k = 0:image_size/z-1
            I_tmp = imcrop(Images(:, :, :, i),[1 + j * z, 1 + k * z, z - 1, z - 1]);
            I_tmp = uint8(I_tmp);
            if hist == 'h'
                features(i, :, 1, 1 + j, 1 + k) = LBP(I_tmp(:, :, 1), lbp_size(1), lbp_size(2), mapping, 'h');
                features(i, :, 2, 1 + j, 1 + k) = LBP(I_tmp(:, :, 2), lbp_size(1), lbp_size(2), mapping, 'h');
                features(i, :, 3, 1 + j, 1 + k) = LBP(I_tmp(:, :, 3), lbp_size(1), lbp_size(2), mapping, 'h');
            else
                features(:,:,:) = LBP(I_tmp(:, :, 1), lbp_size(1), lbp_size(2), mapping, '');
                features(:,:,:) = LBP(I_tmp(:, :, 2), lbp_size(1), lbp_size(2), mapping, '');
                features(:,:,:) = LBP(I_tmp(:, :, 3), lbp_size(1), lbp_size(2), mapping, '');
            end
        end
    end
end
end %function



