%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displayCIRFromMeasurements(file_paths, LOS)
% Read the files and extract data
all_CIR_real_all = {};
all_CIR_imag_all = {};

for i = 1:length(file_paths)
    file_path = file_paths{i};
    [CIR_real_all, CIR_imag_all] = readCIRValuesFromMeasurements(file_path);
    all_CIR_real_all{i} = CIR_real_all;
    all_CIR_imag_all{i} = CIR_imag_all;
    disp(['Total number of read CIR pairs for ', file_path, ': ', num2str(length(CIR_real_all))]);
end

while true
    % Prompt the user to select the CIR number to display
    prompt = 'Enter the CIR number you want to display (1-1087) or 0 to exit: ';
    CIRNumber = input(prompt);

    if CIRNumber == 0 % To quit, press 0
        break;
    end

    if CIRNumber > length(all_CIR_real_all{1})
        disp('The number entered exceeds the available CIR pairs. Please enter a valid number.');
        continue;
    end

    for i = 1:length(file_paths)
        file_path = file_paths{i};
        CIR_real_all = all_CIR_real_all{i};
        CIR_imag_all = all_CIR_imag_all{i};

        if CIRNumber > 0 && CIRNumber <= length(CIR_real_all))
            disp('=================================================================');
            disp(['CIR number ', num2str(CIRNumber), ' for ', file_path]);

            % Calculate the magnitude of the CIR
            CIR_real = CIR_real_all{CIRNumber};
            CIR_imag = CIR_imag_all{CIRNumber};
            CIR_magnitude = sqrt(CIR_real.^2 + CIR_imag.^2);

            % Normalize the magnitude of the CIR
            CIR_magnitude_normalized = normalizeData(CIR_magnitude);

            % Display the magnitude of the CIR
            figure;
            plot(CIR_magnitude);
            title(['CIR Magnitude - ', file_path]);
            xlabel('Samples');
            ylabel('Magnitude');
            grid on;

            % Use the defined LOS/NLOS configuration
            condition = LOS(i);

            % Detect the First Path based on the condition
            if condition == 1
                directPathIdx = helperFindFirstPathLOS(CIR_magnitude);
            elseif condition == 0
                directPathIdx = helperFindFirstPathNLOS(CIR_magnitude);
            else
                disp('Invalid condition.');
                continue;
            end

            % Calculate and adjust the first path amplitudes
            [ip_f1, ip_f2, ip_f3, ip_f1_idx, ip_f2_idx, ip_f3_idx] = helperCalculateFirstPathAmplitudes(CIR_real, CIR_imag, directPathIdx);

            % Display the adjusted first path amplitudes and their indices
            disp(['First Path Amplitudes: ', num2str(ip_f1), ', ', num2str(ip_f2), ', ', num2str(ip_f3)]);
            disp(['Indexes of First Path Amplitudes: ', num2str(ip_f1_idx), ', ', num2str(ip_f2_idx), ', ', num2str(ip_f3_idx)]);

            % Annotate the First Path on the graph
            hold on;
            plot(directPathIdx, CIR_magnitude(directPathIdx), 'ro', 'MarkerSize', 10, 'DisplayName', 'Direct Path');
            legend('show');
            hold off;

            % Calculate the distance
            c = 3e8; % Speed of light (m/s)
            timePerSample = 1e-9; % Time per sample (in seconds)

            % Adjust the direct path index by subtracting the noise window
            noiseWindow = 726; % Noise window size
            adjustedDirectPathIdx = directPathIdx - noiseWindow;
            adjustedDirectPathIdx = max(adjustedDirectPathIdx, 0); % Ensure the index is non-negative

            % Calculate the time of flight
            timeDistance = adjustedDirectPathIdx * timePerSample;
            distance = timeDistance * c;

            % Display the result
            disp(['Estimated distance: ', num2str(distance), ' meters']);

            % Calculate the signal level differences
            [sl_diff_ip, noiseLevel, magnitudeAtDirectPath] = helperCalculateSignalLevelDifference(CIR_magnitude, directPathIdx, noiseWindow);

            % Display the debugging values
            disp(['Signal Level Difference (sl_diff_ip): ', num2str(sl_diff_ip)]);
            disp(['Noise Level: ', num2str(noiseLevel)]);
            disp(['Magnitude at Direct Path: ', num2str(magnitudeAtDirectPath)]);

            % Calculate the RSL and FSL signal levels
            ip_cp = sum(CIR_magnitude.^2); % Total signal power
            ip_n = length(CIR_magnitude); % Number of samples
            ip_alpha = 0; % Attenuation constant, to be defined as per context
            log_constant = 0; % Logarithmic correction constant, to be defined as per context
            D = 0; % Distance constant, to be defined as per context

            ip_rsl = 10 * log10((ip_cp / ip_n)) + ip_alpha + log_constant + D;
            ip_fsl = 10 * log10(((ip_f1 + ip_f2 + ip_f3) / ip_n)) + ip_alpha + D;

            % Calculate the signal level difference
            sl_diff_ip_calculated = ip_rsl - ip_fsl;
            disp(['Calculated Signal Level Difference (sl_diff_ip_calculated): ', num2str(sl_diff_ip_calculated)]);

        else
            disp(['Invalid CIR number for ', file_path]);
        end

        % Display the magnitude of the CIR
        figure;
        plot(CIR_magnitude_normalized(730:end));
        title(['CIR Magnitude - ', file_path]);
        xlabel('Samples');
        ylabel('Magnitude');
        grid on;

        % Visualize
        figure;
        scatter(CIR_real(730:end), CIR_imag(730:end));
        xlabel('Real Part (I)');
        ylabel('Imaginary Part (Q)');
        title('Phase Response of Multipath Components');
        axis([-1500 1500 -1000 1000]); % Set the x and y axis limits
        grid on;

        % Highlight top 4 samples
        hold on;
        [~, sortedIdx] = sort(CIR_magnitude_normalized, 'descend');
        top4Idx = sortedIdx(1:4);
        scatter(CIR_real(top4Idx), CIR_imag(top4Idx), 'd', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'DisplayName', 'Top 4 Samples');
        legend;

        % Add the signal envelope
        % Select a larger set of points based on the magnitude of the CIR
        selectedIdx = sortedIdx(1:min(100, length(sortedIdx)));  % Select the top 100 magnitudes or fewer if not enough points
        selectedReal = CIR_real(selectedIdx);
        selectedImag = CIR_imag(selectedIdx);

        % Ensure selectedReal and selectedImag are column vectors
        if isrow(selectedReal)
            selectedReal = selectedReal';
        end
        if isrow(selectedImag)
            selectedImag = selectedImag';
        end

        % Use boundary to calculate the envelope
        k = boundary(selectedReal, selectedImag, 0.5); % Adjust the shrink factor for a tighter or looser envelope

        % Convert the imaginary values to phase in degrees
        CIR_phase = rad2deg(atan2(CIR_imag, CIR_real));

        % Normalize the magnitudes before converting to dB
        maxMagnitude = max(CIR_magnitude(selectedIdx));
        magnitudes_dB = 20 * log10(CIR_magnitude(selectedIdx) / maxMagnitude);

        % Display the envelope on the polar plot
        figure;
        polarplot(deg2rad(CIR_phase(selectedIdx)), magnitudes_dB, 'bo');
        hold on;
        polarplot(deg2rad(CIR_phase(selectedIdx(k))), magnitudes_dB(k), 'r-', 'LineWidth', 2);

        % Set radial axis limits and ticks in dB
        rlim([-20 0]); % Radial axis limits
        rticks([-20 -15 -10 -5 0]); % Tick spacing
        title(['Envelope of CIR - ', file_path]);
        legend('Selected Points', 'Envelope');
        hold off;

        % Display the polar plot for antenna gain
        figure;
        % Recalculate magnitudes for the polar plot
        CIR_complex = CIR_real(730:end) + 1i * CIR_imag(730:end);
        CIR_freq_response = fft(CIR_complex);

        % Calculate gain in dB
        gain_dB = 20 * log10(abs(CIR_complex));
        
        % Normalize the gain dB data to align with the first figure
        gain_dB = gain_dB - max(gain_dB) + max(magnitudes_dB); 
        gain_dB(gain_dB < -20) = -20; % Limit values to -20 dB to avoid very low values
        
        angles = linspace(0, 2*pi, length(CIR_imag(730:end)));

        % Smooth the gain dB values
        gain_dB_smooth = smooth(gain_dB, 0.1, 'rloess');

        % Plot the butterfly shape (lobes)
        polarplot(angles, gain_dB_smooth, 'b', 'LineWidth', 2);
        hold on;

        % Add concentric circles to represent gain levels
        max_gain = ceil(max(gain_dB_smooth)/5)*5; % Round up to the nearest 5
        min_gain = -20; 
        gain_levels = min_gain:5:max_gain; % Adjust the number of levels as needed

        for g = gain_levels
            polarplot(angles, g * ones(size(angles)), 'k--', 'LineWidth', 0.5); % Concentric circles
        end

        % Set radial axis limits and ticks in dB
        rlim([min_gain max_gain]); % Radial axis limits
        rticks(gain_levels); % Tick spacing
        title('Antenna Gain (dBi) vs. Angle (°)');
        legend('Gain (Smoothed)', 'Gain Levels');

        hold off;

        % Call the function to plot imaginary values in degrees
        displayImaginaryInDegreesFromMeasurements(file_path, CIRNumber);

    end
    disp('=================================================================');
end
end

% Function to normalize data
function normalizedData = normalizeData(data)
normalizedData = data / sum(data);
disp(['normalizedData', num2str(normalizedData)]);
end
