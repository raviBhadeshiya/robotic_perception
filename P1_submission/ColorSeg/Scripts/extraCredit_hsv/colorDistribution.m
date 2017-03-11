close all;clear all;clc;cd ..;cd ..;
train = 'Images/TrainingSet/Frames/';
coroped='Images/TrainingSet/CroppedBuoys/';
mkdir('Output/extraCredit_hsv/');
folder = @(i) fullfile(sprintf('Output/extraCredit_hsv/%s_hist.jpg',i));
%%
SamplesR = [];
SamplesY = [];
SamplesG = [];
for k=1:20
    % Load image
    I = imread(sprintf('%s/%03d.jpg',train,k));
    I=imgaussfilt(I,2);
    I=rgb2hsv(I);
    % You may consider other color space than RGB
    H = double(I(:,:,1));
    S = double(I(:,:,2));
    V = double(I(:,:,3));
    % Collect Cropped samples
    %Red buoy
    maskR = imread(sprintf('%s/R_%03d.jpg',coroped,k));
    sample_ind_R = find(maskR > 0);
    HR = H(sample_ind_R);
    SR = S(sample_ind_R);
    VR = V(sample_ind_R);
    SamplesR = [SamplesR; [HR SR VR]];
    %Yellow buoy
    maskY = imread(sprintf('%s/Y_%03d.jpg',coroped,k));
    sample_ind_Y = find(maskY > 0);
    HY = H(sample_ind_Y);
    SY = S(sample_ind_Y);
    GY = V(sample_ind_Y);
    SamplesY = [SamplesY; [HY SY GY]];
    %Green buoy
    maskG = imread(sprintf('%s/G_%03d.jpg',coroped,k));
    sample_ind_G = find(maskG > 0);
    HG = H(sample_ind_G);
    SG = S(sample_ind_G);
    VG = V(sample_ind_G);
    SamplesG = [SamplesG; [HG SG VG]];
end
%%
%visualize the sample distribution
figure,
scatter3(SamplesR(:,1),SamplesR(:,2),SamplesR(:,3),'.');
title('Pixel Color Distribubtion');
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
saveas(gcf,folder('R'));
figure,
scatter3(SamplesY(:,1),SamplesY(:,2),SamplesY(:,3),'.');
title('Pixel Color Distribubtion');
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
saveas(gcf,folder('Y'));
figure,
scatter3(SamplesG(:,1),SamplesG(:,2),SamplesG(:,3),'.');
title('Pixel Color Distribubtion');
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
saveas(gcf,folder('G'));
close all;

%%
cd scripts/extraCredit_hsv/
[mu_r,sigma_r]=estimatPerameters(SamplesR);
[mu_y,sigma_y]=estimatPerameters(SamplesY);
[mu_g,sigma_g]=estimatPerameters(SamplesG);

save('ColorSamples.mat','mu_r','sigma_r','mu_y','sigma_y','mu_g','sigma_g');
