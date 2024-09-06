function displayBlinkFromConfigLayers(delayedBlink, filteredBlink, regionStart, regionEnd, sampleRate, node, deviceIdx)
    % Plot the CIR and Frequency Domain Magnitude

    % Plot delayed signal
    figure;
    subplot(4,1,1);
    plot(delayedBlink);
    title(sprintf('Delayed Signal at Node %d for Device %d', node, deviceIdx));
    xlabel('Sample Number');
    ylabel('Amplitude');

    % Plot real, imaginary parts, and magnitude of the filtered CIR
    subplot(4,1,2);
    plot(real(filteredBlink(regionStart:regionEnd)));
    title(sprintf('Channel Impulse Response (Real Part) at Node %d for Device %d', node, deviceIdx));
    xlabel('Sample Number');
    ylabel('Amplitude');

    subplot(4,1,3);
    plot(imag(filteredBlink(regionStart:regionEnd)));
    title(sprintf('Channel Impulse Response (Imaginary Part) at Node %d for Device %d', node, deviceIdx));
    xlabel('Sample Number');
    ylabel('Amplitude');

    subplot(4,1,4);
    plot(abs(filteredBlink(regionStart:regionEnd)));
    title(sprintf('Channel Impulse Response (Magnitude) at Node %d for Device %d', node, deviceIdx));
    xlabel('Sample Number');
    ylabel('Magnitude');


    figure;
    hold on;
    freqMagnitude = abs(fftshift(fft(delayedBlink)));
    freqAxis = linspace(-0.5, 0.5, length(freqMagnitude)) * sampleRate;
    plot(freqAxis, freqMagnitude);
    title(sprintf('Frequency Domain Magnitude at Node %d for Device %d', node, deviceIdx));
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    hold off;

    % Frequency domain analysis
    figure;
    hold on;
    freqMagnitude = abs(fftshift(fft(filteredBlink)));
    freqAxis = linspace(-0.5, 0.5, length(freqMagnitude)) * sampleRate;
    plot(freqAxis, freqMagnitude);
    title(sprintf('Frequency Domain Magnitude at Node %d for Device %d', node, deviceIdx));
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    hold off;

    
end