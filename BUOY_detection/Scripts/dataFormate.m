clear all;close all;clc;
cd ..;
video=VideoReader('images/detectbuoy.avi');
mkdir('images/TrainingSet/Frames/');
mkdir('Images/TrainingSet/CroppedBuoys/');
mkdir('Images/TestSet/Frames/');
folder = @(i) fullfile(sprintf('Images/TrainingSet/Frames/%03d.jpg',i));
testFolder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
folderR = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/R_%03d.jpg',i));
folderY = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/Y_%03d.jpg',i));
folderG = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/G_%03d.jpg',i));

writeImg=@(img,i) imwrite(img,i);
k=1;
maxTrain=20;
while hasFrame(video)
    I=readFrame(video);
    if k <= maxTrain
        imshow(I);hold on;
        writeImg(I,folder(k));
        title(sprintf('Red-%d',k));
        mask = roipoly(I);
        imshow(mask);
        writeImg(mask,folderR(k));
        pause;
        title(sprintf('Yellow-%d',k));
        mask = roipoly(I);
        imshow(mask);
        writeImg(mask,folderY(k));
        pause;
        title(sprintf('Green-%d',k));
        mask = roipoly(I);
        imshow(mask);
        writeImg(mask,folderG(k));
        pause
    else
        writeImg(I,testFolder(k-maxTrain));
    end
    k = k+1;
end
cd scripts;