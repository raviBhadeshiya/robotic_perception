close all;clear all;clc;
load Parameter.mat;
cd ..;
<<<<<<< HEAD
folder = @(i) fullfile(sprintf('Images/TestSet/Frames/%03d.jpg',i));
to=120;
=======
folder = @(i) fullfile(sprintf('Images/TrainingSet/Frames/%03d.jpg',i));
to=2;
>>>>>>> refs/remotes/origin/newthing
image=cell(to,1);
for k=1:to
    image{k} = imread(folder(k));
end
cd Scripts;
for k=1:to
    figure(1),imshow(image{k});
<<<<<<< HEAD
%     image{k}=rgb2lab(image{k});
    value=image{k}(:,:,1);
    value=imadjust(value);
    image{k}=cat(3,value,image{k}(:,:,2),image{k}(:,:,3));
%     image{k}=lab2rgb(image{k});
    [segI, loc] = detecteBuoy(imgaussfilt(image{k},3),red_mu,red_sigma,2.5e-7);
%     figure, imshow(segI); 
    hold on; 
    plot(loc(1), loc(2), '+r','MarkerSize',10); 
=======
%     [segI,loc] = detecteBuoy(imgaussfilt(image{k},5),green_mu,green_sigma,1.55e-5);
    [segI,loc] = detecteBuoy(imgaussfilt(image{k},15),red_mu,red_sigma,11e-6);
    figure, imshow(segI); 
    hold on; 
    plot(loc(1), loc(2), '+r','MarkerSize',10); 
    contour = bwboundaries(segI,'noholes');
    plot(contour{1}(:,2),contour{1}(:,1),'g','LineWidth',2);
>>>>>>> refs/remotes/origin/newthing
%     disp('Press any key to continue. (Ctrl+c to exit)')
    pause(1/10);
end
