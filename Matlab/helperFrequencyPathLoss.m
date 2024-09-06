function [signalOut, PLf] = helperFrequencyPathLoss(signalIn, Fc, bw, kappa)
%HELPERFREQUENCYPATHLOSS Apply frequency-dependent path loss
%   [OUT, PLf] = helperFrequencyPathLoss(IN, FC, BW, KAPPA) applies path
%   loss PLf to input signal IN as a result of the center frequency FC and
%   the signal bandwidth BW. KAPPA is the environment-specific exponent of
%   frequency. Frequency-dependent path loss is applied as per the
%   frequency-related terms of Eq. (12) in the UWB channel model [1].
%
%   [1] - A. F. Molisch et al., "IEEE 802.15.4a Channel Model-Final
%   Report," Tech. Rep., Document IEEE 802.1504-0062-02-004a, 2005
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

freq = (-bw/2:bw/2000:bw/2);                  % filter for baseband signal
ampl = 1./((freq+Fc)/Fc).^(2*kappa +2);       % amplitudes as per passband equation

% filter creation and visualization:
if Fc ~= 499.2e6  % channel 0 (default)
  filterOrder = 50;
  dLP = fdesign.arbmag(filterOrder, freq/(bw/2), ampl);
  filterFIR = design(dLP , 'firls', 'systemobject', true);

else % Channel 0, default
  % hardcode output from above commands for the default channel, to speedup execution
  load('defaultNumerator', 'numerator');
  filterFIR = dsp.FIRFilter(numerator);
end
% This command can visualize the filter response:
% fvtool(filterFIR);

signalOut = filterFIR(signalIn);                         % apply per-frequency amplitudes
PLf = 20*log10(signalIn./signalOut);

end

