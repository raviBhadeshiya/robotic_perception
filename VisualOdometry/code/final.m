clc;clear all;close all;warning off;
cd ..;
imgFolder = fullfile('input\Oxford_dataset\stereo\centre\');
allImages = imageDatastore(imgFolder,'IncludeSubfolders',true);
model=fullfile('..\input\Oxford_dataset\model');
cd code;
%%
[fx, fy, cx, cy, G_camera_image, LUT]=ReadCameraModel(imgFolder,model);clc;
K=[fx 0 cx;0 fy cy;0 0 1];
cameraParams = cameraParameters('IntrinsicMatrix', K');

vSet = viewSet;
Irgb = demosaic(readimage(allImages,1),'gbrg');
player = vision.VideoPlayer('Position', [20, 400, 650, 510]);step(player, Irgb);

prevI = UndistortImage(Irgb,LUT);

prevPoints = detectSURFFeatures(rgb2gray(prevI), 'MetricThreshold', 500);
numPoints = 150;
prevPoints = selectUniform(prevPoints, numPoints, size(prevI));
prevFeatures = extractFeatures(rgb2gray(prevI), prevPoints, 'Upright', true);

viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', eye(3),...
    'Location', [0 0 0]);
%%
figure
axis([-50, 50, -140, 20, -10, 1000]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on

cameraSize = 7;
camEstimated = plotCamera('Size', cameraSize, 'Location',...
    vSet.Views.Location{1}, 'Orientation', vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);
trajectoryEstimated = plot3(0, 0, 0, 'g-');
title('Camera Trajectory');
%%
% Read and display the image.
for viewId=2:numel(allImages.Files)
    
    Irgb = demosaic(readimage(allImages,viewId),'gbrg');
    step(player, Irgb);
    
    % Convert to gray scale and undistort.
    I = rgb2gray(UndistortImage(Irgb,LUT));
    
    % Match features between the previous and the current image.
    [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
        prevFeatures, I);
    
    % Estimate the pose of the current view relative to the previous view.
    %????????????????????????????????????%
    [orient, loc, inlierIdx] = helperEstimateRelativePose(...
        prevPoints(indexPairs(:,1)), currPoints(indexPairs(:,2)), cameraParams);
    %??????????????????????????????????% Eliminate outliers from feature matches.
    
    if(viewId >4)
        inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),currPoints(indexPairs(:, 2)), cameraParams);
        indexPairs = indexPairs(inlierIdx, :);
        [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,cameraParams, indexPairs, currPoints);
        warningstate = warning('off','vision:ransac:maxTrialsReached');
        [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints,cameraParams, 'Confidence', 99.99, 'MaxReprojectionError', 0.8);
        warning(warningstate);
    end
    % Add the current view to the view set.
    vSet = addView(vSet, viewId, 'Points', currPoints, 'Orientation', orient, ...
        'Location', loc);
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);
    
    if (viewId >3)
        tracks = findTracks(vSet); % Find point tracks spanning multiple views.
        
        camPoses = poses(vSet);    % Get camera poses for all views.
        
        % Triangulate initial locations for the 3-D world points.
        xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
        
        % Refine camera poses using bundle adjustment.
        [~, camPoses] = bundleAdjustment(xyzPoints, tracks, camPoses, ...
            cameraParams, 'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
            'RelativeTolerance', 1e-9, 'MaxIterations', 300);
        
        vSet = updateView(vSet, camPoses); % Update view set.
        
    end
    
    
    helperUpdateCameraPlots(viewId, camEstimated, poses(vSet));
    helperUpdateCameraTrajectories(viewId, trajectoryEstimated, poses(vSet));
    
    prevI = I;
    prevFeatures = currFeatures;
    prevPoints   = currPoints;
end
%%