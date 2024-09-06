%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTSlab - Sapienza Universita di Roma
% Author: 2024 Camille LANFREDI

% Description : 
%  This MATLAB function readCIRValuesFromMeasurements reads Channel 
% Impulse Response (CIR) data from a specified file, processes it, 
% and extracts the real and imaginary parts of the CIR values. The 
% function handles the file line by line, identifies lines containing 
% CIR_real_values and CIR_imag_values, and extracts these values into 
% cell arrays. It ensures that each pair of real and imaginary values
% has compatible sizes. The function also includes a commented-out 
% section for optionally setting up the same environment of the board 
% for the theoretical CIR by extracting the initiator address from the file.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CIR_real_all, CIR_imag_all] = readCIRValuesFromMeasurements(file_path)
    % Open the file and check for errors
    fid = fopen(file_path, 'r');
    if fid == -1
        error(['Error opening the file: ', file_path]);
    end
    
    CIR_real_all = {}; % Initialize as an empty cell array
    CIR_imag_all = {};
    
    % Read the file line by line
    while ~feof(fid)
        line = fgetl(fid);
        
        % Process the information in the file
        if contains(line, 'CIR_real_values')
            real_start = strfind(line, 'CIR_real_values = [') + length('CIR_real_values = [');
            real_end = strfind(line, ']') - 1;
            if ~isempty(real_start) && ~isempty(real_end)
                cirRealValues = sscanf(line(real_start:real_end), '%f');
                if ~isempty(cirRealValues)
                    CIR_real_all{end+1} = cirRealValues'; % Store the real values as a row
                end
            end
        elseif contains(line, 'CIR_imag_values')
            imag_start = strfind(line, 'CIR_imag_values = [') + length('CIR_imag_values = [');
            imag_end = strfind(line, ']') - 1;
            if ~isempty(imag_start) && ~isempty(imag_end)
                cirImagValues = sscanf(line(imag_start:imag_end), '%f');
                if ~isempty(cirImagValues)
                    CIR_imag_all{end+1} = cirImagValues'; % Store the imaginary values as a row
                end
            end
        end
    end
    
    % Ensure each pair has compatible sizes
    minLength = min(length(CIR_real_all), length(CIR_imag_all));
    CIR_real_all = CIR_real_all(1:minLength);
    CIR_imag_all = CIR_imag_all(1:minLength);
    
    fclose(fid);

    % if you want to set up the same environment of your board for the theoretical CIR
    % put the variable initiator at the SourceAddress in the MAC layer

    % % Initialize the variable for the initiator address
    % initiatorAddr = '';
    % 
    % % Read and extract data
    % while ~feof(fid)
    %     line = fgetl(fid);
    %     % Extract the initiator address
    %     match = regexp(line, '"Initiator Addr":"(0x[0-9A-Fa-f]{4})"', 'tokens');
    %     if ~isempty(match)
    %         initiatorAddr = match{1}{1};  % Address extracted
    %         break;  % Exit the loop after finding the address
    %     end
    % end
    % 
    % % close file
    % fclose(fid);
    % 
    % % Optionally, display the extracted address
    % % disp(['Initiator Address: ', initiatorAddr]); % 0x0000 means that it works perfectly
    % % Check if the address exists
    % if isempty(initiatorAddr)
    %     error('Initiator address not found in the file.');
    % end
    % 
    % % Delete '0x' and format the address if necessary
    % initiatorAddr = strrep(initiatorAddr, '0x', '');
    % if length(initiatorAddr) ~= 4
    %     error('Initiator address format is incorrect.');
    % end
end
