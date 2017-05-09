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
% player = vision.VideoPlayer('Position', [20, 400, 650, 510]);
%%
image = demosaic(readimage(allImages,1),'gbrg');
pImage = UndistortImage(image,LUT);
% step(player, pImage);
[pPoints , pFeature] = customFeature(pImage);
estimatedView = viewSet;
estimatedView = addView(estimatedView, 1, 'Points', pPoints, 'Orientation', eye(3),'Location', [0 0 0]);

image = demosaic(readimage(allImages,2),'gbrg');
undistortedImg = UndistortImage(image,LUT);
[points,feature,indexPairs] = customMatchFeature(undistortedImg,pFeature);
% step(player, undistortedImg);
matchedPoints1 = pPoints(indexPairs(:,1));
matchedPoints2 = points(indexPairs(:,2));

[F,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
indexPairs = indexPairs(inlierIdx,:);

E = FtoEmatrix(F,K);
[Cset,Rset] = ExtractCameraPose(E);
Xset=cell(4,1);

for index=1:4
   Xset{index}=LinearTriangulation(K, zeros(3,1), eye(3),...
       Cset{index}, Rset{index},...
       pPoints(indexPairs(:,1)).Location, points(indexPairs(:,2)).Location);
end
[C,R,~] = DisambiguateCameraPose(Cset, Rset, Xset);

estimatedView = addView(estimatedView, 2, 'Points', points,...
         'Orientation', R,'Location', C');
estimatedView = addConnection(estimatedView, 1, 2, 'Matches', indexPairs);

pImage = undistortedImg;
pPoints = points;
pFeature = feature;
%%
figure
axis([-220, 320, -140, 30, -50, 1000]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on;
% Plot estimated camera pose. 
camEstimated = plotCamera('Size', 7, 'Location',...
    estimatedView.Views.Location{1}, 'Orientation', estimatedView.Views.Orientation{1},...
    'Color', 'g', 'Opacity', 0);
trajectoryEstimated = plot3(0, 0, 0, 'g-');
title('Camera Trajectory');
updateCamera(2,trajectoryEstimated,camEstimated,poses(estimatedView));
%%
start=3;
for i = start:length(allImages.Files)
    image = demosaic(readimage(allImages,i),'gbrg');
    undistortedImg = UndistortImage(image,LUT);
%     step(player, undistortedImg);
    [points,feature,indexPairs] = customMatchFeature(undistortedImg,pFeature);
    % Eliminate outliers from feature matches.
    inlierIdx = helperFindEpipolarInliers(pPoints(indexPairs(:,1)),...
        points(indexPairs(:, 2)), cameraParams);
    
%     [~,inlierIdx] = estimateFundamentalMatrix(pPoints(indexPairs(:,1)),points(indexPairs(:, 2)),...
%         'Method','RANSAC','NumTrials',2000);
    
    indexPairs = indexPairs(inlierIdx, :);
    
    [worldPoints, imagePoints] = helperFind3Dto2DCorrespondences(estimatedView,...
        cameraParams, indexPairs, points);
    
    warningstate = warning('off','vision:ransac:maxTrialsReached');
    % Estimate the world camera pose for the current view.
    [orient, loc] = estimateWorldCameraPose(imagePoints, worldPoints, ...
        cameraParams, 'MaxNumTrials', 5000, 'Confidence', 99.99, ...
        'MaxReprojectionError', 0.8);
    
    % Restore the original warning state
    warning(warningstate)
    % Add the current view to the view set.
    estimatedView = addView(estimatedView, i, 'Points', points, 'Orientation', orient, ...
        'Location', loc);
    % Store the point matches between the previous and the current views.
    estimatedView = addConnection(estimatedView, i-1, i, 'Matches', indexPairs);    
 if (mod(i,7) == 0)
        windowSize = 15;
        startFrame = max(1, i - windowSize);
        tracks = findTracks(estimatedView, startFrame:i);
        camPoses = poses(estimatedView, startFrame:i);
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
        
        estimatedView = updateView(estimatedView, camPoses);
 end
    updateCamera(i,trajectoryEstimated,camEstimated,poses(estimatedView));    
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