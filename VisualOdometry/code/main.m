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
player = vision.VideoPlayer('Position', [20, 400, 650, 510]);
%%
image = demosaic(readimage(allImages,1),'gbrg');
pImage = UndistortImage(image,LUT);
step(player, pImage);
[pPoints , pFeature, pvPoints] = customFeature(pImage);
estimatedView = viewSet;
estimatedView = addView(estimatedView, 1, 'Points', pPoints, 'Orientation',...
    eye(3),'Location', [0 0 0]);

image = demosaic(readimage(allImages, 2),'gbrg');
undistortedImg = UndistortImage(image,LUT);
[points,feature,indexPairs,vPoints] = customMatchFeature(undistortedImg,pFeature,pImage,pvPoints);
step(player, undistortedImg);
matchedPoints1 = pPoints(indexPairs(:,1));
matchedPoints2 = points(indexPairs(:,2));

[F,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
    'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
indexPairs = indexPairs(inlierIdx,:);
E = FtoEmatrix(F,K);
matchedPoints1 = pPoints(indexPairs(:,1));
matchedPoints2 = points(indexPairs(:,2));

% E=EssentialMatrixFrom2DPoints([matchedPoints1.Location ones(matchedPoints1.Count,1)]'...
%     ,[matchedPoints2.Location ones(matchedPoints2.Count,1)]',K);
% [Cset,Rset] = EssentialMatrixToCameraMatrix(E);
[Cset,Rset] = ExtractCameraPose(E);

[cRot,cT,~] = SelectCorrectEssentialCameraMatrix(Rset,Cset,...
    [matchedPoints1.Location ones(matchedPoints1.Count,1)]',...
    [matchedPoints2.Location ones(matchedPoints2.Count,1)]',K);

estimatedView = addView(estimatedView, 2, 'Points', points,...
    'Orientation', cRot,'Location', cT');
estimatedView = addConnection(estimatedView, 1, 2, 'Matches', indexPairs);

pImage = undistortedImg;
pPoints = points;
pFeature = feature;
pvPoints = vPoints;
%%
figure
axis([-1000, 20, -30, 500, -2000, 0]);
% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, 120, 0, 'data', [0, 1, 0]);

grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on;

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
    
    step(player, undistortedImg);
    [points,feature,indexPairs,vPoints] = customMatchFeature(undistortedImg,pFeature,pImage, pvPoints);
    matchedPoints1 = pPoints(indexPairs(:,1));
    matchedPoints2 = points(indexPairs(:,2));
    
    [F,inlierIdx] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,...
        'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4);
    indexPairs = indexPairs(inlierIdx,:);
    
    E = FtoEmatrix(F,K);
    [Cset,Rset] = ExtractCameraPose(E);
    
    [cRot,cT,~] = SelectCorrectEssentialCameraMatrix(Rset,Cset,...
    [matchedPoints1.Location ones(matchedPoints1.Count,1)]',...
    [matchedPoints2.Location ones(matchedPoints2.Count,1)]',K);

    cT = cT'*estimatedView.Views.Orientation{i-1} + estimatedView.Views.Location{i-1};
    cRot = cRot * estimatedView.Views.Orientation{i-1};
    
    estimatedView = addView(estimatedView, i, 'Points', points,...
    'Orientation', cRot,'Location', cT);

    if (mod(i,3) == 0)
        windowSize = 1;
        startFrame = max(1, i - windowSize);
        tracks = findTracks(estimatedView, startFrame:i);
        camPoses = poses(estimatedView, startFrame:i);
        [xyzPoints, reprojErrors] = triangulateMultiview(tracks, camPoses, ...
            cameraParams);
        
        % Hold the first two poses fixed, to keep the same scale.
        fixedIds = [startFrame, startFrame+1];
        
        % Exclude points and tracks with high reprojection errors.
        idx = reprojErrors < 8;
        
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
    pvPoints = vPoints;
    pause(1/10);
end

%%
load gong.mat;
sound(y);

figure
% view(gca, 3);
view([0 0]);
% set(gca, 'CameraUpVector', [0, -1, 0]);
set(gca,'Xdir','reverse');
set(gca,'Zdir','reverse');
locations = cat(1, estimatedView.Views.Location{:});
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on;
% Plot estimated camera pose.
trajectoryEstimated = plot3(0,0,0, 'g-');
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    zeros(size(locations,1),1), 'ZData', locations(:,3));