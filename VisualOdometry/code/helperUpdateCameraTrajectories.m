% helperUpdateCameraTrajectories update camera trajectories for VisualOdometryExample

% Copyright 2016 The MathWorks, Inc. 
function helperUpdateCameraTrajectories(viewId, trajectoryEstimated, posesEstimated)

% Plot the estimated trajectory.
locations = cat(1, posesEstimated.Location{:});
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));
end

% Plot the ground truth trajectory
% locationsActual = cat(1, posesActual.Location{1:viewId});
% set(trajectoryActual, 'XData', locationsActual(:,1), 'YData', ...
%     locationsActual(:,2), 'ZData', locationsActual(:,3));