function [mu,sigma]=estimate(Samples)
mu=mean(Samples)';
sigma=var(double(Samples))';
end
