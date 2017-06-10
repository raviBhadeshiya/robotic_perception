clear all;close all;clc;
cd ..;
video=VideoReader('input/project_video.mp4');
numberToExtract=2;

cd output/;

vidWriter=VideoWriter('Result1.avi');

vidWriter.FrameRate=30;

cd ..;

open(vidWriter);

cd code;
rectI=zeros(720,720);
trap=[178 720; 552 450; 728 450; 1280 720];
rect=[475 720; 475 0; 800 0; 800 720];
c = [552 178 1280 728];
r = [450 720 720 450];
BW = poly2mask(c,r,720,1280);
i=1;
while hasFrame(video) && (i <= 510)
    
    mainframe = readFrame(video);
    
    frame=mainframe;
    
    frame=undistortimage(frame, 1.6281e+03, 6.71627794e+02, 3.86046312e+02, -2.42565104e-01,-4.77893070e-02,-1.31388084e-03,-8.79107779e-05,2.20573263e-02);
    
    frame=imgaussfilt(frame,2);
    
    gray=rgb2gray(frame);
    
    gray=uint8(BW).*gray;
    
    gray=im2bw(gray,0.65);
    
    gray=imdilate(gray,strel('disk',6));
    [labeledImage, numberOfBlobs] = bwlabel(gray);
    blobMeasurements = regionprops(labeledImage, 'area');
    allAreas = [blobMeasurements.Area];
    [sortedAreas, sortIndexes] = sort(allAreas, 'descend');
    biggestBlob1 = ismember(labeledImage, sortIndexes(1));
    if size(sortIndexes,2)>2
        biggestBlob2 = ismember(labeledImage, sortIndexes(2:3));
    else
        biggestBlob2 = ismember(labeledImage, sortIndexes(2));
    end
    biggestBlob2=imerode(biggestBlob2,strel('disk',4));
    stats1=regionprops(biggestBlob1,'Extrema');
    stats2=regionprops(biggestBlob2,'Extrema');
    stats2E=[];
    stx=[];sty=[];
    for j=1:size(stats2,1)
        stats2E=[stats2E;stats2(j).Extrema];
        stx=[stx,stats2(j).Extrema(:,1)];
        sty=[sty,stats2(j).Extrema(:,2)];
    end
    stx=median(stx')';
    sty=median(sty')';
    
    fit1=polyfit(stats1.Extrema(:,1),stats1.Extrema(:,2),1);
    m1=fit1(1);
    c1=fit1(2);
    xLeftTop=(500-c1)/m1;
    xLeftBottom=(700-c1)/m1;
    fitV1=polyval(fit1,[xLeftTop;xLeftBottom]);
    
    if(mod(i+2,3)==0)
        fit2=polyfit(stx,sty,1);
        fitV23=polyval(fit2,stx);
        m2=fit2(1);
        c2=fit2(2);
        xRighTop=(500-c2)/m2;
        xRightBottom=(700-c2)/m2;
        fitV2=polyval(fit2,[xRighTop;xRightBottom]);
    end

%     gray2=bwmorph(gray,'thin',20);
    red=poly2mask([xLeftTop,xLeftBottom,xRightBottom,xRighTop],[500,700,700,500],720,1280);
    mainframe(:,:,1)=imadd(double(mainframe(:,:,1)),double(100*red));
    
    figure(1);
    
    imshow(mainframe);hold on;
    title(i);
    [dir xi yi]=turnPridict(fit1,fit2);
    
    
    plot(xi,420,'g+');
    plot(640,420,'r+');
%     line([640-15,640+15],[420,420]);
    text(1100,650,['Toward ',dir],'fontSize',10,'Color','c');
    
    plot([xLeftTop;xLeftBottom],fitV1,'LineWidth',5,'Color',[0.9 0.8 0.25]);
    plot([xRighTop;xRightBottom],fitV2,'LineWidth',5,'Color',[0.9 0.8 0.25]);
    
    writeVideo(vidWriter,getframe);
    
    i=i+1;
    pause(1/10);
end
vidWriter.close();