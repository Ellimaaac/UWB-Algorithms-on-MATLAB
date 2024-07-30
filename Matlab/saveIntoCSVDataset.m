%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTSlab - Sapienza Universita di Roma
% Author: 2024 Camille LANFREDI 

% Dexcription :
% This MATLAB function, saveIntoCSVDataset, takes in summed path gains 
% data for multiple devices and nodes, line-of-sight (LOS) information, 
% and an optional existing dataset. It processes the data to create a cell 
% array with path gains and additional information (device and node info, 
% LOS status), then writes this data into a CSV file. The function ensures 
% that the data is properly formatted for CSV output, handling different 
% data types and ensuring compatibility. Helper functions are included 
% to assist with logical conditions and data type conversions.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function saveIntoCSVDataset(summedPathGains, numDevices, numNodes, LOS, outputFileName, existingData)
    % Determine the maximum length of the path gains arrays
    maxLength = max(cellfun(@(x) length(x), summedPathGains(:)));

    % Create a cell array to store the path gains with additional info
    pathGainsData = cell(maxLength + 2, numDevices * numNodes); % +2 for the additional info rows

    % Fill the cell array with path gains and additional info
    colIndex = 1;
    for deviceIdx = 1:numDevices
        for node = 1:numNodes
            % Add device and node info
            pathGainsData{1, colIndex} = sprintf('Device %d, Node %d', deviceIdx, node);
            pathGainsData{2, colIndex} = sprintf('LOS %d', LOS(deviceIdx, node));

            % Add path gains
            if isnumeric(summedPathGains{deviceIdx, node})
                % Directly process numeric data
                pathGainsData(3:2+length(summedPathGains{deviceIdx, node}), colIndex) = num2cell(abs(summedPathGains{deviceIdx, node}));
            elseif iscell(summedPathGains{deviceIdx, node})
                % Process data inside cell arrays
                cellData = summedPathGains{deviceIdx, node};
                if all(cellfun(@isnumeric, cellData))
                    combinedData = cell2mat(cellData);
                    pathGainsData(3:2+length(combinedData), colIndex) = num2cell(abs(combinedData));
                end
            end
            colIndex = colIndex + 1;
        end
    end

    % If there is existing data, append the new data below it
    if ~isempty(existingData)
        % Find the last non-empty row in the existing data
        lastRow = find(~cellfun('isempty', existingData(:,1)), 1, 'last');
        % Append the new data
        pathGainsData = [existingData(1:lastRow, :); pathGainsData];
    end

    % Replace empty cells with empty strings
    pathGainsData = cellfun(@(x) convertToSupportedType(x), pathGainsData, 'UniformOutput', false);

    % Write the cell array to a CSV file
    writecell(pathGainsData, outputFileName);
end

% Helper function to handle if-else logic in array operations
function out = ifelse(cond, trueVal, falseVal)
    if cond
        out = trueVal;
    else
        out = falseVal;
    end
end

% Helper function to convert to supported types
function out = convertToSupportedType(x)
    if isempty(x)
        out = '';
    elseif ismissing(x)
        out = '';
    elseif isnumeric(x) || islogical(x)
        out = num2str(x);
    elseif ischar(x)
        out = x;
    else
        out = '';
    end
end
