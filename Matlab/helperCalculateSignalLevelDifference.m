function [sl_diff, noiseLevel, magnitudeAtDirectPath] = helperCalculateSignalLevelDifference(CIR_magnitude, directPathIdx, noiseWindow)
    % Fonction pour calculer la différence de niveau du signal
    % Utiliser une fenêtre de bruit plus petite pour réduire l'effet des valeurs de bruit élevées
    noiseLevel = mean(CIR_magnitude(1:noiseWindow));
    magnitudeAtDirectPath = CIR_magnitude(directPathIdx);
    sl_diff = 10 * log10(magnitudeAtDirectPath / noiseLevel); % Utilisation de l'échelle logarithmique (dB)
end