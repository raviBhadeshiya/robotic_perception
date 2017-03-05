 function [segI, loc] = detecteBuoy(I,mu,sig,thre)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Hard code your learned model parameters here
% mu = [146.191022661243;142.556798373039;64.6589192330041];
% sig = [261.248083265617,161.968304784929,-273.820232247444;161.968304784929,152.209876792002,-201.072288991880;-273.820232247444,-201.072288991880,424.701792905155]
% thre = 1e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find ball-color pixels using your model
mask=zeros(size(I,1),size(I,2));
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
for i=1:size(I,1)
    for j=1:size(I,2)
        x=[red(i,j) green(i,j) blue(i,j)]';
%         x=[red(i,j) 0 0]';
% % %         x=[red(i,j)+green(i,j)]';
%   mask(i,j)=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
        p=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
        if p >= thre
            mask(i,j)=1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   bwconncomp
%   regionprops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the location of the ball center
mask_biggest = false(size(mask));
% mask_biggest=imclose(mask_biggest,strel('disk',15));
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = min(numPixels);
mask_biggest(CC.PixelIdxList{idx}) = true;
S = regionprops(CC,'Centroid');
loc = S(idx).Centroid;
segI = imfill(mask_biggest,(round(loc)));
end
