function displaySuperposeCIRFromTheoreticalModel(pathGains1, pathGains2)
    % Combine all gains for visualization
    allGains1 = [];
    allGains2 = [];
    
    for clusterIdx = 1:length(pathGains1)
        allGains1 = [allGains1; pathGains1{clusterIdx}(:)];
    end
    
    for clusterIdx = 1:length(pathGains2)
        allGains2 = [allGains2; pathGains2{clusterIdx}(:)];
    end

    % Calculate magnitudes for both path gains
    CIR_magnitude1 = abs(allGains1);
    CIR_magnitude2 = abs(allGains2);

    % Plot data for the first set of path gains
    figure;
    hold on;
    scatter(real(allGains1), imag(allGains1), 'o', 'DisplayName', 'Set 1');

    % Highlight top 4 samples for the first set
    [~, sortedIdx1] = sort(CIR_magnitude1, 'descend');
    numTopSamples1 = min(4, length(sortedIdx1));
    topIdx1 = sortedIdx1(1:numTopSamples1);
    scatter(real(allGains1(topIdx1)), imag(allGains1(topIdx1)), 'd', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'DisplayName', 'Top Samples - File  1');

    % Plot data for the second set of path gains
    scatter(real(allGains2), imag(allGains2), 'x', 'DisplayName', ' Set 2');

    % Highlight top 4 samples for the second set
    [~, sortedIdx2] = sort(CIR_magnitude2, 'descend');
    numTopSamples2 = min(4, length(sortedIdx2));
    topIdx2 = sortedIdx2(1:numTopSamples2);
    scatter(real(allGains2(topIdx2)), imag(allGains2(topIdx2)), 's', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'black', 'DisplayName', 'Top Samples - File 2');

    % Configure plot
    xlabel('Real Part (I)');
    ylabel('Imaginary Part (Q)');
    title('Phase Response of Multipath Components');
    axis([-0.5 0.5 -0.5 0.5]);
    grid on;
    legend('show');
    hold off;
end
