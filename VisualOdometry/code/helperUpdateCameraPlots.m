% helperUpdateCameraPlots update the camera plots for VisualOdometryExample

% Copyright 2016 The MathWorks, Inc. 
function helperUpdateCameraPlots(viewId, camEstimated, ...
    posesEstimated)

% Move the estimated camera in the plot.
camEstimated.Location = posesEstimated.Location{viewId};
camEstimated.Orientation = posesEstimated.Orientation{viewId};
% Move the actual camera in the plot.
% camActual.Location = posesActual.Location{viewId};
% camActual.Orientation = posesEstimated.Orientation{viewId};
