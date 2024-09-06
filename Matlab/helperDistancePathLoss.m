function [signalOut, PLd] = helperDistancePathLoss(signalIn, PL0, d, n, sigma)
%HELPERDISTANCEPATHLOSS Apply distance-dependent path loss
%   [OUT, PLd] = helperDistancePathLoss(IN, PL0, D, N, SIGMA) applies path
%   loss PLd to input signal IN as a result of the distance D between the
%   two link endpoints. PL0 is the path loss at a reference distance d0
%   (1m). N is the path loss exponent and sigma is the standard deviation
%   of shadowing. Shadowing is realized differently with each function
%   call.
%
%   See also uwbChannel, uwbChannelConfig.

%   Copyright 2022 The MathWorks, Inc.

d0 = 1;                                           % reference distance in meters 
S = randn * sigma;                                % shadowing, large-scale fading
PLd = PL0 + 10*n*log10(d/d0) + S;                 % distance-caused path-loss, specified in dB
signalOut = signalIn * 10^(-PLd/20);              % apply path loss (in dB) to linear scale

end

