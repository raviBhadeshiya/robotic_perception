clear all;
close all;
clc;
for i=1:180
    title(i);
    tryDetect(i,1);
    pause(1/20);
end