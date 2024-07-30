%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ACTSlab - Sapienza Universita di Roma
% Author: 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function directPathIdx = helperFindFirstPathNLOS(CIR_magnitude)
    % Identify peaks in the CIR magnitude data
    [pks, locs] = findpeaks(CIR_magnitude);
    % Find the index of the highest peak
    highestPeakIndex = locs(find(pks == max(pks), 1));
    
    % Define the initial noise window size for noise estimation
    noiseWindow = 726;
    % Calculate the noise variance within the initial window
    noiseVariance = var(CIR_magnitude(1:noiseWindow));
    % Define the threshold factor to detect significant variance increase
    thresholdFactor = 1.5;
    
    % Calculate the variance threshold
    threshold = noiseVariance * thresholdFactor;
    % Initialize the direct path index with the highest peak index
    directPathIdx = highestPeakIndex;
    
    % Display the highest peak and noise variance for debugging
    disp(['Highest sample: ', num2str(highestPeakIndex)]);
    disp(['Noise variance: ', num2str(noiseVariance)]);
    
    % Adjust based on variance
    for idx = (noiseWindow + 1):length(CIR_magnitude)
        % Check if the variance exceeds the threshold
        if var(CIR_magnitude((idx - noiseWindow):idx)) > threshold
            directPathIdx = idx;
            break;
        end
    end
    
    % Display the identified direct path index for debugging
    disp(['Direct path: ', num2str(directPathIdx)]);
end
