clear all;close all;clc;
cd ..;
video=VideoReader('images/detectbuoy.avi');
mkdir('images/TrainingSet/Frames/');
mkdir('Images/TrainingSet/CroppedBuoys/');
folder = @(i) fullfile(sprintf('Images/TrainingSet/Frames/%03d.jpg',i));
folderR = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/R_%03d.jpg',i));
folderY = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/Y_%03d.jpg',i));
folderG = @(i) fullfile(sprintf('Images/TrainingSet/CroppedBuoys/G_%03d.jpg',i));

writeImg=@(img,i) imwrite(img,i);
k=1;
while hasFrame(video) && k < 21;
    I=readFrame(video);
    imshow(I);hold on;
    writeImg(I,folder(k));
    
    title('Red');
    mask = roipoly(I);
    imshow(mask);
    writeImg(mask,folderR(k));
    
    
    pause;
    title('Yellow');
    mask = roipoly(I);
    imshow(mask);
    writeImg(mask,folderY(k));
    
    pause;
    title('Green');
    mask = roipoly(I);
    imshow(mask);
    writeImg(mask,folderG(k));
    
    pause
    k = k+1;
end
cd scripts;
