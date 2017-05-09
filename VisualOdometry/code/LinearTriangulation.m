function X = LinearTriangulation(K, C1, R1, C2, R2, x1, x2)
%% LinearTriangulation
% Find 3D positions of the point correspondences using the relative
% position of one camera from another
% Inputs:
%     K  - size (3 x 3) camera intrsinc parameter for both cameras
%     C1 - size (3 x 1) translation of the first camera pose
%     R1 - size (3 x 3) rotation of the first camera pose
%     C2 - size (3 x 1) translation of the second camera
%     R2 - size (3 x 3) rotation of the second camera pose
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Outputs: 
%     X - size (N x 3) matrix whos rows represent the 3D triangulated
%       points
p1=K*[R1 C1];
% p2=K*[R2 C2];
p2=K*[R2 -R2*C2];
X=[];
for i=1:size(x1,1)
    A=[Vec2Skew([x1(i,:) 1])*p1;Vec2Skew([x2(i,:) 1])*p2];
    [u d v]=svd(A);
    x=v(:,end)/v(end,end);
    X=[X;x(1:3,:)'];
end
end



