function GMModels = estimatPerameters(Samples,numberOfcomponent)

options = statset('MaxIter',500);
GMModels= fitgmdist(Samples,numberOfcomponent,'Options',options,'CovarianceType','full');

end