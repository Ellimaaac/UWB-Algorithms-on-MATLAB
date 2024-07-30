%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTSlab - Sapienza Universita di Roma
% Author: 2024 Camille LANFREDI

% Description:
% This script reads a CSV file containing UWB dataset information, extracts
% columns that start with "CIR" while excluding specific columns, and saves
% the extracted data into a text file in a specified format.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Open the CSV file in read mode
fileID = fopen('uwb_dataset_part3.csv', 'r');

% Read the first line to get the column names
headerLine = fgetl(fileID);
headers = strsplit(headerLine, ';');

% Find the columns that start with "CIR" and exclude specific columns
exclude_columns = {'CIR_PWR', 'CIR0', 'CIR1', 'CIR2', 'CIR3', 'CIR4'};
cir_columns = headers(startsWith(headers, 'CIR') & ~ismember(headers, exclude_columns));

% Display the CIR columns for verification
disp(cir_columns);

% Read the rest of the data
formatSpec = repmat('%f', 1, length(headers));
dataArray = textscan(fileID, formatSpec, 'Delimiter', ';', 'HeaderLines', 1);

% Close the file
fclose(fileID);

% Convert the data into a matrix
data = [dataArray{:}];

% Extract the remaining "CIR" columns
cir_data_indices = find(startsWith(headers, 'CIR') & ~ismember(headers, exclude_columns));
cir_data = data(:, cir_data_indices);

% Open a text file to write the data
fileID = fopen('extracted_cirs_part3.txt', 'w');

% Loop over each row of data
for i = 1:size(cir_data, 1)
    % Extract the values of row i
    values = cir_data(i, :);
    % Create the string for row i
    line = sprintf('CIR%d = [%s]\n', i, strjoin(string(values), ', '));
    % Write the string to the text file
    fprintf(fileID, line);
end

% Close the file
fclose(fileID);

disp('Extraction and saving of CIR data completed.');
