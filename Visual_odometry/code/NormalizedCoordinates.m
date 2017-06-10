function nx = NormalizedCoordinates(x,k);
% Convert a point to normalized coordinates.
%
% Input:
%       x is a 3xN points to convert.
%
%       k is the camera calibration matrix.
%
% Output:
%       nx is a 3xN normalized points.
%
%----------------------------------------------------------
%
% From 
%    Book: "Multiple View Geometry in Computer Vision",
% Authors: Hartley and Zisserman, 2006, [HaZ2006]
% Section: "Retrieving the camera matrices", 
% Chapter: 9
%    Page: 253
%
%----------------------------------------------------------
%      Author: Diego Cheda
% Affiliation: CVC - UAB
%        Date: 03/06/2008
%----------------------------------------------------------

nx = inv(k) * x;