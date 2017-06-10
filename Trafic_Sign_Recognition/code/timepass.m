clear all;close all;clc;
run('vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup.m');

cd ..;cd blueModel\;

trainingSet=imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldername');
cd ..;cd code\;

numImages=numel(trainingSet.Files);

result=readimage(trainingSet,1);
result=imresize(result,[64 64]);
for i=2:numImages
    img=readimage(trainingSet,i);
    img=imresize(img,[64 64]);
    result=(result)+(img);
end
% result=result./numImages;
figure(1) ;
% imagesc(vl_hog('render', w)) ;
imshow(result,[]);

