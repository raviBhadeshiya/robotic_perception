clear all;
close all;
clc;
colorDistribution
for i=1:180
    title(i);
    detectBuoy(i,1);
    pause(1/60);
end
