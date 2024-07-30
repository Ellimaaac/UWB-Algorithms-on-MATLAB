function nakagamiM = helperNakagamiParameters(env, pathArrivalTimes)
%HELPERNAKAGAMIPARAMETERS Find Nakagami parameter m for each path
%   NAKAGAMI_M = helperNakagamiParameters(env, PATHARRIVALS) determines the
%   Nakagami parameter NAKAGAMI_M for each path, given the uwbChannelConfig
%   environment parameterization ENV and the arrival time of each path
%   PATHARRIVALS. PATHARRIVALS and NAKAGAMI_M are 1xL cell arrays, where L
%   is the number of clusters. Each cell element is a 1xK vector, where K
%   is the number of paths within the corresponding cluster.
%
%   References:
%   [1] - A. F. Molisch et al., "IEEE 802.15.4a Channel Model-Final
%   Report," Tech. Rep., Document IEEE 802.1504-0062-02-004a, 2005
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

% Number of clusters, determined by the length of the cell array pathArrivalTimes
L = numel(pathArrivalTimes); 

% Initialize the cell array to store Nakagami m parameters for each cluster
nakagamiM = cell(1, L);

% Loop over each cluster
for clusterIdx = 1:L
  % Number of paths in the current cluster
  K_L = numel(pathArrivalTimes{clusterIdx});
  
  % Initialize a zero array for Nakagami m parameters for paths in this cluster
  nakagamiM{clusterIdx} = zeros(1, K_L);
  
  % Loop over each path in the current cluster
  for pathIdx = 1:K_L
    % Special case for the first path in an industrial environment with line of sight (LOS)
    if pathIdx == 1 && env.HasLOS && strcmp(env.Type, 'Industrial')
      % The first component is modeled differently, independent of path delay (Eq. 29 in [1])
      nakagamiM{clusterIdx}(pathIdx) = env.FirstPathNakagami;
    else
      % Calculate the mean of the log-normal distribution for the Nakagami m parameter (Eq. 27 in [1])
      mu_m = env.NakagamiMeanOffset - env.NakagamiMeanSlope * pathArrivalTimes{clusterIdx}(pathIdx);
      
      % Calculate the standard deviation of the log-normal distribution for the Nakagami m parameter (Eq. 28 in [1])
      sigma_m = env.NakagamiDeviationOffset - env.NakagamiDeviationSlope * pathArrivalTimes{clusterIdx}(pathIdx);
      
      % Generate the Nakagami m parameter as a log-normal random variable
      nakagamiM{clusterIdx}(pathIdx) = exp(mu_m + randn * sigma_m);
    end
  end
  
end
