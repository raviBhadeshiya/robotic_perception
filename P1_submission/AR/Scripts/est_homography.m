function [ H ] = est_homography(video_pts, logo_pts)
% est_homography estimates the homography to transform each of the
% video_pts into the logo_pts
% Inputs:
%     video_pts: a 4x2 matrix of corner points in the video
%     logo_pts: a 4x2 matrix of logo points that correspond to video_pts
% Outputs:
%     H: a 3x3 homography matrix such that logo_pts ~ H*video_pts
% Written for the University of Pennsylvania's Robotics:Perception course

% YOUR CODE HERE
H = [];
A=[];
for i=1:4;
    logoPtc=logo_pts(i,:);
    videoPtc=video_pts(i,:);
    ax=[-videoPtc(1) -videoPtc(2) -1 0 0 0 videoPtc(1)*logoPtc(1) videoPtc(2)*logoPtc(1) logoPtc(1)];
    ay=[0 0 0 -videoPtc(1) -videoPtc(2) -1 videoPtc(1)*logoPtc(2) videoPtc(2)*logoPtc(2) logoPtc(2)];
    a=[ax;ay];
    A=[A;a];
end
[U,S,V] = svd(A);
h=V(:,end);
h=h';
H=[h(1) h(2) h(3);h(4) h(5) h(6);h(7) h(8) h(9)];
end

