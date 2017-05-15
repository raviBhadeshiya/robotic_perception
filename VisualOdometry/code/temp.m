load memory.mat
figure
% view(gca, 3);
view([0 0]);
% set(gca, 'CameraUpVector', [0, -1, 0]);
set(gca,'Xdir','reverse');
set(gca,'Zdir','reverse');
locations = cat(1, estimatedView.Views.Location{:});
grid on;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on;
% Plot estimated camera pose.
trajectoryEstimated = plot3(0,0,0, 'g-');
set(trajectoryEstimated, 'XData', locations(:,1), 'YData', ...
    zeros(size(locations,1),1), 'ZData', locations(:,3));