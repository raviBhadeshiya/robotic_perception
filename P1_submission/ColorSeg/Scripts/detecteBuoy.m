 function [segI,loc] = detecteBuoy(I,mu,sig,thre)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Hard code your learned model parameters here
% mu = [146.191022661243;142.556798373039;64.6589192330041];
% sig = [261.248083265617,161.968304784929,-273.820232247444;161.968304784929,152.209876792002,-201.072288991880;-273.820232247444,-201.072288991880,424.701792905155]
% thre = 1e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find ball-color pixels using your model
I=rgb2lab(I);
mask=zeros(size(I,1),size(I,2));
hue=I(:,:,1);
saturation=I(:,:,2);
value=I(:,:,3);
for i=1:size(I,1)
    for j=1:size(I,2)
        x=[hue(i,j) saturation(i,j) value(i,j)]';
        mask(i,j)=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
%         p=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
        if mask(i,j) >= thre
            mask(i,j)=1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   bwconncomp
%   regionprops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the location of the ball center
% figure; imshow(mask);
mask_biggest = false(size(mask));
CC = bwconncomp(imbinarize(mask));
numPixels = cellfun(@numel,CC.PixelIdxList);
[mask_biggest,idx] = max(numPixels);
mask(CC.PixelIdxList{idx}) = 1;
figure; imshow(mask);
S = regionprops(CC,'Centroid');
% loc=0;
loc = S(idx).Centroid;
segI = imfill(mask,8,'holes');
end
