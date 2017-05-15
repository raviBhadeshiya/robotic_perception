function h = HomogeneousCoordinates(p,pts2DOr3D)
% Convert points to homogeneous coordinates
%
% Input:
%       p is a matrix of 2D or 3D points.
%
%       pts2DOr3D is a flag to indicate if the points are 3D or 2D
%       coordinates
%       '2D' => 2D points.
%       '3D' => 3D points.
%       '2Dforce' => 3th coordinate is force to 1 
%
% Output:
%        h is a matrix of 2D or 3D points in homogeneous coordinates.
%
%----------------------------------------------------------
%      Author: Diego Cheda
% Affiliation: CVC - UAB
%        Date: 10/06/2008
%----------------------------------------------------------


if (strcmp(pts2DOr3D,'2D'))
    if (size(p,1) == 2)
        h = [p;  ones(size(p,2),1)'];
    else if (size(p,1) == 3)
            h(1,:) = p(1,:)./p(3,:);
            h(2,:) = p(2,:)./p(3,:);
            h(3,:) = p(3,:)./p(3,:);
        end
    end
else if (strcmp(pts2DOr3D,'3D'))
        if (size(p,1) == 3)
            h = [p;  ones(size(p,2),1)'];
        else if (size(p,1) == 4)
                h(1,:) = p(1,:)./(p(4,:)+eps);
                h(2,:) = p(2,:)./(p(4,:)+eps);
                h(3,:) = p(3,:)./(p(4,:)+eps);
                h(4,:) = p(4,:)./(p(4,:)+eps);
            end
        end
	else if (strcmp(pts2DOr3D,'2Dforce'))
            h = [p(1:2,:);  ones(size(p,2),1)'];
        end
    end
end