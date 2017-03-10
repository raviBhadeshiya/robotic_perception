function [segI, loc] = tryDetect(FrameID,modelParm)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;cd ..;
I1=imread(folder(FrameID));
% for i=1:3
%     I(:,:,i)=imadjust(I(:,:,i),[0. 0.8]);
% end
% I = imgaussfilt(I,8);
I=imgaussfilt(imadjust(I1,[0.5 0.9],[]),6);
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

figure(1);
imshow(I1); hold on;

maskR = probR >3*std2(probR);
maskR2=zeros(size(maskR));
maskR=bwareafilt(maskR,[200,2000]);
propsR=regionprops(maskR);
maskR=imfill(maskR,'holes');
ccR = bwconncomp(maskR);
if ccR.NumObjects>0
numPixelsR = cellfun(@numel,ccR.PixelIdxList);
[biggestR,idxR] = max(numPixelsR);
maskR2(ccR.PixelIdxList{idxR}) = 1;
[bwR,~] = bwboundaries(maskR2,'holes');
plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
end

maskY = probY >  2*std2(probY);
maskY2=zeros(size(maskY));
maskY=bwareafilt(maskY,[100,4500]);
propsY=regionprops(maskY);
maskY=imfill(maskY,'holes');
ccY = bwconncomp(maskY);
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
[bwY,~] = bwboundaries(maskY2,'holes');
plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);

maskG = probG > 2*std2(probG);
maskG=bwareafilt(maskG,[150,300]);
maskG2=zeros(size(maskG));
propsG=regionprops(maskG);
maskG=imfill(maskG,'holes');
ccG = bwconncomp(maskG);
if FrameID<23
    numPixelsG = cellfun(@numel,ccG.PixelIdxList);
    [biggestG,idxG] = max(numPixelsG);
    maskG2(ccG.PixelIdxList{idxG}) = 1;
    [bwG,~] = bwboundaries(maskG2,'holes');
    plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
end

end
