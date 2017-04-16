function output = easyblend(image1,image2 )



image1 = double(image1);
image2 = double(image2);

height = size(image1, 1);
width = size(image1, 2);
channel = size(image1, 3);

% image weight
weight_image1 = 1 : -1/(width-1) : 0;
weightimage1M = repmat(weight_image1, height, 1);
weight_image2 = 1 - weight_image1;
weightimage2M = repmat(weight_image2, height, 1);

blendingImg = zeros(size(image1));
% blend pixel value
for i = 1 : channel
    blendingImg(:, :, i) = image1(:, :, i) .* weightimage1M + image2(:, :, i) .* weightimage2M;
end

blendingImg = uint8(blendingImg);
output = blendingImg;


end

