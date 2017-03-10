clear all;
close all;
clc;
% tic
colorDistribution

for i=1:180
    title(i);
    detectBuoy3d(i,1);
    pause(1/60);
end
%red =30
% AIC = zeros(1,30);
% GMModels = cell(1,20);
% options = statset('MaxIter',500);
% parfor k = 1:30
%     GMModels{k} = fitgmdist(SamplesY,k,'Options',options,'CovarianceType','diagonal');
%     AIC(k)= GMModels{k}.AIC;
% end
% [minAIC,numComponents] = min(AIC);
% numComponents
% BestModel = GMModels{numComponents};
% toc