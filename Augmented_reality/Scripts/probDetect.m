function bool = probDetect(matrix,likelyhood)
border=-2.083;
noch=33.32;
side=8.33;

prob=[border,border,border,border,border,border,border,border;
    border,border,border,border,border,border,border,border;
    border,border,-side,side,side,-side,border,border;
    border,border,side,   0  ,  0   ,side,border,border;
    border,border,side,   0  ,  0   ,side,border,border;
    border,border,-side,side,side,noch,border,border;
    border,border,border,border,border,border,border,border;
    border,border,border,border,border,border,border,border;];
    
detection=sum(sum(prob.*matrix));
if detection > likelyhood
    bool=true;
else
    bool=false;
end

end
