function helperShowLocations(deviceLoc, nodeLoc)
%HELPERSHOWLOCATIONS Visualize device and node positions in a 2D plane

%   Copyright 2021 The MathWorks, Inc. 

f = figure;
ax = gca(f);

% Device
plot(ax, deviceLoc(:,1), deviceLoc(:,2), 'mp');
% text(ax, deviceLoc(1, 1)+1.5, deviceLoc(1, 2)-1, '1');
% text(ax, deviceLoc(2, 1)+1.5, deviceLoc(2, 2)-1, '2');

for j = 1:size(deviceLoc, 1)
    text(ax, deviceLoc(j, 1) + 1.5, deviceLoc(j, 2) - 1, num2str(j)); % Labels like 1, 2, ...
end


hold(ax, 'on')

% Nodes
plot(ax, nodeLoc(:, 1), nodeLoc(:, 2), 'kd');
% text(ax, nodeLoc(1, 1)+1.5, nodeLoc(1, 2)-1, 'A');
% text(ax, nodeLoc(2, 1)+1.5, nodeLoc(2, 2)-1, 'B');
% text(ax, nodeLoc(3, 1)+1.5, nodeLoc(3, 2)-1, 'C');
% text(ax, nodeLoc(4, 1)+1.5, nodeLoc(4, 2)-1, 'D');
% text(ax, nodeLoc(5, 1)+1.5, nodeLoc(5, 2)-1, 'E');
% text(ax, nodeLoc(6, 1)+1.5, nodeLoc(6, 2)-1, 'F');

for i = 1:size(nodeLoc, 1)
    text(ax, nodeLoc(i, 1) + 1.5, nodeLoc(i, 2) - 1, char(64+i)); % Labels like A, B, C...
end


axis(ax, [0 100 0 100])

legend('Device', 'Synchronized Nodes', 'Location', 'NorthWest')
