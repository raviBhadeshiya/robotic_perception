clear all;close all;clc;
% cd rvctools;startup_rvc;cd ..;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag1.mp4');cd ..;cd Scripts/;
while hasFrame(video)
    firstFrame = rgb2gray(readFrame(video));
%     firstFrame=rgb2gray(read(video,2));
    firstFrame=imgaussfilt(firstFrame,2);
    c= corner(firstFrame,20);
    figure(1);
    imshow(firstFrame);hold on;
    plot(c(:,1), c(:,2), 'r*');
    pause;
end