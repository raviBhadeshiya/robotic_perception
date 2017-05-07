
images = imageDatastore(fullfile(toolboxdir('vision'), 'visiondata', ...
    'NewTsukuba'));

K = [615 0 320; 0 615 240; 0 0 1]';
cameraParams = cameraParameters('IntrinsicMatrix', K);

% Load ground truth camera poses.
load(fullfile(toolboxdir('vision'), 'visiondata', ...
    'visualOdometryGroundTruth.mat'));

% Create an empty viewSet object to manage the data associated with each view.
vSet = viewSet;

% Read and display the first image.
Irgb = readimage(images, 1);
player = vision.VideoPlayer('Position', [20, 400, 650, 510]);
step(player, Irgb);


prevI = undistortImage(rgb2gray(Irgb), cameraParams); 

prevPoints = detectSURFFeatures(prevI, 'MetricThreshold', 500);

numPoints = 150;
prevPoints = selectUniform(prevPoints, numPoints, size(prevI));

prevFeatures = extractFeatures(prevI, prevPoints, 'Upright', true);

viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', eye(3),...
    'Location', [0 0 0]);

%% Plot Initial Camera Pose

% Setup axes.
figure
axis([-220, 50, -140, 20, -50, 300]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on

% Plot estimated camera pose. 
cameraSize = 7;
camEstimated = plotCamera('Size', cameraSize, 'Location',...
    vSet.Views.Location{1}, 'Orientation', vSet.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);

% Plot actual camera pose.
camActual = plotCamera('Size', cameraSize, 'Location', ...
    groundTruthPoses.Location{1}, 'Orientation', ...
    groundTruthPoses.Orientation{1}, 'Color', 'b', 'Opacity', 0);

% Initialize camera trajectories.
trajectoryEstimated = plot3(0, 0, 0, 'g-');
trajectoryActual    = plot3(0, 0, 0, 'b-');

legend('Estimated Trajectory', 'Actual Trajectory');
title('Camera Trajectory');

%% Estimate the Pose of the Second View

% Read and display the image.
viewId = 2;
Irgb = readimage(images, viewId);
step(player, Irgb);

% Convert to gray scale and undistort.
I = undistortImage(rgb2gray(Irgb), cameraParams);

% Match features between the previous and the current image.
[currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
    prevFeatures, I);

% Estimate the pose of the current view relative to the previous view.
[orient, loc, inlierIdx] = helperEstimateRelativePose(...
    prevPoints(indexPairs(:,1)), currPoints(indexPairs(:,2)), cameraParams);

% Exclude epipolar outliers.
indexPairs = indexPairs(inlierIdx, :);
    
% Add the current view to the view set.
vSet = addView(vSet, viewId, 'Points', currPoints, 'Orientation', orient, ...
    'Location', loc);
% Store the point matches between the previous and the current views.
vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);

%%
% The location of the second view relative to the first view can only be
% recovered up to an unknown scale factor. Compute the scale factor from 
% the ground truth using <matlab:edit('helperNormalizeViewSet.m') helperNormalizeViewSet>,
% simulating an external sensor, which would be used in a typical monocular
% visual odometry system.

vSet = helperNormalizeViewSet(vSet, groundTruthPoses);

%%
% Update camera trajectory plots using 
% <matlab:edit('helperUpdateCameraPlots.m') helperUpdateCameraPlots> and
% <matlab:edit('helperUpdateCameraTrajectories.m') helperUpdateCameraTrajectories>.

helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
    groundTruthPoses);
helperUpdateCameraTrajectories(viewId, trajectoryEstimated, trajectoryActual,...
    poses(vSet), groundTruthPoses);

prevI = I;
prevFeatures = currFeatures;
prevPoints   = currPoints;

%% Bootstrap Estimating Camera Trajectory Using Global Bundle Adjustment
% Find 3D-to-2D correspondences between world points triangulated from the 
% previous two views and image points from the current view. Use 
% <matlab:edit('helperFindEpipolarInliers.m') helperFindEpipolarInliers> 
% to find the matches that satisfy the epipolar constraint, and then use
% <matlab:edit('helperFind3Dto2DCorrespondences.m') helperFind3Dto2DCorrespondences>
% to triangulate 3-D points from the previous two views and find the
% corresponding 2-D points in the current view.

for viewId = 3:15
    % Read and display the next image
    Irgb = readimage(images, viewId);
    step(player, Irgb);
    
    % Convert to gray scale and undistort.
    I = undistortImage(rgb2gray(Irgb), cameraParams);
    
    % Match points between the previous and the current image.
    [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
        prevFeatures, I);
      
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(prevPoints(indexPairs(:,1)),...
        currPoints(indexPairs(:, 2)), cameraParams);
    indexPairs = indexPairs(inlierIdx, :);
    
    % Triangulate points from the previous two views, and find the 
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet,...
        cameraParams, indexPairs, currPoints);
    
    % Since RANSAC involves a stochastic process, it may sometimes not
    % reach the desired confidence level and exceed maximum number of
    % trials. Disable the warning when that happens since the outcomes are
    % still valid.
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'Confidence', 99.99, 'MaxReprojectionError', 0.8);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add the current view to the view set.
    vSet = addView(vSet, viewId, 'Points', currPoints, 'Orientation', orient, ...
        'Location', loc);
    
    % Store the point matches between the previous and the current views.
    vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);    
    
    tracks = findTracks(vSet); % Find point tracks spanning multiple views.
        
    camPoses = poses(vSet);    % Get camera poses for all views.
    
    % Triangulate initial locations for the 3-D world points.
    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);
    
    % Refine camera poses using bundle adjustment.
    [~, camPoses] = bundleAdjustment(xyzPoints, tracks, camPoses, ...
        cameraParams, 'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
        'RelativeTolerance', 1e-9, 'MaxIterations', 300);
        
    vSet = updateView(vSet, camPoses); % Update view set.
    
    % Bundle adjustment can move the entire set of cameras. Normalize the
    % view set to place the first camera at the origin looking along the
    % Z-axes and adjust the scale to match that of the ground truth.
    vSet = helperNormalizeViewSet(vSet, groundTruthPoses);
    
    % Update camera trajectory plot.
    helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
        groundTruthPoses);
    helperUpdateCameraTrajectories(viewId, trajectoryEstimated, ...
        trajectoryActual, poses(vSet), groundTruthPoses);
    
    prevI = I;
    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end

%% Estimate Remaining Camera Trajectory Using Windowed Bundle Adjustment
% Estimate the remaining camera trajectory by using windowed bundle 
% adjustment to only refine the last 15 views, in order to limit the amount 
% of computation. Furthermore, bundle adjustment does not have to be called
% for every view, because |estimateWorldCameraPose| computes the pose in the
% same units as the 3-D points. This section calls bundle adjustment for
% every 7th view. The window size and the frequency of calling bundle
% adjustment have been chosen experimentally.

for viewId = 16:numel(images.Files)
    % Read and display the next image
    Irgb = readimage(images, viewId);
    step(player, Irgb);
    
    % Convert to gray scale and undistort.
    I = undistortImage(rgb2gray(Irgb), cameraParams);

    % Match points between the previous and the current image.
    [currPoints, currFeatures, indexPairs] = helperDetectAndMatchFeatures(...
        prevFeatures, I);    
          
    % Triangulate points from the previous two views, and find the 
    % corresponding points in the current view.
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(vSet, ...
        cameraParams, indexPairs, currPoints);

    % Since RANSAC involves a stochastic process, it may sometimes not
    % reach the desired confidence level and exceed maximum number of
    % trials. Disable the warning when that happens since the outcomes are
    % still valid.
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'MaxNumTrials', 5000, 'Confidence', 99.99, ...
        'MaxReprojectionError', 0.8);
    
    % Restore the original warning state
    warning(warningstate)
    
    % Add the current view and connection to the view set.
    vSet = addView(vSet, viewId, 'Points', currPoints, 'Orientation', orient, ...
        'Location', loc);
    vSet = addConnection(vSet, viewId-1, viewId, 'Matches', indexPairs);
        
    % Refine estimated camera poses using windowed bundle adjustment. Run 
    % the optimization every 7th view.
    if mod(viewId, 7) == 0        
        % Find point tracks in the last 15 views and triangulate.
        windowSize = 15;
        startFrame = max(1, viewId - windowSize);
        tracks = findTracks(vSet, startFrame:viewId);
        camPoses = poses(vSet, startFrame:viewId);
        [xyzPoints, reprojErrors] = triangulateMultiview(tracks, camPoses, ...
            cameraParams);
                                
        % Hold the first two poses fixed, to keep the same scale. 
        fixedIds = [startFrame, startFrame+1];
        
        % Exclude points and tracks with high reprojection errors.
        idx = reprojErrors < 2;
        
        [~, camPoses] = bundleAdjustment(xyzPoints(idx, :), tracks(idx), ...
            camPoses, cameraParams, 'FixedViewIDs', fixedIds, ...
            'PointsUndistorted', true, 'AbsoluteTolerance', 1e-9,...
            'RelativeTolerance', 1e-9, 'MaxIterations', 300);
        
        vSet = updateView(vSet, camPoses); % Update view set.
    end
    
    % Update camera trajectory plot.
    helperUpdateCameraPlots(viewId, camEstimated, camActual, poses(vSet), ...
        groundTruthPoses);    
    helperUpdateCameraTrajectories(viewId, trajectoryEstimated, ...
        trajectoryActual, poses(vSet), groundTruthPoses);    
    
    prevI = I;
    prevFeatures = currFeatures;
    prevPoints   = currPoints;  
end

hold off

displayEndOfDemoMessage(mfilename)
