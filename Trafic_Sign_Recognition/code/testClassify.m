clear all; close all; clc;
% tic
run('vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup.m');

cd ..; cd testing\;%cd 00045\;
trainingSet=imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldername');
cd ..;cd isModel\;
trainingSetBin=imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldername');
cd ..\code\;
% cellSize=8;
cellSize=8;
zerosSize=31*(64/cellSize)*(64/cellSize);
% Blue
numImages=numel(trainingSet.Files);
aHogSet=zeros(numImages,zerosSize);
for i=1:numImages
    img=readimage(trainingSet,i);
    img=imresize(img,[64 64]);
    aHogTrain=vl_hog(im2single(img),cellSize);%,'verbose');
    aHogSet(i,:)=reshape(aHogTrain,1,[]);
end
trainingLabels=trainingSet.Labels;
disp('class');
Classifier=fitcecoc(aHogSet,trainingLabels);
numImagesBin=numel(trainingSetBin.Files);
aHogSetBin=zeros(numImagesBin,zerosSize);
for i=1:numImagesBin
    img=readimage(trainingSetBin,i);
    img=imresize(img,[64 64]);
    aHogTrain=vl_hog(im2single(img),cellSize);%,'verbose');
    aHogSetBin(i,:)=reshape(aHogTrain,1,[]);
end
trainingLabelBin=trainingSetBin.Labels;
disp('class');
isClassifier = fitcsvm(aHogSetBin, trainingLabelBin);
save('isClassifier.mat', 'isClassifier','-v7.3');
save('blueClassifier.mat','Classifier','-v7.3');
% toc