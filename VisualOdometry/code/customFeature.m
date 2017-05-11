function [points , feature, vPoints] = customFeature(image)
if size(image,3) == 3
image=rgb2gray(image);
end
points = detectSURFFeatures(image,'MetricThreshold', 200);
% points = detectFASTFeatures(image);
points = selectUniform(points, 500, size(image));
% points = selectStrongest(points, 200);%, size(image));
[feature, vPoints] = extractFeatures(image, points, 'Upright', true);
end