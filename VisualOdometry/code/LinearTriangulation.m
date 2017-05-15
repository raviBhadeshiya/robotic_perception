function x3D = LinearTriangulation(x1,x2,rot,t)
% Computes a reconstruction by linear triangulation by Direct Linear
% Transformation (DTL) algorithm.
%
% Input:
%       x1 and x2 are 2xN (or 3xN in homogeneous coordinates) set of
%       points.
%
%       rot is 3x3 rotation matrix.
%
%       t is 3x1 translation matrix.
%
% Output:
%       x3D is an estimation of 3D points by projective transformation such
%       that x3D * A = 0
%
%----------------------------------------------------------
%
% From 
%    Book: "Multiple View Geometry in Computer Vision",
% Authors: Hartley and Zisserman, 2006, [HaZ2006] Section: "Linear
% triangulation methods", Chapter: 12
%    Page: 312
%
%----------------------------------------------------------
%      Author: Diego Cheda
% Affiliation: CVC - UAB
%        Date: 03/06/2008
%----------------------------------------------------------

% Convert to homogeneous coordinates.
x1 = HomogeneousCoordinates(x1,'2D');
x2 = HomogeneousCoordinates(x2,'2D');

% Normalization
% Transform the image coordinates according to x^_i = Tx_i and x'^_i =
% T'x'_i where T and T' are normalizing transformation conssiting of a
% translation and scaling.
%[x1,t1] = Normalise2DPts(x1);
%[x2,t2] = Normalise2DPts(x2);

p1 = eye(3,4);
p2 = [rot t];

% AX = 0
for i=1:size(x1,2)
    a = [ x1(1,i)*p1(3,:) - p1(1,:); ...
          x1(2,i)*p1(3,:) - p1(2,:); ... 
          x2(1,i)*p2(3,:) - p2(1,:); ...
          x2(2,i)*p2(3,:) - p2(2,:) ];
    
    % Obtain the SVD of A. The unit singular vector corresponding to the
    % smallest singular value is the solution h. A = UDV' with D diagonal
    % with positive entries, arranged in descending order down the
    % diagonal, then X is the last column of V.
    [u,d,v] = svd(a);
    x3D(:,i) = v(:,4);
end

% Desnormalization
%x3D = inv(t2) * x3D * t1;