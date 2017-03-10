clear all;
close all;
clc;

for i=1:180
    title(i);
    detecteBuoy(i,1);
    pause(1/20);
end