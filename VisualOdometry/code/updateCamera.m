function updateCamera(viewId,trajectoryEstimated,camEstimated,posesEstimated)
camEstimated.Location = posesEstimated.Location{viewId};
camEstimated.Orientation = posesEstimated.Orientation{viewId};
locations = cat(1, posesEstimated.Location{:});
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));
end