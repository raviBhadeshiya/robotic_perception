function [segI, loc] = tryDetect(FrameID,modelParm)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;cd ..;
I1=imread(folder(FrameID));
% for i=1:3
%     I(:,:,i)=imadjust(I(:,:,i),[0. 0.8]);
% end
% I = imgaussfilt(I,8);
I=imgaussfilt(imadjust(I1,[0.5 0.9],[]),5);
cd Scripts/Part0;
%%
thre = 1e-6;
load ColorSamples.mat
[mu_r,sigma_r]=estimate(SamplesR(:,1));
[mu_y,sigma_y]=estimate((SamplesY(:,1)+SamplesY(:,2))/2);
[mu_g,sigma_g]=estimate(SamplesG(:,2));

maskR=zeros(size(I,1),size(I,2));
maskY=zeros(size(I,1),size(I,2));
maskG=zeros(size(I,1),size(I,2));

probR=maskR;
probY=maskY;
probG=maskG;
%%
red=I(:,:,1);
green=I(:,:,2);
blue=I(:,:,3);
for i=1:size(I,1)
    for j=1:size(I,2)
        r=(red(i,j));
        g=(green(i,j));
        y=(red(i,j)+green(i,j))/2;
        probR(i,j)=exp(-0.5*(double(r)-mu_r)*(double(r)-mu_r)/sigma_r)/(((2*pi)^1/2)*sqrt(sigma_r));
        probG(i,j)=exp(-0.5*(double(g)-mu_g)*(double(g)-mu_g)/sigma_g)/(((2*pi)^1/2)*sqrt(sigma_g));
        probY(i,j)=exp(-0.5*(double(y)-mu_y)*(double(y)-mu_y)/sigma_y)/(((2*pi)^1/2)*sqrt(sigma_y));
    end
end
maskR = probR >2*std(probR(:)');
maskR2=zeros(size(maskR));
maskR=bwareafilt(maskR,[200,2000]);
propsR=regionprops(maskR);
maskR=imfill(maskR,'holes');
ccR = bwconncomp(maskR);
numPixelsR = cellfun(@numel,ccR.PixelIdxList);
[biggestR,idxR] = max(numPixelsR);
maskR2(ccR.PixelIdxList{idxR}) = 1;
[bwR,~] = bwboundaries(maskR2,'holes');
% imshow(maskR);hold on;
% plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
% [~,sortedR]=sort(propsR.Area);
% centroidR=propsR.Centroid;
% for i=1:size(propsR,1)
%     centroidR=propsR(1).Centroid;
%     maskR=imfill(maskR,[round(centroidR(1,1)) round(centroidR(1,2))]);
% end

maskY = probY >  2*std(probY(:)');
% maskY=bwareafilt(maskY,[500,5000]);
maskY2=zeros(size(maskY));
maskY=bwareafilt(maskY,[200,2000]);
propsY=regionprops(maskY);
maskY=imfill(maskY,'holes');
ccY = bwconncomp(maskY);
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
[bwY,~] = bwboundaries(maskY2,'holes');
% figure;
% imshow(maskY);hold on;
% plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);


maskG = probG > 2*std(probG(:)');
maskG=bwareafilt(maskG,[150,350]);
% maskG=imdilate(maskG,strel('disk', 10));
maskG2=zeros(size(maskG));
propsG=regionprops(maskG);
maskG=imfill(maskG,'holes');
ccG = bwconncomp(maskG);
if FrameID<23
    numPixelsG = cellfun(@numel,ccG.PixelIdxList);
    [biggestG,idxG] = max(numPixelsG);
    maskG2(ccG.PixelIdxList{idxG}) = 1;
    [bwG,~] = bwboundaries(maskG,'holes');
else
    disp('green objects not found')
end
% plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);


figure(1);
imshow(I1); hold on;
plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);
plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
if FrameID<23
    plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
end
% subplot(1,3,1)
% imshow(maskY);hold on;plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);
% subplot(1,3,2)
% imshow(maskR);plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
% subplot(1,3,3)
% imshow(maskG);plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
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
