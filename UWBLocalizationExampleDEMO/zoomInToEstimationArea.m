function zoomInToEstimationArea(nodeLoc, xC, yC, xO, yO)
    % Transform matrices to column vectors
    xC = xC(:);
    yC = yC(:);
    xO = xO(:);
    yO = yO(:);

    % Concatenation of the coordinates X and Y
    allX = [nodeLoc(:, 1); xC; xO];
    allY = [nodeLoc(:, 2); yC; yO];
    margin = 10;  % Margin to add around the outermost points

    % Set plot limits
    xlim([min(allX) - margin, max(allX) + margin]);
    ylim([min(allY) - margin, max(allY) + margin]);

    % Adjust plot properties for a better view
    grid on;
end