function total = findProbability(x,GMM)
total =0;
for i=1:GMM.NumComponents
    mu=GMM.mu(i,:)';
    sigma=GMM.Sigma(:,:,i)';
    p=exp(-0.5*((double(x)-mu)'/sigma)*(double(x)-mu))/(((2*pi)^3/2)*sqrt(det(sigma)));
    total =total +GMM.ComponentProportion(i)*p;
end
end