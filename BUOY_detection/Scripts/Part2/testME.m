clear all;
close all;
clc;
colorDistribution
cd ..; cd ..; cd Output\Part2\;
vidWriter=VideoWriter('GaussianMM.mp4','MPEG-4');
cd ..;cd ..;cd Scripts\Part2\;
open(vidWriter);
for i=1:180
    title(i);
    virtualFrame=detectBuoy(i,1);
    writeVideo(vidWriter,virtualFrame);
    pause(1/60);
end
close(vidWriter)
close all;
clear all;