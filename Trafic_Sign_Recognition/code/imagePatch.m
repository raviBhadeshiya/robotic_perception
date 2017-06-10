function img = imagePatch(img,patchImg,q)

patch=imresize(patchImg,[q.BoundingBox(4)+1 q.BoundingBox(3)+1]);

pY1 = abs(int32(q.BoundingBox(1)-q.BoundingBox(3)));
pX1 = abs(int32(q.BoundingBox(2)));
pY2 = abs(int32(q.BoundingBox(1)));
pX2 = abs(int32(q.BoundingBox(2)+q.BoundingBox(4)));

if pY1-q.BoundingBox(3)>0 && pX1+q.BoundingBox(4)<1236
    
    img(pX1:pX2, pY1:pY2,1)= patch(1:size(patch,1), 1:size(patch,2),1);
    img(pX1:pX2, pY1:pY2,2)= patch(1:size(patch,1), 1:size(patch,2),2);
    img(pX1:pX2, pY1:pY2,3)= patch(1:size(patch,1), 1:size(patch,2),3);
    
else
    
    pY1 = abs(int32(q.BoundingBox(1)+q.BoundingBox(3)));
    pX1 = abs(int32(q.BoundingBox(2)));
    pY2 = abs(int32(q.BoundingBox(1)));
    pX2 = abs(int32(q.BoundingBox(2)+q.BoundingBox(4)));
%     img(pX1:pX2, pY1:pY2,1)= patch(1:size(patch,1), 1:size(patch,2),1);
%     img(pX1:pX2, pY1:pY2,2)= patch(1:size(patch,1), 1:size(patch,2),2);
%     img(pX1:pX2, pY1:pY2,3)= patch(1:size(patch,1), 1:size(patch,2),3);
end
end