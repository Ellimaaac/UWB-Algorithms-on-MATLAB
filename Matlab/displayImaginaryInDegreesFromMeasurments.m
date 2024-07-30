%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: 2024 Camille LANFREDI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function displayImaginaryInDegreesFromMeasurements(file_path, CIRNumber)
    % Read the files and extract data
    [CIR_real_all, CIR_imag_all] = readCIRValuesFromMeasurements(file_path);
    disp(['Total number of read CIR pairs for ', file_path, ': ', num2str(length(CIR_real_all))]);

    % Display the data for the specified CIR number
    CIR_real = CIR_real_all{CIRNumber}(730:end)';
    CIR_imag = CIR_imag_all{CIRNumber}(730:end)';

    % Convert the imaginary values to phase in degrees
    CIR_phase_degrees = rad2deg(atan2(CIR_imag, CIR_real));

    % Plot the imaginary values in degrees versus samples
    figure;
    stem(730:length(CIR_imag)+729, CIR_phase_degrees);
    xlabel('Samples');
    ylabel('Imaginary Part (Degrees)');
    title(['Imaginary Part in Degrees vs Samples for CIR Number ', num2str(CIRNumber)]);
    grid on;
end
