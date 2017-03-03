function [corner_pts]=findCorner(image)

% firstFrame=imgaussfilt(rgb2gray(image));
% [r c]=size(firstFrame);
% firstFrame=imbinarize(firstFrame);
% 
% CC=bwconncomp(~firstFrame);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% firstFrame(CC.PixelIdxList{idx}) = 1;
% 
% CC=bwconncomp(firstFrame);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [smallest,idx] = min(numPixels);
% firstFrame(CC.PixelIdxList{idx}) = 0;

firstFrame=findBlob(image);
[rows cols]=size(firstFrame);

% corner_pts= corner(firstFrame,4);
% imshow(gmag);hold on;
% plot(cor(:,1),cor(:,2),'r*');

[~,r,c]=harris(firstFrame,2,0.04,'N',4);

corner_pts=[c r];
% gmag=edge(~firstFrame,'canny');
% gmag=bwmorph(gmag,'thin');
% [H,T,R] = hough(gmag);
% 
% P  = houghpeaks(H,4);
% 
% lines = houghlines(firstFrame,T,R,P,'Fillgap',250);
% corner_pts=cornerPoints(lines,rows,cols);
% imshow(firstFrame);hold on;
% for k = 1:length(lines)
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% end
end