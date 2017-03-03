function blob=findBlob(image)

firstFrame=imgaussfilt(rgb2gray(image));
[r c]=size(firstFrame);
firstFrame=imbinarize(firstFrame);

CC=bwconncomp(~firstFrame);
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);
firstFrame(CC.PixelIdxList{idx}) = 1;

CC=bwconncomp(firstFrame);
numPixels = cellfun(@numel,CC.PixelIdxList);
[smallest,idx] = min(numPixels);
firstFrame(CC.PixelIdxList{idx}) = 0;

blob=firstFrame;
end