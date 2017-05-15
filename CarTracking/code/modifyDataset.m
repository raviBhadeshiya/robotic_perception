clc; clear all; close all;warning('off');

index = 0;
trainFolder = '..\Input\vehicles\myposFIles\';
negativeFolder = fullfile('..\Input\vehicles');

negativeImages = imageDatastore(negativeFolder,'IncludeSubfolders',true);

negativeStruct = struct(negativeImages);

for i =1:negativeStruct.NumFiles
    img = imread(char(negativeStruct.Files(i)));
    rimg=flip(img,2);
    imwrite(rimg,fullfile(trainFolder,sprintf('file_%d.png',i)),'png');
end