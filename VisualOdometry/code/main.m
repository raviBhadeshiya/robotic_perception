%%
% close all;warning off;load('data.mat');
clc;clear all;close all;warning off;
cd ..;
imgFolder = fullfile('input\Oxford_dataset\stereo\centre\');
allImages = imageDatastore(imgFolder,'IncludeSubfolders',true);
model=fullfile('..\input\Oxford_dataset\model');
cd code;
[fx, fy, cx, cy, G_camera_image, LUT]=ReadCameraModel(imgFolder,model);clc;
K=[fx 0 cx;0 fy cy;0 0 1];
cameraParams = cameraParameters('IntrinsicMatrix', K');
%%

start=1;

for i = start:length(allImages.Files)
    image = demosaic(readimage(allImages,i),'gbrg');
    undistortedImg = UndistortImage(image,LUT);
    if (i < start+1)
        
    else    
        [point1,point2]=matchPoint(rgb2gray(undistortedImg),rgb2gray(pImage));
        figure(1); showMatchedFeatures(undistortedImg,pImage,point1,point2);
        [orient, loc] = helperEstimateRelativePos(...
            point1, point2, cameraParams)
    end
%     figure(1);
%     imshow(undistortedImg);
    pImage=undistortedImg;
%     pause(1/10);
end