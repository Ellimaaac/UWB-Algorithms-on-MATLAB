function firstOccurrence = helperFindFirstHRPPreamble(signal, preamble, cfg)
%HELPERFINDFIRSTHRPPREAMBLE Find index of 1st HRP preamble (out of Nsync)

% Copyright 2021 The MathWorks, Inc.

persistent preamDet
if isempty(preamDet)
  % Find multiple preambles (Nsync total)
  maxCorr = max(abs(filter( flipud(preamble) , 1, signal)));
  thr = 0.7*maxCorr; % make sure all peaks are found
  preamDet = comm.PreambleDetector(Preamble=preamble, Threshold=thr);
else
  reset(preamDet);
end

[preamPos, corrMat] = preamDet(signal); 

% Now find 1st peak:
preambleRepetDist = cfg.PreambleCodeLength*cfg.PreambleSpreadingFactor;
% only focus on first preamble repetition:
preamPos = preamPos(preamPos<preamPos(1)+preambleRepetDist/2);
[~, maxIdx] = max(corrMat(preamPos));
firstOccurrence = preamPos(maxIdx);

end

