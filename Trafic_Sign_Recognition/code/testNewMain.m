% testClassify

% clear all;

close all;
clc;

blueCutofff=-0.0004;
redCutoff=-0.004;

% tic;
run('vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup.m')
aHog={};
bHog={};
cellSize=8;

% load isClassifier.mat
% load blueClassifier.mat

load isClassifier.mat
load redModel.mat
load blueModel.mat
% run(loadImg.m);

warning('off');

load vidCounter.mat
cd ..;cd output/;
vidWriter=VideoWriter(sprintf('output_cell_%d.avi',vidCounter));
vidWriter.FrameRate = 30;
cd ..;cd code/;

open(vidWriter);
for i=33530:35500
    i
    tic
    cd ..;
    image1=imread(sprintf('input/image.0%d.jpg',i));
    tempImage=zeros(size(image1,1),size(image1,2),size(image1,3));
    image1 = imgaussfilt(image1,0.2);
    cd code\;
    
    globalStore={};
    globalCount=1;
    
    image=ndrgb2hsv(double(image1));
    a=blue_segment(image(:,:,1),image(:,:,2),image(:,:,3));
    if size(a,2)~=0
        aPatch=get_patch(image1,a);
        for x=1:size(aPatch,1)
            aHog=vl_hog(im2single(aPatch{x,1}),cellSize);%,'verbose');
            %             [predictedLabels,scoreb]= signPredict(aHog,isClassifier,Classifier);
            [predictedLabels,scoreb]= signPredict(aHog,binClassifier,blueClassifier);
            
            for labelB={'00035','00038','00045'}
                if predictedLabels == labelB %&& scoreb > blueCutofff
                    tempStr=strcat(labelB,'.jpg');
                    patchImage=imread(tempStr{1});
                    tempImage=imagePatch(tempImage, patchImage, a{x});
                    globalStore{globalCount,1}=a{x}.BoundingBox;
                    globalStore{globalCount,2}=labelB;
                    globalCount=globalCount+1;
                    break;
                end
            end
        end
    end
    
    b=red_segment(image(:,:,1),image(:,:,2),image(:,:,3));
    if size(b,2)~=0
        bPatch=get_patch(image1,b);
        for y=1:size(bPatch,1)
            bHog=vl_hog(im2single(bPatch{y,1}),cellSize);%,'verbose');
            [predictedLabels,scorec] = signPredict(bHog,binClassifier,redClassifier);
            for labelR={'00001','00014','00017','00019','00021'}
                if predictedLabels == labelR %&& scorec > redCutofff
                    %                     rectangle('Position',b{y}.BoundingBox,'EdgeColor','r','linewidth',2);
                    tempStr=strcat(labelR,'.jpg');
                    patchImage=imread(tempStr{1});
                    tempImage=imagePatch(tempImage, patchImage, b{y});
                    globalStore{globalCount,1}=b{y}.BoundingBox;
                    globalStore{globalCount,2}=labelR;
                    globalCount=globalCount+1;
                    
                    break;
                end
            end
        end
        
    end
    
    image1=imadd(image1, uint8(tempImage));
    
    figure(1);
    imshow(image1);hold on;
    for index=1:size(globalStore,1)
        rectangle('Position',globalStore{index,1},'EdgeColor','r','linewidth',2);
        text(globalStore{index,1}(1)-5,...
            globalStore{index,1}(2)-10,...
            globalStore{index,2}(1), 'FontSize', 5, 'FontWeight', 'Bold',...
            'Color', 'r');
    end
    writeVideo(vidWriter,getframe);
    hold off;
    pause(1/30);
    toc
end


close(vidWriter);
close all;
vidCounter=vidCounter+1;
save('vidCounter.mat','vidCounter');
% toc;