%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                                                                                                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Author : 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function generateAndSaveCIRValues(numDevices, numNodes, deviceLoc, nodeLoc, environmentType, channelSpec, LOS, iterations)
    % Initialise the output file
    outputFileName = 'pathGains_all_devices_nodes_amplitude.csv';
    
    % If the file exists, read its content
    if isfile(outputFileName)
        existingData = readcell(outputFileName);
    else
        existingData = {};
    end

    for iter = 1:iterations
        fprintf('Iteration %d\n', iter);
        
        % Generate theoretical CIR values for each device-node pair
        summedPathGains = cell(numDevices, numNodes);
        for deviceIdx = 1:numDevices
            for node = 1:numNodes
                envConfig = uwbChannelConfig(environmentType, LOS(deviceIdx, node));

                % Configure the UWB channel
                UWBChannel = uwbChannel(environmentType, LOS(deviceIdx, node), ...
                    'TransmitPower', 1, ...
                    'Distance', actualDistances(node, deviceIdx), ...
                    'ChannelNumber', channelNum, ...
                    'LastPathThreshold', 0.05, ...
                    'SampleRate', blinkPHYConfig.SampleRate, ...
                    'SampleDensity', 1e5, ...
                    'MaxDopplerShift', 5, ...
                    'ChannelFiltering', false);

                % Obtain the channel realization (path gains)
                pathGains = UWBChannel();

                % Get the channel information
                s = info(UWBChannel);

                % Save CIR values into a struct
                CIR_values(deviceIdx, node).pathGains = pathGains;
                CIR_values(deviceIdx, node).info = s;

                % Store the path gains in the cell
                pathGainsCell{deviceIdx, node} = pathGains;

                % Sum the absolute values of the path gains across all clusters
                summedPathGains{deviceIdx, node} = sum(abs(cell2mat(pathGains(:))), 2);

                % Visualize the channel gains
                helperVisualizeChannelGains(s.ClusterArrivalTimes, s.PathArrivalTimes, pathGains);

                % Visualize the combined path gains
                figure;
                stem(abs(summedPathGains{deviceIdx, node}));
                title(sprintf('Theoretical Signal (Device %d, Node %d)', deviceIdx, node));
                xlabel('Samples');
                ylabel('Amplitude');
            end
        end
        
        % Save the new data into the CSV file
        saveIntoCSVDataset(summedPathGains, numDevices, numNodes, LOS, outputFileName, existingData);
    end
end

