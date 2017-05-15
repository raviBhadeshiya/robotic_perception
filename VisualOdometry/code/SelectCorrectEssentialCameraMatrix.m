function [cRot,cT,correct] = SelectCorrectEssentialCameraMatrix(rot,t,x1,x2,k)
% Extracts the cameras from the essential matrix
% Input:
%       - rot and t are the four rotation and traslation matrice retrieved 
%         form the essential matrix.
%         rot is a 3x3x4 matrix where the last dimension corresponds
%         to the different camera matrices and 3x3 are rotation matrices.
%         t is a 3x1x4 matrix where the last dimension corresponds
%         to the different camera matrices and 3x1 are traslation matrices.
%
%       - x3D are the 3D points reconstructed from essential matrix.
%         x3D is a 3xNx4 where the last dimesion corresponds
%         to the different camera matrices. 
%         
%
% Output:
%       - cRot and cT are the correct rotation and translation of the
%       second camera matrix from 4 possible solutions. We test with a
%       single point to determine if it is in front of both cameras is
%       sufficient to decide between the four different solutions for the
%       camera matrix (pag. 259). 
%
%       - correct is the index of the correct solution.
%
%----------------------------------------------------------
%      Author: Diego Cheda
% Affiliation: CVC - UAB
%        Date: 16/06/2008
%----------------------------------------------------------

% Computes 3D points
nx1 = NormalizedCoordinates(x1,k);
nx2 = NormalizedCoordinates(x2,k);
for i=1:4
    x3D(:,:,i) = LinearTriangulation(nx1, nx2, rot(:,:,i), t(:,:,i));
    x3D(:,:,i) = HomogeneousCoordinates(x3D(:,:,i),'3D');
end

correct = 0;
for i=1:4    
    % compute the depth & sum the sign
    depth(i,1) = sum(sign(DepthOfPoints(x3D(:,:,i),eye(3),zeros(3,1)))); %using canonical camera
    depth(i,2) = sum(sign(DepthOfPoints(x3D(:,:,i),rot(:,:,i),t(:,:,i)))); % using the recovered camera
end

if(depth(1,1)>0 && depth(1,2)>0)
    correct = 1;
elseif(depth(2,1)>0 && depth(2,2)>0)
    correct = 2;
elseif(depth(3,1)>0 && depth(3,2)>0)
    correct = 3;
elseif(depth(4,1)>0 && depth(4,2)>0)
    correct = 4;
end;
%correct 

% return the selected solution
cRot = rot(:,:,correct);
cT = t(:,correct);