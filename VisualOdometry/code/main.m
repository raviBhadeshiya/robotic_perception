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
figure
axis([-50, 50, -140, 20, -10, 1000]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);

grid on
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on

cameraSize = 7;
camEstimated = plotCamera('Size', cameraSize, 'Location',...
    [0 0 0], 'Orientation', eye(3),...
    'Color', 'g', 'Opacity', 0);
trajectoryEstimated = plot3(0, 0, 0, 'g-');
title('Camera Trajectory');
%%
start=1;

for i = start:length(allImages.Files)
    image = demosaic(readimage(allImages,i),'gbrg');
    undistortedImg = UndistortImage(image,LUT);
    
   
    
    
    pImage=undistortedImg;
    pause(1/10);
end