clear all;close all;clc
cd ..;
video=VideoReader('DataSet/project_video.mp4');
cd scripts;

i=2;
c = [0 0 1280 1280]; 
r = [720/i 720 720 720/i];
BW = poly2mask(c,r,720,1280);


while hasFrame(video)
    frame = readFrame(video);
    filtered=imgaussfilt(frame,4);
    gray=rgb2gray(filtered);
    e1=edge(gray,0.022,'vertical');
%     e2=edge(gray,'Canny',mean2(gray)/double(max(max(gray))));
    e2=imfilter(e1,[-3 -2 -1 0 1 2 3]');
%     imshowpair(e1,e2,'Montage');
%     imshow(e1);
    e3=e2.*BW;
    imshowpair(e3,bwareaopen(e3,70),'Montage');
    hold on;
    pause(1/10);
end
