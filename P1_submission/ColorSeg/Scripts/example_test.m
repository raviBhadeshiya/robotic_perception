close all;clear all;clc;
load Parameter.mat;
cd ..;
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
to=20;
image=cell(to,1);
for k=1:to
    image{k} = imread(folder(k));
end
cd Scripts;
for k=1:to
    figure(1),imshow(image{k});
    [segI, loc] = detecteBuoy(imgaussfilt(image{k}),red_mu,red_sigma,1e-7);
%     figure, imshow(segI); 
    hold on; 
    plot(loc(1), loc(2), '+r','MarkerSize',10); 
%     disp('Press any key to continue. (Ctrl+c to exit)')
    pause(1/10);
end
