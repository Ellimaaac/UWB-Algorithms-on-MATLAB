function [L, clusterArrivals, clusterEnergies] = helperClusterization(type, LOS, Lbar, Lambda, sigma_cluster, Gamma)
%HELPERCLUSTERIZATION Setup cluster characteristics
%   [L, CLUSTERARRIVALS, CLUSTERENERGIES] = helperClusterization(TYPE, LOS,
%   LBAR, LAMBDA, SIGMA_CLUSTER, GAMMA) determines cluster characteristics
%   such as the number of clusters L, the arrival time (ns) of each cluster
%   (contained in vector CLUSTERARRIVALS), and the energy of each cluster
%   (contained in vector CLUSTERENERGIES). CLUSTERARRIVALS and
%   CLUSTERENERGIES are 1xL vectors, where L is the number of clusters.
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

%% Number of clusters:
singleAlternatePDP = ~LOS && any(strcmp(type, {'Indoor office', 'Industrial'}));
if ~singleAlternatePDP
  L = max(1, helperPoissonRV(Lbar));
else
  L = 1; % single PDP shape
end

%% Cluster arrival times:
if ~singleAlternatePDP
  interarrivals = log(rand(1, L))*(-1/Lambda);    % in ns
  clusterArrivals = cumsum(interarrivals);                    % in ns
else
  clusterArrivals = 0; % single-cluster case
end 

%% Cluster energies:
if strcmp(type, 'Residential') || (LOS && strcmp(type, 'Industrial'))
  Mcluster = randn * sigma_cluster;             % cluster shadowing
  Mcluster = 10^(Mcluster/10);                  % convert dB to linear scale
else
  Mcluster = 1; % no-op
end

if ~singleAlternatePDP
  clusterEnergies = exp(-clusterArrivals/Gamma)*Mcluster;
else
  clusterEnergies = 1;
end


end

