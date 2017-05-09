function [points , feature,idxPair]=customMatchFeature(image,pFeature)
if size(image,3) == 3
image=rgb2gray(image);
end
[points , feature]=customFeature(image);
idxPair = matchFeatures(pFeature, feature, 'Unique', true);
end