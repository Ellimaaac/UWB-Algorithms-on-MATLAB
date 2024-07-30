function pathGains = helperUWBFadingRealization(pathAveragePowers, nakagamiM)
%HELPERUWBFADINGREALIZATION Get new UWB channel realization
%   PATHGAINS = HELPERUWBFADINGREALIZATION(PATHAVERAGEPOWERS, NAKAGAMI_M)
%   returns the current gain for each path, given its average power in
%   PATHAVERAGEPOWERS and its Nakagami M parameter in NAKAGAMI_M. PATHGAINS,
%   PATHAVERAGEPOWERS and NAKAGAMI_M are all 1xL cell arrays, where L is
%   the number of clusters. Each cell element is a 1xK vector, where K is
%   the number of paths within the corresponding cluster.
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

L = numel(pathAveragePowers);                   % number of clusters

pathGains = cell(1, L);
for clusterIdx = 1:L                            % for each cluster
  K_L = numel(pathAveragePowers{clusterIdx});   % number of paths per cluster
  pathGains{clusterIdx} = zeros(1, K_L);
  for pathIdx = 1:K_L
    thisM = nakagamiM{clusterIdx}(pathIdx);
    newGamma = helperGammaRV(thisM, pathAveragePowers{clusterIdx}(pathIdx)/thisM);
    pathGains{clusterIdx}(pathIdx) = sqrt(newGamma); % Gamma -> Nakagami
  end
end