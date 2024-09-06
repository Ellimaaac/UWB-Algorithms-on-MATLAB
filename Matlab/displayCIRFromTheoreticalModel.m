function displayCIRFromTheoreticalModel(pathGains, clusterArrivalTimes, pathArrivalTimes)
    % Définir les couleurs des clusters
    clusterColors = {'#FDEE00', '#0000FF', '#FFA500', '#008000', '#800080', '#00FFFF', '#FFC0CB', '#FF0000', '#A52A2A', '#7FFF00', '#DC143C', '#FFD700', '#4B0082', '#00FF7F', '#4682B4', '#D2691E', '#00BFFF', '#FF69B4'};

    % Vérifier que le nombre de clusters ne dépasse pas le nombre de couleurs définies
    numClusters = length(pathGains);
    if numClusters > length(clusterColors)
        error('Le nombre de clusters dépasse le nombre de couleurs définies.');
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % Combine the path gains into a single matrix while ensuring all matrices have the same dimension
    maxLength = max(cellfun(@(x) length(x), pathGains(:)));
    pathGainsCombined = [];

    for clusterIdx = 1:numClusters
        pathGainComponent = pathGains{clusterIdx}(:);
        paddedPathGainComponent = [pathGainComponent; nan(maxLength - length(pathGainComponent), 1)]; % Utiliser NaN pour le remplissage
        pathGainsCombined = [pathGainsCombined; paddedPathGainComponent];
    end

    % Visualize the phases of the combined path gains
    figure;
    hold on;

    % Initialize the sample counter
    totalSamples = 0;

    % Plot the phases of the path gains for each cluster
    for clusterIdx = 1:numClusters
        absoluteArrivalTimes = pathArrivalTimes{clusterIdx} + clusterArrivalTimes(clusterIdx);
        phases = rad2deg(angle(pathGains{clusterIdx}));
        scatter(absoluteArrivalTimes, phases, 'filled', 'MarkerFaceColor', clusterColors{clusterIdx});
        totalSamples = totalSamples + length(absoluteArrivalTimes);
    end

    xlabel('Time (ns)');
    ylabel('Phase (Degrees)');
    title('Phase of Path Gains for Each Cluster');
    legend(arrayfun(@(idx) ['Cluster#' num2str(idx)], 1:numClusters, 'UniformOutput', false));
    grid on;
    hold off;

    % Display the total number of samples
    fprintf('Total samples in displayCIRFromTheoreticalModel: %d\n', totalSamples);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialize arrays to combine the path gains
    allGains = [];
    allClusters = [];

    % Process each cluster
    for clusterIdx = 1:numClusters
        if isempty(pathGains{clusterIdx})
            continue; % Skip empty clusters
        end
        allGains = [allGains; pathGains{clusterIdx}(:)];
        allClusters = [allClusters; repmat(clusterIdx, length(pathGains{clusterIdx}), 1)];
    end

    % Identify the top four samples
    [~, indices] = sort(abs(allGains), 'descend');
    topIndices = indices(1:min(4, length(indices))); % Assurer qu'il y a au moins 4 échantillons

    % Plot the phase response of multipath components
    figure;
    hold on;
    for clusterIdx = 1:numClusters
        if isempty(pathGains{clusterIdx})
            continue; % Ignorer les clusters vides
        end
        scatter(real(pathGains{clusterIdx}), imag(pathGains{clusterIdx}), 'filled', 'MarkerFaceColor', clusterColors{clusterIdx});
    end
    scatter(real(allGains(topIndices)), imag(allGains(topIndices)), 'd', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none', 'SizeData', 100);
    xlabel('Partie Réelle (I)');
    ylabel('Partie Imaginaire (Q)');
    title('Réponse en Phase des Composants Multipath');
    axis([-0.5 0.5 -0.5 0.5]);
    grid on;
    hold off;

    % Add legend
    legendEntries = arrayfun(@(idx) ['Cluster#' num2str(idx)], 1:numClusters, 'UniformOutput', false);
    legendEntries{end+1} = 'Top 4 Samples';
    legend(legendEntries);

    % Prepare the data for combined plotting
    maxLength = max(cellfun(@(x) length(x), pathGains(:)));
    pathGainsCombined = nan(maxLength, numClusters);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Tracer l'enveloppe du CIR
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % selectedIdx = indices(1:min(100, length(indices)));
    % selectedReal = real(allGains(selectedIdx));
    % selectedImag = imag(allGains(selectedIdx));
    % k = boundary(selectedReal, selectedImag, 0.5);
    % allCIR_phases = rad2deg(atan2(selectedImag, selectedReal));
    % 
    % figure;
    % polarplot(deg2rad(allCIR_phases), abs(allGains(selectedIdx)), 'bo');
    % hold on;
    % polarplot(deg2rad(allCIR_phases(k)), abs(allGains(selectedIdx(k))), 'r-', 'LineWidth', 2);
    % title('Enveloppe du CIR');
    % legend('Points Sélectionnés', 'Enveloppe');
    % hold off;

% % Tracer l'enveloppe du CIR
%     allGains = cell2mat(pathGains);
%     [~, indices] = sort(abs(allGains), 'descend');
%     selectedIdx = indices(1:min(100, length(indices)));
%     selectedReal = real(allGains(selectedIdx));
%     selectedImag = imag(allGains(selectedIdx));
% 
%     % Convertir en colonnes
%     selectedReal = selectedReal(:);
%     selectedImag = selectedImag(:);
% 
%     k = boundary(selectedReal, selectedImag, 0.5);
%     allCIR_phases = rad2deg(atan2(selectedImag, selectedReal));
% 
%     % Normaliser les magnitudes avant de les convertir en dB
%     maxMagnitude = max(abs(allGains(selectedIdx)));
%     magnitudes_dB = 20 * log10(abs(allGains(selectedIdx)));
% 
%     figure;
%     polarplot(deg2rad(allCIR_phases), magnitudes_dB, 'bo');
%     hold on;
%     polarplot(deg2rad(allCIR_phases(k)), magnitudes_dB(k), 'r-', 'LineWidth', 2);
%     title('Enveloppe du CIR');
%     legend('Points Sélectionnés', 'Enveloppe');
%     hold off;



allGains = cell2mat(pathGains);
    [~, indices] = sort(abs(allGains), 'descend');
    selectedIdx = indices(1:min(100, length(indices)));
    selectedReal = real(allGains(selectedIdx));
    selectedImag = imag(allGains(selectedIdx));
    
    % Les données doivent être en format colonne pour boundary
    selectedReal = selectedReal(:);
    selectedImag = selectedImag(:);

    % k = boundary(selectedReal, selectedImag, 0.5);
    % allCIR_phases = rad2deg(atan2(selectedImag, selectedReal));
    % 
    % % Normaliser les magnitudes avant de les convertir en dB
    % maxMagnitude = max(abs(allGains(selectedIdx)));
    % magnitudes_dB = 20 * log10(abs(allGains(selectedIdx)) / maxMagnitude);
    % 
    % figure;
    % polarplot(deg2rad(allCIR_phases), magnitudes_dB, 'bo');
    % hold on;
    % polarplot(deg2rad(allCIR_phases(k)), magnitudes_dB(k), 'r-', 'LineWidth', 2);
    % 
    % % Définir les limites et l'espacement de l'axe radial en dB
    % rlim([-20 0]); % Limites de l'axe radial
    % rticks([-20 -15 -10 -5 0]); % Espacement des ticks
    % title('Enveloppe du CIR (en dB)');
    % legend('Points Sélectionnés', 'Enveloppe');
    % hold off;
end