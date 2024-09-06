%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displaySuperposeCIRFromMeasurements(filepaths)
    if length(filepaths) ~= 2
        error('Please provide exactly two file paths.');
    end

    % Read the files and extract data
    all_CIR_real_all = {};
    all_CIR_imag_all = {};

    for i = 1:length(filepaths)
        file_path = filepaths{i};
        [CIR_real_all, CIR_imag_all] = readCIRValuesFromMeasurements(file_path);
        all_CIR_real_all{i} = CIR_real_all;
        all_CIR_imag_all{i} = CIR_imag_all;
        disp(['Total number of read CIR pairs for ', file_path, ': ', num2str(length(CIR_real_all))]);
    end

    % Prompt the user to select the CIRs to superpose
    CIRNumbers = zeros(1, length(filepaths));
    for i = 1:length(filepaths)
        CIRNumbers(i) = input(['Enter the CIR number from file ', num2str(i), ' to display: ']);
    end

    % Plot the results on the same graph
    figure;
    hold on;
    colors = {'o', 'x', 's', 'd', '^', 'v', '>', '<', 'p', 'h'}; % Assign different marker shapes for different files
    labels = {};
    for i = 1:length(filepaths)
        CIR_real = all_CIR_real_all{i}{CIRNumbers(i)}(730:end)';
        CIR_imag = all_CIR_imag_all{i}{CIRNumbers(i)}(730:end)';
        CIR_magnitude = sqrt(CIR_real.^2 + CIR_imag.^2);

        % Plot data
        scatter(CIR_real, CIR_imag, colors{mod(i-1, length(colors))+1});
        labels = [labels, {['CIR ', num2str(CIRNumbers(i)), ' - ', filepaths{i}]}]; %#ok<AGROW>
        
        % Highlight top samples
        [~, sortedIdx] = sort(CIR_magnitude, 'descend');
        numTopSamples = min(4, length(sortedIdx));
        topIdx = sortedIdx(1:numTopSamples);

        % Use different colors for top samples from different files
        if i == 1
            scatter(CIR_real(topIdx), CIR_imag(topIdx), 'd', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'DisplayName', ['Top Samples - File ', num2str(i)]);
        else
            scatter(CIR_real(topIdx), CIR_imag(topIdx), 's', 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'black', 'DisplayName', ['Top Samples - File ', num2str(i)]);
        end

        % Add top samples to the legend
        labels = [labels, {['Top Samples - File ', num2str(i)]}]; %#ok<AGROW>
    end
    
    xlabel('Real Part (I)');
    ylabel('Imaginary Part (Q)');
    title('Phase Response of Multipath Components');
    axis([-1500 1500 -1000 1000]);
    grid on;
    legend(labels);
    hold off;
end
