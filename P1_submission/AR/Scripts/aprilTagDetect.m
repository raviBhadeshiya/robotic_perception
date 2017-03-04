function [id,pts] = aprilTagDetect(img,pts,refImage)
[rY, rX, ~] = size(refImage);
ref_pts = [0 0; rX 0; rX rY; 0 rY];
% idx=[1 2 3 4];
% p=perms(idx);
id=0;
[~,I] = sort(angle(complex(pts(:,1)-mean(pts(:,1)),pts(:,2)-mean(pts(:,2)))));
pts=pts(I,:);
for i=1:4
    transRef=fitgeotrans(pts,ref_pts,'projective');
    warpedTag=imwarp(img,transRef,'OutputView',imref2d(size(refImage)));
%     figure(1);
%     imshow(warpedTag);
    ID=imbinarize(rgb2gray(imresize(warpedTag,[8,8])));

    if(probDetect(ID,90))%tempId==refId)
        id=8*ID(5,4)+4*ID(5,5)+2*ID(4,5)+ID(4,4);
    else
        pts=circshift(pts,1);
    end
end
end
