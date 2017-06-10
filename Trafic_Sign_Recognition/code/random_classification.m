clear all;
close all;
clc;
run('C:\Users\rnbha\Desktop\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup.m');
counter=1;
for i=32640:35500
    if rand > 0.80
        cd ..;
        image1=imread(sprintf('input/image.0%d.jpg',i));
        %         image1 = imgaussfilt(image1);
        cd scripts\;
        %         figure(1);
        %         imshow(image1);hold on;
        for j=1:randi([1 15])
            [height,width] = getRandomPatch();
            x=randi([width 1236-11*width]);
            y=randi([2*height 1628-2*height]);
            temp=imcrop(image1,[y x width height]);
            %             rectangle('Position',[y x width height],'EdgeColor','b','linewidth',2);
            patch= imresize(temp,[64,64]);
            cd ..;
            imwrite(patch,sprintf('random/image.0%d.jpg',counter));
            cd scripts\;
            counter=counter+1
        end
        %         hold off;
        %         pause(1/30);
    end
end