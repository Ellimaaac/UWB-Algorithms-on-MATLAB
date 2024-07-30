function hZoomTo1stHPRFPayloadSymbol(fig, cfg)
% This is an internal example helper that may change any time.

%   Copyright 2021 The MathWorks, Inc.

ind = lrwpanHRPFieldIndices(cfg);
start = ind.Payload(1) + cfg.SamplesPerPulse/2;  % also account for group delay

ax = get(fig,'CurrentAxes');

pulsesPerQuarterSym = 1;
numQuarters = 4;
numChips = numQuarters*pulsesPerQuarterSym;
symDur = numChips*cfg.SamplesPerPulse;
set(ax, 'XLim', start + [0 symDur])
legend(ax, 'hide')
title(ax, 'Single Payload HPRF Symbol, 249.6 MHz Mean PRF');


hold(ax, 'on')
for idx = 1:numChips
  x =  start+idx*symDur/numChips;
  y = get(ax, 'YLim');
  if mod(idx, 4)==0
    plotStr = 'k-';
  else
    plotStr = 'k:';
  end
  plot(ax, [x x], y, plotStr)
end
hold(ax, 'off')