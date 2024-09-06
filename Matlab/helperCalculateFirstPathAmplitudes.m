% Algorithm based on the software (Segger)
% First 3 biggest paths (conributions)
function [ip_f1, ip_f2, ip_f3, ip_f1_idx, ip_f2_idx, ip_f3_idx] = helperCalculateFirstPathAmplitudes(CIR_real, CIR_imag, directPathIdx)
    % Calculer et ajuster les valeurs de la première trajectoire (First Path Amplitude)
    if directPathIdx + 2 <= length(CIR_real)
        ip_f1_idx = directPathIdx;
        ip_f2_idx = directPathIdx + 1;
        ip_f3_idx = directPathIdx + 2;
        ip_f1 = sqrt(CIR_real(ip_f1_idx)^2 + CIR_imag(ip_f1_idx)^2) / 4;
        ip_f2 = sqrt(CIR_real(ip_f2_idx)^2 + CIR_imag(ip_f2_idx)^2) / 4;
        ip_f3 = sqrt(CIR_real(ip_f3_idx)^2 + CIR_imag(ip_f3_idx)^2) / 4;
    else
        ip_f1 = NaN;
        ip_f2 = NaN;
        ip_f3 = NaN;
        ip_f1_idx = NaN;
        ip_f2_idx = NaN;
        ip_f3_idx = NaN;
        disp('Direct Path index is too close to the end of the CIR data.');
    end
end
