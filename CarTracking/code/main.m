clear all; close all; clc;

%%
cd ../input;
videoFReader = vision.VideoFileReader('simple.avi');
carDetector=vision.CascadeObjectDetector('cars.xml');
cd ../code;
videoFWriter = vision.VideoFileWriter('../Output/output.mp4','FileFormat','MPEG4');
%%
carDetector.MergeThreshold=1;
carDetector.MinSize=[50 50];
videoFrame=videoFReader();
videoFrame(1:240,:,:)=0;
boundingBox=step(carDetector, videoFrame);
carAnotate=insertObjectAnnotation(videoFrame, 'rectangle', boundingBox, 'Car');
imshow(carAnotate);

%%
videoPlayer  = vision.VideoPlayer('Position',...
    [100 100 [size(videoFrame, 2), size(videoFrame, 1)]+30]);

%%
for i=1:size(boundingBox,1)
    
    pointTracker{i} = vision.PointTracker('MaxBidirectionalError',2);
    points = detectSURFFeatures(rgb2gray(videoFrame),'ROI', boundingBox(i,:), 'MetricThreshold', 300, 'NumOctaves', 20);
    
    %         points = detectHarrisFeatures(rgb2gray(videoFrame),'ROI', boundingBox(i,:), 'MinQuality', 0.00005);
    %         points = detectMSERFeatures(rgb2gray(videoFrame),'ROI', boundingBox(i,:),'MaxAreaVariation',0.8);
    %     points = detectBRISKFeatures(rgb2gray(videoFrame),'ROI', boundingBox(i,:));
    
    initialize(pointTracker{i},points.Location,videoFrame);
    bboxPoints{i} = bbox2points(boundingBox(i,:));
    
    pointsStruct{i} = points.Location;
    oldPoints{i} = pointsStruct{i};
end

%%
while ~isDone(videoFReader)
    % get the next frame
    videoFrame = step(videoFReader);
    visiblePointsList=[];
    oldInliers=[];
    % Track the points. Note that some points may be lost.
    for j=1:length(pointTracker)
        
        [points, isFound] = step(pointTracker{j}, videoFrame);
        visiblePoints{j} = points(isFound, :);
        visiblePointsList = [visiblePointsList; visiblePoints{j}];
        oldInliers = [oldInliers; oldPoints{j}(isFound, :)];
        
    end
    %         if size(visiblePoints{j}, 1) >= 2 % need at least 2 points
    
    % Estimate the geometric transformation between the old points
    % and the new points and eliminate outliers
    [xform, oldInliers, visiblePointsList] = estimateGeometricTransform(...
        oldInliers, visiblePointsList, 'similarity', 'MaxDistance', 1);
    for j=1:length(pointTracker)
        % Apply the transformation to the bounding box points
        bboxPoints{j} = transformPointsForward(xform, bboxPoints{j});
        
        % Insert a bounding box around the object being tracked
        bboxPolygon = reshape(bboxPoints{j}', 1, []);
        videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, ...
            'LineWidth', 2, 'Color', [255*(j-1) 255*(j-2) 255*(mod(j,2))]);
        
        % Display tracked points
        videoFrame = insertMarker(videoFrame, visiblePoints{j}, '+', ...
            'Color', 'white');
        % Reset the points
        oldPoints{j} = visiblePoints{j};
        setPoints(pointTracker{j}, oldPoints{j});
    end
    
    % Display the annotated video frame using the video player object
    step(videoPlayer, videoFrame);
    step(videoFWriter,videoFrame);
end



% Clean up
release(videoFReader);
release(videoPlayer);
release(videoFWriter);
for i=1:length(pointTracker)
    release(pointTracker{i});
end