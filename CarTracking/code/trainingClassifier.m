clc;clear all; close all; warning('off');
%%
negativeFolder = fullfile('..\Input\non-vehicles\Extras\');

positiveFolder = fullfile('..\Input\vehicles\');

negativeImages = imageDatastore(negativeFolder,'IncludeSubfolders',true);
positiveImages = imageDatastore(positiveFolder,'IncludeSubfolders',true);

value = [1 1 64 64];

positiveStruct = struct(positiveImages);
positiveImg(:,1) = cell2table(positiveStruct.Files);
for i =1:positiveStruct.NumFiles
    positiveImg(i,2) = table(value);
end
%%
trainCascadeObjectDetector('cascadeClassifier.xml',positiveImg, ...
    negativeFolder,'FalseAlarmRate',0.05,'NumCascadeStages',10);
