function [segI, loc] = detectBuoy3d(FrameID,param)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;
I1=imread(folder(FrameID));
% I=imgaussfilt(imadjust(I1,[0.5 0.9],[]),20);
Ir=imgaussfilt(I1,15);
Ig=imgaussfilt(I1,6);
Iy=imgaussfilt(I1,6);
% Ir=imgaussfilt(I1,1);
% Ig=imgaussfilt(I1,1);
% Iy=imgaussfilt(I1,1);
% I=rgb2lab(I);
cd Scripts/;
%%
load ColorSamples.mat
[mu_r,sigma_r]=estimatPerameters(SamplesR);
[mu_y,sigma_y]=estimatPerameters(SamplesY);
[mu_g,sigma_g]=estimatPerameters(SamplesG);
%%
maskr=zeros(size(Ir,1),size(Ir,2));probr=maskr;
maskg=zeros(size(Ig,1),size(Ig,2));probg=maskg;
masky=zeros(size(Iy,1),size(Iy,2));proby=masky;

redr=Ir(:,:,1);greenr=Ir(:,:,2);bluer=Ir(:,:,3);
redg=Ig(:,:,1);greeng=Ig(:,:,2);blueg=Ig(:,:,3);
redy=Iy(:,:,1);greeny=Iy(:,:,2);bluey=Iy(:,:,3);
for i=1:size(Ir,1)
    for j=1:size(Ir,2)
        x=[redr(i,j) greenr(i,j) bluer(i,j)]';
        y=[redg(i,j) greeng(i,j) blueg(i,j)]';
        z=[redy(i,j) greeny(i,j) bluey(i,j)]';
%         %         prob(i,j)=exp(-0.5*(double(x)-mu_g)'*inv(sigma_g)*(double(x)-mu_g))/(((2*pi)^3/2)*sqrt(det(sigma_)));
        probr(i,j)=exp(-0.5*((double(x)-mu_r)'/sigma_r)*(double(x)-mu_r))/(((2*pi)^3/2)*sqrt(det(sigma_r)));
        probg(i,j)=exp(-0.5*((double(y)-mu_g)'/sigma_g)*(double(y)-mu_g))/(((2*pi)^3/2)*sqrt(det(sigma_g)));
        proby(i,j)=exp(-0.5*((double(z)-mu_y)'/sigma_y)*(double(z)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
%         
%         probr(i,j)=mvnpdf(double(x),mu_r,sigma_r);
%         probg(i,j)=mvnpdf(double(y),mu_g,sigma_y);
%         proby(i,j)=mvnpdf(double(z),mu_y,sigma_y);
    end
end
maskR = probr > 2*std2(probr);
maskG = probg > 6*std2(probg);
maskY = proby > 8*std2(proby);

% maskR = probr > 2*std2(probr);
% maskG = probg > 2*std2(probg);
% maskY = proby > 2*std2(proby);

maskR2=zeros(size(maskR));
maskR=bwareafilt(maskR,[200,2000]);
propsR=regionprops(maskR);
% maskR=imfill(maskR,'holes');
ccR = bwconncomp(maskR);
numPixelsR = cellfun(@numel,ccR.PixelIdxList);
[biggestR,idxR] = min(numPixelsR);
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

% maskY=bwareafilt(maskY,[500,5000]);
maskY2=zeros(size(maskY));
maskY=bwareafilt(maskY,[200,2000]);
propsY=regionprops(maskY);
% maskY=imfill(maskY,'holes');
ccY = bwconncomp(maskY);
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
[bwY,~] = bwboundaries(maskY2,'holes');
% figure;
% imshow(maskY);hold on;
% plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);


% maskG=bwareafilt(maskG,[150,350]);
% maskG=imdilate(maskG,strel('disk', 10));
maskG2=zeros(size(maskG));
propsG=regionprops(maskG);
% maskG=imfill(maskG,'holes');
ccG = bwconncomp(maskG);
if FrameID<23
    numPixelsG = cellfun(@numel,ccG.PixelIdxList);
    [biggestG,idxG] = max(numPixelsG);
    maskG2(ccG.PixelIdxList{idxG}) = 1;
    [bwG,~] = bwboundaries(maskG2,'holes');
    %     figure(2); imshow(maskG);
    
    figure(1);
    imshow(I1); hold on;
    plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);
    plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
    if FrameID<23
        plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
    end
end
