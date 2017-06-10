clear all;
close all;
clc;
% tic
colorDistribution
cd ..; cd ..; cd Output\extraCredit_hsv\;
vidWriter=VideoWriter('hsv.mp4','MPEG-4');
cd ..;cd ..;cd Scripts\extraCredit_hsv\;
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