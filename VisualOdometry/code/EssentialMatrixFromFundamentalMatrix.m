function E = EssentialMatrixFromFundamentalMatrix(F,K)
% EssentialMatrixFromFundamentalMatrix
% Use the camera calibration matrix to esimate the Essential matrix
% Inputs:
%     K - size (3 x 3) camera calibration (intrinsics) matrix for both
%     cameras
%     F - size (3 x 3) fundamental matrix from EstimateFundamentalMatrix
% Outputs:
%     E - size (3 x 3) Essential matrix with singular values (1,1,0)
E=K'*F*K;
[u d v]=svd(E);
i=eye(3);
i(3,3)=0;
E=u*i*v';
E=E/norm(E);
end