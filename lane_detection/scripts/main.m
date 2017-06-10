clear all;close all;clc
cd ..;
video=VideoReader('DataSet/project_video.mp4');
cd scripts;
%
% c = [512 256 1152 768];
% r = [450 650 650 450];

c = [552 300 1200 728];
r = [450 650 650 450];

BW = poly2mask(c,r,720,1280);
num=1;
while hasFrame(video)
    frame = readFrame(video);
    if num >= 1
        gray=undistortimage(frame,sqrt((1.15422732e+03)^2 + (1.14818221e+03)^2), 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
        %             gray=rgb2gray(gray);
        imshowpair(frame,gray);
        hold on;
%         gray=imgaussfilt(gray,2);
%         
%         lab_he=rgb2hsv(gray);
%         lab_he(:,:,1)=0;
%         lab_he(:,:,2)=mean2(lab_he(:,:,2));
%         %     imshow(gray);
%         
%         %         gray= imadjust(gray);
%         e1=edge(gray,'Canny',[0.2 0.4]);
%         %     e1=imfilter(e1,[-3 -2 -1 0 1 2 3]');
%         e1=double(e1).*BW;
%         de=strel('disk',8);
%         e1=imdilate(e1,de);
%         e1=imerode(e1,strel('disk',8));
%         %     e1=bwmorph(e1, 'thin',Inf);
%         %         [H,T,R] = hough(e1);
%         %         P  = houghpeaks(H,20,'threshold',ceil(0.2*max(H(:))));
%         %         lines = houghlines(e1,T,R,P,'FillGap',200,'MinLength',100);
%         %         title(num);
%         %         imshow(e1); hold on;
%         %         for k = 1:length(lines)
%         %             xy = [lines(k).point1; lines(k).point2];
%         %             plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
%         %         end
%        
        
        pause(1/30);
    end
    num=num+1;
end
