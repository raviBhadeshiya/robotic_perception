%%
clear all;close all;clc;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag1.mp4');cd ..;cd Scripts/;
warning('off','all');
%%
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];
index=1;
for i=1:500
frame{index} = read(video,i);
corner_pts{index}=findCorner(frame{index});
if(length(corner_pts{index})==4)
    [id(index),corner_pts{index}]=aprilTagDetect(frame{index},corner_pts{index},refImage);
    %     frame{index}=lenaProject(logo_pts,corner_pts{index},logo_img,frame{index});
end
%%
K=1.0e+02*[6.29302552,0.001,3.30766408;
    0,6.35529018,2.51004731;
    0,0,0.0100000];

pos = cell(1, 1);
rot = cell(1, 1);

% Process all the images
pr = [ 1 0 0;
    0 1 0 ];
tag_width = 0.10;
tag_height = 0.10;
cube_depth = -0.10;
corner_pt = [  tag_width/2,  tag_height/2;
    -tag_width/2,  tag_height/2;
    -tag_width/2, -tag_height/2;
    tag_width/2, -tag_height/2 ];
render_points = [ corner_pt, zeros(4,1);
    corner_pt, (cube_depth)*ones(4,1) ];
p = (pr*(K \ [corner_pts{index}'; ones(1,4)]))';
H = est_homography(corner_pt,p);
[proj_pts, pos{1}, rot{1}] = ar_cube(H,render_points,K);
inds = [ 1,2, 1,4, 1,5, 2,3, 2,6, 3,4, 3,7, 4,8, 5,6, 5,8, 6,7, 7,8 ];
X = proj_pts(inds,:);
% Compute other positions
figure(1);
imshow(frame{index});hold on;

for j = 1:2:length(X)
    Xj = X([j,j+1],:);
%     hline([Xj(1,:)';1],[Xj(2,:)';1]);
    line(round(Xj(:,1)), round(Xj(:,2)),'LineWidth', 3,'color','green');
%     im = insertShape(frame{index}, 'Line', [round(Xj(1,1:2)), round(Xj(2,1:2)) ], 'LineWidth', 5);
end
pause(1/10);
end