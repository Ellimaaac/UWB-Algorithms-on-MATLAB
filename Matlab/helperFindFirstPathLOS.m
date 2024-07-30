%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTSlab - Sapienza Universita di Roma
% Author: 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function directPathIdx = helperFindFirstPathLOS(CIR_magnitude)
    % Detection of the direct path using the variance method for LOS
    
    % Define the initial noise window size for noise estimation
    noiseWindow = 726;
    
    % Calculate the noise variance within the initial window
    noiseVariance = var(CIR_magnitude(1:noiseWindow));
    
    % Define the threshold factor to detect significant variance increase
    % As indicated in Segger code >
    % dw3000_statistics.c > L188
    thresholdFactor = 3.98;
    
    % Calculate the variance threshold
    threshold = noiseVariance * thresholdFactor;
    
    % Identify peaks in the CIR magnitude data
    [pks, locs] = findpeaks(CIR_magnitude);
    
    % Find the index of the highest peak
    highestPeakIndex = locs(find(pks == max(pks), 1));
    
    % Display the highest peak and noise variance for debugging
    disp(['Highest sample: ', num2str(highestPeakIndex)]);
    disp(['Noise variance: ', num2str(noiseVariance)]);
    
    % Traverse samples after the noise window to detect the increase in variance
    directPathIdx = noiseWindow;
    for idx = (noiseWindow + 1):length(CIR_magnitude)
        % Check if the variance exceeds the threshold
        if var(CIR_magnitude((idx-noiseWindow):idx)) > threshold
            directPathIdx = idx;
            break;
        end
    end
    
    % Display the identified direct path index for debugging
    disp(['Direct path: ', num2str(directPathIdx)]);
end
