%%
% close all;warning off;load('data.mat');
clc;clear all;close all;warning off;
cd ..;
imgFolder = fullfile('input\Oxford_dataset\stereo\centre\');
allImages = imageDatastore(imgFolder,'IncludeSubfolders',true);
model=fullfile('..\input\Oxford_dataset\model');
cd code;
[fx, fy, cx, cy, G_camera_image, LUT]=ReadCameraModel(imgFolder,model);clc;
K=[fx 0 cx;0 fy cy;0 0 1];
cameraParams = cameraParameters('IntrinsicMatrix', K');
%%
image = demosaic(readimage(allImages,1),'gbrg');
pImage = UndistortImage(image,LUT);
[pPoints , pFeature] = customFeature(pImage);

estimatedView = viewSet;
estimatedView = addView(estimatedView, 1, 'Points', pPoints, 'Orientation', eye(3),'Location', [0 0 0]);
%%
start=3;
for i = start:length(allImages.Files)
    image = demosaic(readimage(allImages,i),'gbrg');
    undistortedImg = UndistortImage(image,LUT);
    
    [points,feature,indexPairs] = customMatchFeature(undistortedImg,pFeature);
    
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(pPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:, 2)), cameraParams);
    indexPairs = indexPairs(inlierIdx, :);
    
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(estimatedView,...
        cameraParams, indexPairs, currPoints);
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'Confidence', 99.99, 'MaxReprojectionError', 0.8);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add the current view to the view set.
    estimatedView = addView(estimatedView, viewId, 'Points', currPoints, 'Orientation', orient, ...
        'Location', loc);
    
    % Store the point matches between the previous and the current views.
    estimatedView = addConnection(estimatedView, viewId-1, viewId, 'Matches', indexPairs);    
    
    tracks = findTracks(estimatedView); % Find point tracks spanning multiple views.
        
    camPoses = poses(estimatedView);    % Get camera poses for all views.
    
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    % Refine camera poses using bundle adjustment.
    [~, camPoses] = bundleAdjustment(xyzPoints, tracks, camPoses, ...
        cameraParams, 'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
        'RelativeTolerance', 1e-9, 'MaxIterations', 300);
        
    estimatedView = updateView(estimatedView, camPoses); % Update view set.
    
    
    pImage = undistortedImg;
    pPoints = points;
    pFeature = feature;
    pause(1/10);
end

    
    
%     
%     
%     
%     
%     
% %     figure(1); showMatchedFeatures(pImage,undistortedImg,pPoints(idxPair(:,1)),points(idxPair(:,2)));
%     matchedPoints1 = pPoints(idxPair(:,1));
%     matchedPoints2 = points(idxPair(:,2));
% 
%     [F,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
%     E = FtoEmatrix(F,K);
%     %remove RANSAC exliers 
%     idxPair = idxPair(inlierIdx,:);
%     
%     inlierPoints1 = matchedPoints1(inlierIdx, :);
%     inlierPoints2 = matchedPoints2(inlierIdx, :); 
% %     [orientation, location, validPointFraction] = relativeCameraPose(E,...
% %         cameraParams, inlierPoints1(1:2:end, :),inlierPoints2(1:2:end, :));   
%     [relativeOrientation,relativeLocation] = ...
%         relativeCameraPose(F,cameraParams,inlierPoints1,inlierPoints2);
%     
%     disp(relativeLocation);
%     
%     estimatedView = addView(estimatedView, i, 'Points', points,...
%         'Orientation', relativeOrientation,'Location', relativeLocation);
%     
%     estimatedView = addConnection(estimatedView, i-1, i, 'Matches', idxPair);
%     
%     pImage = undistortedImg;
%     pPoints = points;
%     pFeature = feature;
%     
%     pause(1/10);
% end