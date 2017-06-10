function E = FtoEmatrix(F,K)
E=K'*F*K;
[u d v]=svd(E);
i=eye(3);
i(3,3)=0;
E=u*i*v';
% E=E/norm(E);
end