% helperFindEpipolarInliers Find epipolar inliers among matched image points
%  inlierIdx = helperFindEpipolarInliers(matchedPoints1, matchedPoints2, cameraParams)
%  returns indices of matched image points which satisfy the epipolar
%  constraint. 
%  
%  matchedPoints1 and matchedPoints2 are sets of matched image points 
%  specified as M-by-2 matrices of [x,y] coordinates, or as any of the point 
%  feature types. cameraParams is a cameraParameters object. inlierIdx is a
%  logical index of the epipolar inliers.
%
%  See also estimateEssentialMatrix, estimateFundamentalMatrix,
%  relativeCameraPose

% Copyright 2016 The MathWorks, Inc. 

function inlierIdx = findEpipolarInliers(matchedPoints1, ...
    matchedPoints2, cameraParams)

% Use the inlierIdx output from helperEstimateRelativePose and ignore the
% orientation and rotation.
[~, ~, inlierIdx] = estimateRelativePose(matchedPoints1, ...
    matchedPoints2, cameraParams);