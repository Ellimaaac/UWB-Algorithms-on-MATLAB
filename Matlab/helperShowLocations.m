function helperShowLocations(deviceLoc, nodeLoc)
%HELPERSHOWLOCATIONS Visualize device and node positions in a 2D plane

f = figure;
ax = gca(f);

% Device
plot(ax, deviceLoc(:,1), deviceLoc(:,2), 'mp');
for j = 1:size(deviceLoc, 1)
    text(ax, deviceLoc(j, 1) + 1.5, deviceLoc(j, 2) - 1, num2str(j)); % Labels like 1, 2, ...
end

hold(ax, 'on')

% Nodes
plot(ax, nodeLoc(:, 1), nodeLoc(:, 2), 'kd');
for i = 1:size(nodeLoc, 1)
    text(ax, nodeLoc(i, 1) + 1.5, nodeLoc(i, 2) - 1, char(64+i)); % Labels like A, B, C...
end


axis(ax, [0 100 0 100])
legend('Device', 'Synchronized Nodes', 'Location', 'NorthWest')
end