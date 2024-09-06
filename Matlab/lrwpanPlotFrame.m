function FIG = lrwpanPlotFrame(wave, cfg)
%LRWPANPLOTFRAME Visualize HRP UWB IEEE 802.15.4a/z waveform
%  FIG = LRWPANPLOTFRAME(WAVE, CFG) visualizes the HRP UWB IEEE 802.15.4a/z
%  waveform WAVE, which is described by the <a
% href="matlab:help('lrwpanHRPConfig')">lrwpanHRPConfig</a> configuration
%  object CFG. WAVE is plotted in figure FIG; each field of the waveform is
%  plotted with a different color.

%   Copyright 2021 The MathWorks, Inc.

FIG = figure;
hold on; 

colors = colorcube(64);
% choose some professionally looking colors:
colorSYNC     = colors(44, :);
colorSFD      = colors(50, :);
colorPHR      = colors(8, :);
colorPayload  = colors(53, :);
colorSTS      = colors(46, :);

if strcmp(cfg.Mode, '802.15.4a')
  title('15.4a frame')
elseif strcmp(cfg.Mode, 'BPRF')
  title('15.4a/z BPRF frame')
else % MeanPRF > 62.4, HPRF
  title('15.4z HPRF frame')
end
  
ind = lrwpanHRPFieldIndices(cfg);
  
plot(ind.SYNC(1):ind.SYNC(end), wave(ind.SYNC(1):ind.SYNC(end)), 'Color', colorSYNC)
plot(ind.SFD(1):ind.SFD(end), wave(ind.SFD(1):ind.SFD(end)), 'Color', colorSFD)

if ~isempty(ind.STS) && cfg.STSPacketConfiguration ==1
  plot(ind.STS(1):ind.STS(end), wave(ind.STS(1):ind.STS(end)), 'Color', colorSTS)
end

if ~isempty(ind.PHR)
  plot(ind.PHR(1):ind.PHR(end), wave(ind.PHR(1):ind.PHR(end)), 'Color', colorPHR)
end
if ~isempty(ind.Payload)
  plot(ind.Payload(1):ind.Payload(end), wave(ind.Payload(1):ind.Payload(end)), 'Color', colorPayload)
end

if ~isempty(ind.STS) && cfg.STSPacketConfiguration >=2
  plot(ind.STS(1):ind.STS(end), wave(ind.STS(1):ind.STS(end)), 'Color', colorSTS)
end

if cfg.STSPacketConfiguration == 0 || strcmp(cfg.Mode, '802.15.4a')
    legend('SYNC', 'SFD', 'PHR', 'Payload');
elseif cfg.STSPacketConfiguration == 1
    legend('SYNC', 'SFD', 'STS', 'PHR', 'Payload');
elseif cfg.STSPacketConfiguration == 2
  legend('SYNC', 'SFD', 'PHR', 'Payload', 'STS');
else % STSPacketConfiguration=3
    legend('SYNC', 'SFD', 'STS');
end
hold off;