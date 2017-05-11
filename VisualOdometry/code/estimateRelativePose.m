% helperEstimateRelativePose Robustly estimate relative camera pose
%  [orientation, location, inlierIdx] = helperEstimateRelativePose(
%    matchedPoints1, matchedPoints2, cameraParams) returns the pose of
%  camera 2 in camera 1's coordinate system. The function calls
%  estimateEssentialMatrix and cameraPose functions in a loop, until
%  a reliable camera pose is obtained.
%
%  Inputs:
%  -------
%  matchedPoints1 - points from image 1 specified as an M-by-2 matrix of
%                   [x,y] coordinates, or as any of the point feature types
%  matchedPoints2 - points from image 2 specified as an M-by-2 matrix of
%                   [x,y] coordinates, or as any of the point feature types
%  cameraParams   - cameraParameters object
%
%  Outputs:
%  --------
%  orientation - the orientation of camera 2 relative to camera 1
%                specified as a 3-by-3 rotation matrix
%  location    - the location of camera 2 in camera 1's coordinate system
%                specified as a 3-element vector
%  inlierIdx   - the indices of the inlier points from estimating the
%                fundamental matrix
%
%  See also estimateEssentialmatrix, estimateFundamentalMatrix, 
%  relativeCameraPose

% Copyright 2016 The MathWorks, Inc. 

function [orientation, location, inlierIdx] = ...
    estimateRelativePose(matchedPoints1, matchedPoints2, cameraParams)

if ~isnumeric(matchedPoints1)
    matchedPoints1 = matchedPoints1.Location;
end

if ~isnumeric(matchedPoints2)
    matchedPoints2 = matchedPoints2.Location;
end

for i = 1:100
    % Estimate the essential matrix.    
    [E, inlierIdx] = estimateEssentialMatrix(matchedPoints1, matchedPoints2,...
        cameraParams);

    % Make sure we get enough inliers
    if sum(inlierIdx) / numel(inlierIdx) < .3
        continue;
    end
    
    % Get the epipolar inliers.
    inlierPoints1 = matchedPoints1(inlierIdx, :);
    inlierPoints2 = matchedPoints2(inlierIdx, :);    
    
    % Compute the camera pose from the fundamental matrix. Use half of the
    % points to reduce computation.
    [orientation, location, validPointFraction] = ...
        relativeCameraPose(E, cameraParams, inlierPoints1(1:2:end, :),...
        inlierPoints2(1:2:end, :));

    % validPointFraction is the fraction of inlier points that project in
    % front of both cameras. If the this fraction is too small, then the
    % fundamental matrix is likely to be incorrect.
    if validPointFraction > 0.5
       return;
    end
end

% After 100 attempts validPointFraction is still too low.
error('Unable to compute the Essential matrix');
