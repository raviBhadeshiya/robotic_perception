function [points , feature] = customFeature(image)
if size(image,3) == 3
image=rgb2gray(image);
end
points = detectSURFFeatures(image,'MetricThreshold', 400);
% points = detectFASTFeatures(image);
points = selectUniform(points, 200, size(image));
feature = extractFeatures(image, points, 'Upright', true);
end