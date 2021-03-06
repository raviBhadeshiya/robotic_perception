function returnFrame = detectBuoy(FrameID,param)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;cd ..;
I1=rgb2hsv(imread(folder(FrameID)));

Ir=imgaussfilt(I1,4);
Ig=imgaussfilt(I1,4);
Iy=imgaussfilt(I1,6);
cd Scripts/extraCredit_hsv/;
%%
load ColorSamples.mat
%%
maskr=zeros(size(Ir,1),size(Ir,2));probr=maskr;
maskg=zeros(size(Ig,1),size(Ig,2));probg=maskg;
masky=zeros(size(Iy,1),size(Iy,2));proby=masky;

hueR=Ir(:,:,1);saturationR=Ir(:,:,2);valueR=Ir(:,:,3);
hueG=Ig(:,:,1);saturationG=Ig(:,:,2);valueG=Ig(:,:,3);
hueY=Iy(:,:,1);saturationY=Iy(:,:,2);valueY=Iy(:,:,3);
for i=1:size(I1,1)
    for j=1:size(I1,2)
        x=[hueR(i,j) saturationR(i,j) valueR(i,j)]';
        y=[hueG(i,j) saturationG(i,j) valueG(i,j)]';
        z=[hueY(i,j) saturationY(i,j) valueY(i,j)]';
%         %         prob(i,j)=exp(-0.5*(double(x)-mu_g)'*inv(sigma_g)*(double(x)-mu_g))/(((2*pi)^3/2)*sqrt(det(sigma_)));
        probr(i,j)=exp(-0.5*((double(x)-mu_r)'/sigma_r)*(double(x)-mu_r))/(((2*pi)^3/2)*sqrt(det(sigma_r)));
        probg(i,j)=exp(-0.5*((double(y)-mu_g)'/sigma_g)*(double(y)-mu_g))/(((2*pi)^3/2)*sqrt(det(sigma_g)));
        proby(i,j)=exp(-0.5*((double(z)-mu_y)'/sigma_y)*(double(z)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
%         
    end
end
maskR = probr > 2*std2(probr); %final value
maskY = proby > 6*std2(proby); %final value
maskG = probg > 9*std2(probg); %final value

figure(1);
imshow(hsv2rgb(I1)); hold on;



maskR2=zeros(size(maskR));
maskR(1:90,:)=0;
maskR=bwareafilt(maskR,[200,5500]);
propsR=regionprops(maskR);
ccR = bwconncomp(maskR);
if ccR.NumObjects>0
numPixelsR = cellfun(@numel,ccR.PixelIdxList);
[biggestR,idxR] = max(numPixelsR);
maskR2(ccR.PixelIdxList{idxR}) = 1;
[bwR,~] = bwboundaries(maskR2,'holes');
plot(bwR{1}(:,2),bwR{1}(:,1),'r', 'LineWidth', 2);
end

maskY2=zeros(size(maskY));
maskY=bwareafilt(maskY,[200,2000]);
propsY=regionprops(maskY);
ccY = bwconncomp(maskY);
numPixelsY = cellfun(@numel,ccY.PixelIdxList);
[biggestY,idxY] = max(numPixelsY);
maskY2(ccY.PixelIdxList{idxY}) = 1;
maskY2=imdilate(maskY2,strel('disk',5));
[bwY,~] = bwboundaries(maskY2,'holes');
plot(bwY{1}(:,2),bwY{1}(:,1),'y', 'LineWidth', 2);

maskG=bwareafilt(maskG,[1,150]);
maskG2=zeros(size(maskG));
propsG=regionprops(maskG);
ccG = bwconncomp(maskG);

    numPixelsG = cellfun(@numel,ccG.PixelIdxList);
    [biggestG,idxG] = max(numPixelsG);
    maskG2(ccG.PixelIdxList{idxG}) = 1;
    maskG2=imdilate(maskG2,strel('disk',10));
    [bwG,~] = bwboundaries(maskG2,'holes');
        
    if FrameID<23
        plot(bwG{1}(:,2),bwG{1}(:,1),'g', 'LineWidth', 2);
    end

returnFrame=getframe;
end
