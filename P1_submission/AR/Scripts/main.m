%%
clear all;close all;clc;
cd ..;cd Data/;
logo_img = imread('lena.png');
refImage=rgb2gray(imread('ref_marker.png'));
video=VideoReader('Tag0.mp4');cd ..;cd Scripts/;
warning('off','all');
%%
fromNumber=1;
toNumber=120;
tagFrame=read(video,fromNumber+1);
tagCorner=findCorner(tagFrame);
tagFrame=imsharpen(tagFrame,'Amount',20);
[ID,~]=aprilTagDetect(tagFrame,tagCorner,refImage);

%%
frame=cell(toNumber-fromNumber:1);
corner_pts=cell(toNumber-fromNumber:1);
id=zeros(toNumber-fromNumber:1);
k = 0;
[logoy, logox, ~] = size(logo_img);
logo_pts = [0 0; logox 0; logox logoy; 0 logoy];
% while hasFrame(video) && k < toNumber
for index=fromNumber:toNumber
    k = k+1
    if(fromNumber < k)
        index=k-fromNumber;
        frame{index} = (read(video,index));
%         frame{index} = imgaussfilt(readFrame(video));
        corner_pts{index}=findCorner(frame{index});
        if(length(corner_pts{index})==4)
            [~,corner_pts{index}]=aprilTagDetect(frame{index},corner_pts{index},refImage);
            frame{index}=lenaProject(logo_pts,corner_pts{index},logo_img,frame{index});
            figure(1);
            imshow(frame{index});hold on;text(corner_pts{index}(1,1),corner_pts{index}(1,2),(['Tag ID is ',num2str(ID)]));
            title(['Tag ID is ',num2str(ID)]);
%             plot(corner_pts{index}(:,1),corner_pts{index}(:,2),'MarkerSize',10);
%             cubeProject(frame{index},corner_pts{index});
        end
    end
end
% %
% % close all;
% % play_video(frame,corner_pts,id(1));