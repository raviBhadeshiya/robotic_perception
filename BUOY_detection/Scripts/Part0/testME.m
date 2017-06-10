clear all;
close all;
clc;
colorDistribution
cd ..; cd ..; cd Output\Part0\;
vidWriter=VideoWriter('singleGaussian.mp4','MPEG-4');
cd ..;cd ..;cd Scripts\Part0\;
open(vidWriter);
for i=1:180
    title(i);
    virtualFrame=detecteBuoy(i,1);
    writeVideo(vidWriter,virtualFrame);
    pause(1/60);
end
close all;
clear all;
close(vidWriter);