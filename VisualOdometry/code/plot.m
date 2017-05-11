figure
axis([-20, 1000, -140, 30, 0, 2000]);

% Set Y-axis to be vertical pointing down.
view(gca, 3);
set(gca, 'CameraUpVector', [0, -1, 0]);
camorbit(gca, -120, 0, 'data', [0, 1, 0]);
locations = cat(1, estimatedView.Views.Location{:});
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on;
% Plot estimated camera pose.
trajectoryEstimated = plot3(0, 0, 0, 'g-');
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    locations(:,2), 'ZData', locations(:,3));