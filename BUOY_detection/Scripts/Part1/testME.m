clear all;
close all;
clc;
% tic
colorDistribution
cd ..; cd ..; cd Output\Part1\;
vidWriter=VideoWriter('3dGaussian.mp4','MPEG-4');
cd ..;cd ..;cd Scripts\Part1\;
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