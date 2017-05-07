function [matchedPoints1,matchedPoints2] = matchPoint( undistortedImg,pImage)
       point1=detectFASTFeatures(undistortedImg);
       [f1,vpts1] = extractFeatures((undistortedImg),point1);
       
       point2=detectFASTFeatures(pImage);
       [f2,vpts2] = extractFeatures(pImage,point2);
       
       indexPairs = matchFeatures(f1,f2) ;
       
       matchedPoints1 = vpts1(indexPairs(:,1));
       matchedPoints2 = vpts2(indexPairs(:,2));
end

