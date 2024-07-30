function arrayPlot = helperVisualizeChannelGains(clusterArrivalTimes, pathArrivalTimes, pathGains)
%HELPERVISUALIZECHANNELGAINS Visualize UWB channel realization
%   helperVisualizeChannelGains(CLUSTERARRIVALTIMES, PATHARRIVALTIMES,
%   PATHGAINS) creates a stem plot that illustrates the UWB channel gains
%   with a different color for each cluster. CLUSTERARRIVALTIMES and
%   PATHARRIVALTIMES contain the cluster arrival times, and the (relative)
%   path arrival times, respectively. PATHGAINS contains the path gains for
%   all paths of all clusters. CLUSTERARRIVALTIMES is a 1xL vector, where L
%   is the number of clusters. PATHARRIVALTIMES and PATHGAINS are 1xL cell
%   arrays; each cell element is a 1xK vector, where K is the number of
%   paths within the corresponding cluster.


%   Copyright 2022 The MathWorks, Inc.

L = numel(clusterArrivalTimes);

absoluteArrivalTimes = pathArrivalTimes;

arrayPlot = dsp.ArrayPlot(XDataMode='Custom', ShowLegend=true, YLimits=[0 max(max(abs(cell2mat(pathGains))))]);

legendStr = {};
for idx=1:L
  % convert relative (within cluster) path arrival times to absolute time instances
  absoluteArrivalTimes{idx} = absoluteArrivalTimes{idx} + clusterArrivalTimes(idx);
  legendStr = [legendStr ['Cluster#' num2str(idx)]]; %#ok<AGROW>
end
arrayPlot.ChannelNames = legendStr;

% Clusterized array plot, use multiple channels for different colors.
% Need a common, custom, increasing X vector. Y values for other channels need to be NaN

[customXData, tapOrder] = sort(cell2mat(absoluteArrivalTimes));
arrayPlot.CustomXData = [-eps customXData]; % make sure x=0 is included

% Initialiser le compteur d'échantillons
totalSamples = 0;

for realization=1:size(pathGains, 1)
  offset = 0;
  allGains = cell2mat(pathGains(realization, :));
  allGains = allGains(tapOrder); % sort in increasing time
  allChannels = nan(1+numel(allGains), L);  % +1 for -eps

  for clusterIdx = 1:L
    numClusterGains = numel(pathGains{realization, clusterIdx});

    range = offset+1:offset+numClusterGains;
    allChannels(1+tapOrder(range), clusterIdx) = pathGains{realization, clusterIdx};   
    
    offset = offset + numClusterGains;
    totalSamples = totalSamples + numClusterGains;
  end
  arrayPlot(abs(allChannels));
  
end

    arrayPlot.XLabel = 'Time (ns)';
    arrayPlot.YLabel = 'Magnitude of Nakagami path gains';

    % Afficher le nombre total d'échantillons
    fprintf('Total samples in helperVisualizeChannelGains: %d\n', totalSamples);
end