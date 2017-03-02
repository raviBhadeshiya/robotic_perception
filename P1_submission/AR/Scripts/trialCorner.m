clear all;close all;clc;
% cd rvctools;startup_rvc;cd ..;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag1.mp4');cd ..;cd Scripts/;

firstFrame=rgb2gray(read(video,150));
mainImage=firstFrame;
firstFrame=imgaussfilt(firstFrame,2);
firstFrame=imbinarize(firstFrame);
% figure
% imshow(firstFrame)

% trialFrame=im2bw(firstFrame, 0.9);
% imshow(~trialFrame)

% [gmag,gdir]=imgradient(firstFrame);
% % imshowpair(gmag,gdir,'montage');
% 
% gmag=gmag>100;
% gmag1=bwareaopen(gmag,2000); 
% final=bitand(gmag,~gmag1); 

CC=bwconncomp(~firstFrame)
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
firstFrame(CC.PixelIdxList{idx}) = 1;

CC=bwconncomp(firstFrame)
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = min(numPixels);
firstFrame(CC.PixelIdxList{idx}) = 0;

% firstFrame=imdilate(firstFrame,strel('disk',2));

figure
imshow(firstFrame)
mask = zeros(size(firstFrame));
mask(25:end-25,25:end-25) = 1;
trial=activecontour(~firstFrame,mask);
figure; imshow(trial)

% gmag=medfilt2(final,[3 3]);
% figure,imshow(final); hold on 


gmag=edge(~firstFrame,'canny');

[H,T,R] = hough(gmag);

P  = houghpeaks(H,4);
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');

lines = houghlines(gmag,T,R,P);%,'FillGap',5,'MinLength',7);
% lines = houghlines(gmag,T,R,P);%,'FillGap',5,'MinLength',7);
figure, imshow(mainImage), hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end