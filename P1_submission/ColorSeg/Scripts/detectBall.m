% Robotics: Estimation and Learning 
% WEEK 1
% 
% Complete this function following the instruction. 
function [segI, loc] = detectBall(I)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hard code your learned model parameters here

mu = [146.191022661243;142.556798373039;64.6589192330041];
sig = [261.248083265617,161.968304784929,-273.820232247444;161.968304784929,152.209876792002,-201.072288991880;-273.820232247444,-201.072288991880,424.701792905155]
thre = 1e-6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find ball-color pixels using your model
% 
mask=zeros(size(I,1),size(I,2));
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
for i=1:size(I,1)
    for j=1:size(I,2)
        x=[red(i,j) green(i,j) blue(i,j)]';
%   mask(i,j)=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
        p=exp(-0.5*(double(x)-mu)'*inv(sig)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sig)));
        if p >= thre
            mask(i,j)=1;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do more processing to segment out the right cluster of pixels.
% You may use the following functions.
%   bwconncomp
%   regionprops
% Please see example_bw.m if you need an example code.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the location of the ball center
mask_biggest = false(size(mask));
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
mask_biggest(CC.PixelIdxList{idx}) = true;
S = regionprops(CC,'Centroid');
loc = S(idx).Centroid;
segI = imfill(mask_biggest);
% 
% Note: In this assigment, the center of the segmented ball area will be considered for grading. 
% (You don't need to consider the whole ball shape if the ball is occluded.)

end
