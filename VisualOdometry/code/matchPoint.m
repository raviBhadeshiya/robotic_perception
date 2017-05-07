function [matchedPoints1,matchedPoints2] = matchPoint( undistortedImg,pImage)
       point1= detectSURFFeatures(undistortedImg, 'MetricThreshold', 500);
%        point1 = selectUniform(point1, 200, size(undistortedImg));
       [f1,vpts1] = extractFeatures((undistortedImg),point1);
       
       point2 = detectSURFFeatures(pImage, 'MetricThreshold', 500);
       %        point2 = selectUniform(point2, 200, size(pImage));
       [f2,vpts2] = extractFeatures(pImage,point2);
       
       indexPairs = matchFeatures(f1,f2) ;
       
       matchedPoints1 = vpts1(indexPairs(:,1));
       matchedPoints2 = vpts2(indexPairs(:,2));
end

