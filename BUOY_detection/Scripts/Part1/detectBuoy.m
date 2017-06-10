function returnFrame = detectBuoy(FrameID,param)
%%
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
cd ..;cd ..;
I1=imread(folder(FrameID));

Ir=imgaussfilt(I1,15);
Ig=imgaussfilt(I1,1);
Iy=imgaussfilt(I1,6);
% % Ir=imgaussfilt(I1,1);
% % Ig=imgaussfilt(I1,1);
% % Iy=imgaussfilt(I1,1);
cd Scripts/Part1/;
%%
load ColorSamples.mat
%%
maskr=zeros(size(Ir,1),size(Ir,2));probr=maskr;
maskg=zeros(size(Ig,1),size(Ig,2));probg=maskg;
masky=zeros(size(Iy,1),size(Iy,2));proby=masky;

redr=Ir(:,:,1);greenr=Ir(:,:,2);bluer=Ir(:,:,3);
redg=Ig(:,:,1);greeng=Ig(:,:,2);blueg=Ig(:,:,3);
redy=Iy(:,:,1);greeny=Iy(:,:,2);bluey=Iy(:,:,3);
for i=1:size(I1,1)
    for j=1:size(I1,2)
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
maskR = probr >2*std2(probr); %fine tuning needed
maskY = proby > 6*std2(proby); %final value
maskG = probg > 9*std2(probg); %final value

figure(1);
imshow(I1); hold on;


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
