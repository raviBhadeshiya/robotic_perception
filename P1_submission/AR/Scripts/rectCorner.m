clear all;close all;clc;
% cd rvctools;startup_rvc;cd ..;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag1.mp4');cd ..;cd Scripts/;

firstFrame=rgb2gray(read(video,1));
firstFrame=imgaussfilt(firstFrame,2);
[gmag,gdir]=imgradient(firstFrame);
imshowpair(gmag,gdir,'montage');

gmag=gmag>100;
% gmag1=bwareaopen(gmag,2000); 
% final=bitand(gmag,~gmag1); 
% figure,imshow(final);
% gmag=final;
gmag=edge(gmag);
[H,T,R] = hough(gmag);

P  = houghpeaks(H,8);
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% x = T(P(:,2)); y = R(P(:,1));
% plot(x,y,'s','color','white');

lines = houghlines(gmag,T,R,P);%'FillGap',5,'MinLength',7);
% lines = houghlines(gmag,T,R,P);%,'FillGap',5,'MinLength',7);
figure, imshow(firstFrame), hold on

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end