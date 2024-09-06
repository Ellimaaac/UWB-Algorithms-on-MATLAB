function [pathArrivalTimes, pathAveragePowers, pathPhases] = helperPathModeling(env, clusterArrivalTimes, clusterEnergies, T_end, Fs)
%HELPERPATHMODELING Setup path arrival times and average powers
%   [ARRIVALS, AVGPOWERS, PHASES] = helperPathModeling(ENV, CLUSTERARRIVALS,
%   CLUSTERENERGIES, END_THR, FS) determines the arrival time and average
%   power of each path, given an uwbChannelConfig environment description
%   ENV, the cluster arrival times CLUSTERARRIVALS, the cluster energies
%   CLUSTERENERGIES, the threshold ratio of the last path power to the
%   first path power END_THR and the sample rate of the channel Fs.
%   CLUSTERARRIVALS and CLUSTERENERGIES are 1xL vectors, where L is the
%   number of clusters. ARRIVALS, AVGPOWERS and PHASES are 1xL cell arrays; each
%   cell element is a 1xK vector, where K is the number of paths within the
%   corresponding cluster.
% 
%   References:
%   [1] - A. F. Molisch et al., "IEEE 802.15.4a Channel Model-Final
%   Report," Tech. Rep., Document IEEE 802.1504-0062-02-004a, 2005
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

L = numel(clusterArrivalTimes);

continuousPDP = strcmp(env.Type, 'Industrial') || (~env.HasLOS && strcmp(env.Type, 'Indoor office')); 
singleAlternatePDP = ~env.HasLOS && any(strcmp(env.Type, {'Indoor office', 'Industrial'}));

for cluster = 1:L 
  pathArrivalTimes{cluster} = []; %#ok<*AGROW> 
  pathAveragePowers{cluster} = [];

  while true
    % Find arrival time of next path:
    % Asymptotic equivalence with Eq (18) in [1]:
    if ~continuousPDP
      u = rand();                             %  uniform random variable in [0, 1]
      if u < env.MixtureProbability
        lambda = env.PathArrivalRate1;
      else
        lambda = env.PathArrivalRate2;
      end
      u2 = rand();                            %  uniform random variable in [0, 1]
      if isempty(pathArrivalTimes{cluster})
        % 1st path, by definition delay is 0
        thisInterArrival = 0;
      else
        thisInterArrival = log(u2)*(-1/lambda); % Exponential interarrival time (in ns), Inverse Transform Method
      end
      if ~isempty(pathArrivalTimes{cluster})
        thisPathDelay = sum([pathArrivalTimes{cluster}(end) thisInterArrival]);
      else
        thisPathDelay = thisInterArrival;
      end

    else % continuousPDP, NLOS Indoor office / Industrial
      % continuous multi-path -> regular tap spacings 
      stepSize = 1e9; % one second. Considering every sample time is computationally challenging
      thisPathDelay = stepSize * numel(pathArrivalTimes{cluster})/Fs;
    end

    % Find average power of next path:
    if ~singleAlternatePDP
      % Eq. (20) in [1]
      gamma = env.PathDecaySlope * clusterArrivalTimes(cluster) + env.PathDecayOffset; % intra-cluster power decay factor
      % Eq. (19) in [1]
      denominator = gamma * ( (1-env.MixtureProbability)*env.PathArrivalRate1 + env.MixtureProbability*env.PathArrivalRate2 + 1 );
      thisAveragePower = clusterEnergies(cluster) * exp(-thisPathDelay/gamma) / denominator;
    else
      % Eq. (22) in [1]
      thisAveragePower = clusterEnergies(cluster) * (1 -env.FirstPathAttenuation*exp(-thisPathDelay/env.PDPIncreaseFactor) ) * ...
        (exp(-thisPathDelay/env.PDPDecayFactor)) * ((env.PDPDecayFactor + env.PDPIncreaseFactor)/env.PDPDecayFactor) / (env.PDPDecayFactor + env.PDPIncreaseFactor*(1-env.FirstPathAttenuation));
    end
    
    if ~isempty(pathAveragePowers{cluster}) && thisAveragePower < T_end*max(pathAveragePowers{cluster})
      % cluster lost 95% of initial (or max for alternate PDP) power, declare end
      break;
    else
      pathArrivalTimes{cluster}  = [pathArrivalTimes{cluster} thisPathDelay];      % in ns
      pathAveragePowers{cluster} = [pathAveragePowers{cluster} thisAveragePower];
    end
  end

  % apply uniformly distributed (in [0, 2*pi]) phase -> complex baseband 
  K_L = numel(pathArrivalTimes{cluster});
  pathPhases{cluster} = 2*pi*rand(1, K_L);
end
end

