%%
clear all;close all;clc;warning('off','all');

cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));

prompt={'Please enter the name of video(e.g for Tag0.mp4, enter Tag0)'};
dlgTitle='Video Name';
tag=inputdlg(prompt, dlgTitle);
tagName=[tag{1} '.mp4'];
video=VideoReader(tagName);cd ..;cd Scripts/;
outputFolder=@(i) fullfile (sprintf('./Output/%s/image%03d.jpg',i));
%%
fromNumber=240;
toNumber=360;
tagFrame=read(video,fromNumber+1);
tagCorner=findCorner(tagFrame);
tagFrame=imsharpen(tagFrame,'Amount',20);
[ID,tagCorner]=aprilTagDetect(tagFrame,tagCorner,refImage);
figure; imshow(read(video,fromNumber+1)); hold on;
detected=plot(tagCorner(1,1),tagCorner(1,2),'r:s');detected=plot(tagCorner(2,1),tagCorner(2,2),'g:s');
detected=plot(tagCorner(3,1),tagCorner(3,2),'b:s');detected=plot(tagCorner(4,1),tagCorner(4,2),'y:s');
title(['Tag ID is ',num2str(ID)]);
text(tagCorner(1,1),tagCorner(1,2),(['Tag ID is ',num2str(ID)]));
cd ..; cd Output/; cd (tag{1});
saveas(detected,'detected.jpg');
cd ..; cd ..; cd Scripts/;

%%
frame=cell(toNumber-fromNumber:1);
corner_pts=cell(toNumber-fromNumber:1);
id=zeros(toNumber-fromNumber:1);
cd ..; cd Output/; cd (tag{1});
vidWriterHomo=VideoWriter('homography.mp4','MPEG-4');
vidWriterVirtual=VideoWriter('virtual.mp4','MPEG-4');
cd ..; cd ..; cd Scripts/;
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];
open(vidWriterHomo); open(vidWriterVirtual);
for index=fromNumber:toNumber
    
    frame{index} = (read(video,index));
    %         frame{index} = imgaussfilt(readFrame(video));
    corner_pts{index}=findCorner(frame{index});
    if(length(corner_pts{index})==4)
        [~,corner_pts{index}]=aprilTagDetect(frame{index},corner_pts{index},refImage);
        figure(1);
        lenaFrame=lenaProject(logo_pts,corner_pts{index},logo_img,frame{index});
        
        imshow(lenaFrame);hold on;text(corner_pts{index}(1,1),corner_pts{index}(1,2),...
            (['Tag ID is ',num2str(ID)]),'Color', 'red');
        homoFrame=getframe;
        figure(2);imshow(frame{index}); hold on;
        text(corner_pts{index}(1,1),corner_pts{index}(1,2),...
            (['Tag ID is ',num2str(ID)]),'Color', 'red');
        cubeProject(frame{index},corner_pts{index});
        title(['Tag ID is ',num2str(ID)]);
        virtualFrame=getframe;
        writeVideo(vidWriterHomo,homoFrame);
        writeVideo(vidWriterVirtual,virtualFrame);
        
    end
end

close(vidWriterHomo); close(vidWriterVirtual);

close all;
% play_video(frame,corner_pts,id(1));