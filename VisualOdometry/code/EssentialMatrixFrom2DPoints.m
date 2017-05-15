function e = EssentialMatrixFrom2DPoints(p1,p2,k)
%
% Input:
%       p1 and p2 are 2xN (or 3xN in homogeneous coordiantes) of
%       correspondings corners. 
%
%       k is the camera matrix.
% 
% Output:
%       e is the essential matrix.    
%   
%----------------------------------------------------------
%
% From 
%    Book: "Multiple View Geometry in Computer Vision",
% Authors: Hartley and Zisserman, 2006, [HaZ2006]
% Section: "Computation of the Fundamental Matrix F",  specifically "The
% normalised 8-point algorithm"
% Chapter: 11
%    Page: 279
%
%----------------------------------------------------------
%      Author: Diego Cheda
% Affiliation: CVC - UAB
%        Date: 03/06/2008
%----------------------------------------------------------

% Points in Normalized Coordinates. p = inv(k) * p
p1 = NormalizedCoordinates(p1,k);
p2 = NormalizedCoordinates(p2,k);

% Normalization
% Transform the image coordinates according to x^_i = Tx_i and x'^_i =
% T'x'_i where T and T' are normalizing transformation consisting of a
% translation and scaling.
% [p1,t1] = Normalise2DPts(p1);
% [p2,t2] = Normalise2DPts(p2);
[p1,t1] = normalise2dpts(p1);
[p2,t2] = normalise2dpts(p2);


% (x,y)
x1 = p1(1,:)';
x2 = p2(1,:)';

y1 = p1(2,:)';
y2 = p2(2,:)';


% Number of points
numPts = size(p1,2);

% Af = 0
% Computes A, the constraint matrix of numpts x 9
a = [x2.*x1 x2.*y1 x2 y2.*x1 y2.*y1 y2 x1 y1 ones(numPts,1)];
%a = [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(numPts,1)];

if (rank(a)<8)
    disp('rank defficient');
end


% Singular Value Decomposition of A.
% [U,S,V] = SVD(A) produces a diagonal matrix S, of the same dimension as A
% and with nonnegative diagonal elements in decreasing order, and unitary
% matrices U and V so that A = U*S*V'.
[u, d, v] = svd(a);

% Linear solution. Obtain F from 9th column of V (the smallest singular
% value of A).
e = reshape(v(:,9),3,3)';

% Constraint enforcement. 
[u, d, v] = svd(e);
d = diag([1 1 0]);
e = u * d * v';

% Desnormalization
e = t2' * e * t1;
