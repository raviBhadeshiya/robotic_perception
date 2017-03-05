clear all;close all;clc;warning('off','all');

cd ..;cd Data/;

folder=@(t,i) fullfile (sprintf('Tag%d/image%03d.jpg',t,i));
tagWrite=@(img,i) imwrite(img,i);
cd ..;cd Scripts/;

for t=1:3

    cd ..; cd Data/;    
    video=VideoReader(['Tag' num2str(t-1) '.mp4']); 
    cd Input/; mkdir(sprintf('Tag%d',(t-1)));
    
    if (t-1)==0
        fromNumber=1;
        toNumber=120;
    elseif (t-1)==1
        fromNumber=1;
        toNumber=120;
    else
        fromNumber=1;
        toNumber=120;
    end
    
    for i=fromNumber:toNumber
        frame=read(video,i);
        dir=folder((t-1),i);
        tagWrite(frame,dir);
    end
    
    cd ..;
end