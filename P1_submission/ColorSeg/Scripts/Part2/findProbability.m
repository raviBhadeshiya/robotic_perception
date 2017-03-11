function [X,Y,Z] = findProbability(x,y,z,GMM_X,GMM_Y,GMM_Z)
X=0;
Y=0;
Z=0;
for i=1:3
    mu_x=GMM_X.mu(i,:)';
    sigma_x=GMM_X.Sigma(:,:,i)';
    p_x=exp(-0.5*((double(x)-mu_x)'/sigma_x)*(double(x)-mu_x))/(((2*pi)^3/2)*sqrt(det(sigma_x)));
    X =X +GMM_X.ComponentProportion(i)*p_x;
    
    mu_y=GMM_Y.mu(i,:)';
    sigma_y=GMM_Y.Sigma(:,:,i)';
    p_y=exp(-0.5*((double(y)-mu_y)'/sigma_y)*(double(y)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
    Y =Y +GMM_Y.ComponentProportion(i)*p_y;
    
    mu_z=GMM_Z.mu(i,:)';
    sigma_z=GMM_Z.Sigma(:,:,i)';
    p_z=exp(-0.5*((double(z)-mu_z)'/sigma_z)*(double(z)-mu_z))/(((2*pi)^3/2)*sqrt(det(sigma_z)));
    Z =Z +GMM_Z.ComponentProportion(i)*p_z;
    
end
end