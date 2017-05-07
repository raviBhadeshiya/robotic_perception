
function F = EstimateFundamentalMatrix(x1, x2)


% EstimateFundamentalMatrix
% Estimate the fundamental matrix from two image point correspondences 
% Inputs:
%     x1 - size (N x 2) matrix of points in image 1
%     x2 - size (N x 2) matrix of points in image 2, each row corresponding
%       to x1
% Output:
%    F - size (3 x 3) fundamental matrix with rank 2

F=[];
A=[];
for i=1:size(x1,1)
   a=[x1(i,1)*x2(i,1) x1(i,1)*x2(i,2) x1(i,1) x1(i,2)*x2(i,1) x1(i,2)*x2(i,2) x1(i,2) x2(i,1) x2(i,2) 1];
   A=[A;a];
end

[U,S,V] = svd(A);
F=V(:,end);
F=F';
F=[F(1) F(2) F(3);F(4) F(5) F(6);F(7) F(8) F(9)]; %or reshape(F,3,3);
%rank clean up to 2
[u d v]=svd(F);
d(3,3)=0;
F=u*d*v';
F=F/norm(F);
end
