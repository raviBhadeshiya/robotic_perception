function [segI, loc] = detecteBuoy(FrameID,modelParm)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;cd ..;

I=imread(folder(FrameID));
for i=1:3
    I(:,:,i)=imadjust(I(:,:,i));
end
I = imgaussfilt(I,8);
cd Scripts/Part0;
%%
thre = 1e-6;
load ColorSamples.mat
[mu_r,sigma_r]=estimate(SamplesR(:,1));
[mu_y,sigma_y]=estimate((SamplesY(:,1)+SamplesY(:,2))/2-SampleY(:,3));
[mu_g,sigma_g]=estimate(SamplesG(:,2));
mask=zeros(size(I,1),size(I,2));prob=mask;
%%
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
for i=1:size(I,1)
    for j=1:size(I,2)
        %         x=[red(i,j) green(i,j) blue(i,j)]';
        %         x=(red(i,j)+green(i,j))/2;
        x=(red(i,j));
        prob(i,j)=exp(-0.5*(double(x)-mu_r)*(double(x)-mu_r)/sigma_r)/(((2*pi)^3/2)*sqrt(sigma_r));
    end
end
mask = prob >= 2*std(prob(:)');

figure(1);
imshow(mask);
% figure(2);
% imshow(prob/mean2(prob));colormap winter;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   bwconncomp
%   regionprops
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the location of the ball center
% mask_biggest = false(size(mask));
% % mask_biggest=imclose(mask_biggest,strel('disk',350));
% CC = bwconncomp(mask);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% mask_biggest(CC.PixelIdxList{idx}) = true;
%
% % CC = bwconncomp(mask);
% % numPixels = cellfun(@numel,CC.PixelIdxList);
% % [biggest,idx] = max(numPixels);
% % mask_biggest(CC.PixelIdxList{idx}) = true;
%
% S = regionprops(CC,'Centroid');
% loc = S(idx).Centroid;
% segI = imfill(mask_biggest,(round(loc)));
end
