clear all;close all;clc;
%% cd rvctools;startup_rvc;cd ..;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag1.mp4');cd ..;cd Scripts/;

firstFrame=read(video,1);
figure
imshow(firstFrame)
hold on


%% Generate logo points (they are just the outer corners of the image)
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];

[x y]=ginput(4);
video_pts=[x y];
% Load the points that the logo corners will map onto in the main image
num_ima = size(video_pts, 3);
% Set of images to test on
test_images = 1:num_ima;
% To only test on images 1, 4 and 10, use the following line (you can edit
% it for your desired test images)
% test_images = [1,4,10];
num_test = length(test_images);
% Initialize the images
video_imgs = cell(num_test, 1);
projected_imgs = cell(num_test, 1);
% Process all the images
for i=1:num_test
    % Read the next video frame
    video_imgs{i} = firstFrame;
    
    % Find all points in the video frame inside the polygon defined by
    % video_pts
    [ interior_pts ] = calculate_interior_pts(size(video_imgs{i}),...
        video_pts(:,:,test_images(i)));
    
    % Warp the interior_pts to coordinates in the logo image
    warped_logo_pts = warp_pts(video_pts(:,:,test_images(i)),...
        logo_pts,...
        interior_pts);
    warped_logo_pts=ceil(warped_logo_pts);
    
    % Copy the RGB values from the logo_img to the video frame
    projected_imgs{i} = inverse_warping(video_imgs{i},...
        logo_img,...
        interior_pts,...
        warped_logo_pts); 
end

imshow(projected_imgs{1})