function superposePathGains = helperSelectAndValidatePathGains(pathGainsCell, numDevices, numNodes)
    % Prompt the user to select the devices and nodes for superposition
    selectedDevice1 = input('Enter the first device index for superposition: ');
    selectedNode1 = input('Enter the first node index for superposition: ');
    selectedDevice2 = input('Enter the second device index for superposition: ');
    selectedNode2 = input('Enter the second node index for superposition: ');

    % Check if the selected indices are valid
    if selectedDevice1 > numDevices || selectedNode1 > numNodes || selectedDevice2 > numDevices || selectedNode2 > numNodes
        error('Invalid device or node index selected. Please check the input data.');
    end

    % Store path gains for superposition based on user selection
    superposePathGains = cell(1, 2);
    superposePathGains{1} = pathGainsCell{selectedDevice1, selectedNode1};
    superposePathGains{2} = pathGainsCell{selectedDevice2, selectedNode2};

    % Debugging: Display the content of superposePathGains before returning
    disp('Contents of superposePathGains:');
    disp(superposePathGains);

    % Check if the selected path gains are not empty
    if isempty(superposePathGains{1}) || isempty(superposePathGains{2})
        error('Not enough data for superposition. Please check the input data.');
    end
end
