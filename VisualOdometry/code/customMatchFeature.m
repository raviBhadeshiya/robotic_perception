function [points , feature,idxPair, vPoints]=customMatchFeature(image,pFeature,pImage,pvPoints)
if size(image,3) == 3
image=rgb2gray(image);
end
[points , feature, vPoints]=customFeature(image);
idxPair = matchFeatures(pFeature, feature, 'Unique', true);
matchedPoints1 = pvPoints(idxPair(:, 1));
matchedPoints2 = vPoints(idxPair(:, 2));
end