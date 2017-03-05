close all;clear all;clc;
load Parameter.mat;
cd ..;
folder = @(i) fullfile(sprintf('Images/TrainingSet/Frames/%03d.jpg',i));
to=2;
image=cell(to,1);
for k=1:to
    image{k} = imread(folder(k));
end
cd Scripts;
for k=1:to
    figure(1),imshow(image{k});
%     [segI,loc] = detecteBuoy(imgaussfilt(image{k},5),green_mu,green_sigma,1.55e-5);
    [segI,loc] = detecteBuoy(imgaussfilt(image{k},15),red_mu,red_sigma,11e-6);
    figure, imshow(segI); 
    hold on; 
    plot(loc(1), loc(2), '+r','MarkerSize',10); 
    contour = bwboundaries(segI,'noholes');
    plot(contour{1}(:,2),contour{1}(:,1),'g','LineWidth',2);
%     disp('Press any key to continue. (Ctrl+c to exit)')
    pause(1/10);
end
