function [height,width] = getRandomPatch()
height=35;
width=31;
while (height/width > 1.1) || (width/height > 1.4)
height=randi([30 100]);
width=randi([30 100]);
end
end