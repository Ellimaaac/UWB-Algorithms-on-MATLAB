function [signalOut, pathGains] = helperApplyChannel(signalIn, clusterArrivalTimes, ...
  pathArrivalTimes, pathAveragePowers, pathPhases, nakagamiM, Fs, sampleDensity, maxDopplerShift)
%HELPERAPPLYCHANNEL Function-based simulation loop for UWB Nakagami fading
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

L = numel(clusterArrivalTimes);

absoluteArrivalTimes = pathArrivalTimes;

for idx=1:L
  % convert relative (within cluster) path arrival times to absolute time instances
  absoluteArrivalTimes{idx} = absoluteArrivalTimes{idx} + clusterArrivalTimes(idx);
end

% Create the channel filter, with pathDelays set to the absolute path arrival times:
chanObj = comm.ChannelFilter(SampleRate=Fs, PathDelays=cell2mat(absoluteArrivalTimes)/1e9); % convert path delays to seconds

% rate of new channel realizations:
Fcg = maxDopplerShift * 2 * sampleDensity;
numRealizations = length(signalIn)*Fcg/Fs;
frameLen = floor(length(signalIn)/numRealizations);
signalOut = zeros(length(signalIn), 1);

pathGains = {};
for idx = 1:numRealizations  
  currentGains = helperUWBFadingRealization(pathAveragePowers, nakagamiM);
  currentGains = cellfun(@(a, phi) a.*exp(1i*phi), currentGains, pathPhases, 'UniformOutput', false);  % Eq. (15)
  pathGains = [pathGains; currentGains]; %#ok<AGROW> 

  thisRange = (1+(idx-1)*frameLen):min(idx*frameLen, length(signalIn));
  signalOut(thisRange) = chanObj(signalIn(thisRange), cell2mat(currentGains)); % flatten gain hierarchy to 1 x NumPaths
end

% Return pathPhases to use in main script

end
