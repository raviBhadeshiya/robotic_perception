function [orientation, location] = ...
    helperEstimateRelativePose(matchedPoints1, matchedPoints2, cameraParams)
    
%    [fMatrix, inlierIdx] = estimateFundamentalMatrix(...
%         matchedPoints1,matchedPoints2,'Method','RANSAC',...
%         'NumTrials',2000,...
%         'DistanceThreshold',1e-4);
%     point1=matchedPoints1.selectStrongest(25);
%     point2=matchedPoints2.selectStrongest(25);
    F = EstimateFundamentalMatrix(matchedPoints1.Location,matchedPoints2.Location);
    
%     inlierPoints1 = matchedPoints1(inlierIdx, :);
%     inlierPoints2 = matchedPoints2(inlierIdx, :);    
    
    % Compute the camera pose from the fundamental matrix.
    [orientation, location, validPointFraction] = ...
        cameraPose(F, cameraParams, matchedPoints1, matchedPoints2);
end