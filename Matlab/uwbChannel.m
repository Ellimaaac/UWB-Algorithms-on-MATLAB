classdef uwbChannel < matlab.System
%UWBCHANNEL Filter input signal through a UWB IEEE 802.15.4a/z channel
%   CHAN = uwbChannel(Type, LOS) creates a UWB multipath fading channel
%   System object, CHAN. Type is one of 5 possible environment types, while
%   LOS is a boolean indicating presence of a line-of-sight component. This
%   object filters a real or complex input signal through the UWB multipath
%   channel to obtain the channel impaired signal.
%
%   CHAN = uwbChannel(Type, LOS, Name,Value) creates a multipath
%   UWB fading channel object, CHAN, with the specified property Name set
%   to the specified Value. You can specify additional name-value pair
%   arguments in any order as (Name1,Value1,...,NameN,ValueN).
%  
%   Step method syntax:
% 
%   Y = step(CHAN,X) filters input signal X through a multipath Nakagami
%   fading channel and returns the result in Y. This syntax applies when
%   you set the ChannelFiltering property to true. Both the input X and
%   the output Y are of size Ns-by-1, where Ns is the number of samples. X
%   can be real-valued or complex-valued. Y is complex-valued and of the
%   same data type as X.
% 
%   [Y,PATHGAINS] = step(CHAN,X) returns the channel path gains of the
%   underlying Nakagami fading process in PATHGAINS. PATHGAINS is a cell
%   array of size N-by-L, where N is the number of channel realizations (as
%   determined by MaxDopplerShift and SampleDensity), and L is the number
%   of clusters. Each cell item is a 1-by-K vector, containing the path
%   gains for all K paths of that cluster.
%     
%   PATHGAINS = step(CHAN) returns the channel path gains of the underlying
%   Nakagami fading process in PATHGAINS. This syntax applies when you set
%   the ChannelFiltering property to false. In this case, the channel
%   requires no input signals and acts as a source of path gains.
%
%   System objects may be called directly like a function instead of using
%   the step method. For example, y = step(obj, x) and y = obj(x) are
%   equivalent.
%
%   Type              - Environment type ('Residential', 'Indoor office', 'Outdoor', 'Open outdoor', 'Industrial')
%   HasLOS            - Boolean indicating presence of line-of-sight component
%   ChannelNumber     - UWB channel number (0, 1, 2, ... 15)
%   TransmitPower     - Transmit power, in Watts
%   Distance          - Distance between transmitter and receiver in meters
%   MaxDopplerShift   - Maximum Doppler shift (Hz)
%   LastPathThreshold - Minimum power of last path, relative to first path
%   SampleRate        - Input signal sample rate (Hz)
%   SampleDensity     - Number of time samples per half wavelength 
%   ChannelFiltering  - Perform channel filtering (logical)
%
%   Example:
% 
%   psdu = randi([0, 1], 1016, 1);
%   waveTx = lrwpanWaveformGenerator(psdu, lrwpanHRPConfig);
% 
%   outdoorUWBChannel = uwbChannel('Outdoor', false);
%   [waveRx, pathGains] = outdoorUWBChannel(waveTx);

%   Copyright 2022 The MathWorks, Inc.

  properties
    %Type Environment type
    % Specify Type as one of 'Residential' | 'Indoor office' | 'Outdoor' |
    % 'Open outdoor' | 'Industrial'. This property determines parameters
    % as well as the mode of operation for the UWB Channel. 
    Type (1,:) char {mustBeMember(Type,{'Indoor office','Industrial'})} = 'Indoor office'

    %HasLOS Flag indicating presence of a line-of-sight (HasLOS) component
    % Specify HasLOS as a scalar logical. This flag indicates the presence of
    % a line-of-sight component between the transmitter and the receiver.
    HasLOS (1,1) logical = true;

    %ChannelNumber Channel number
    % Specify ChannelNumber as one of [0:15]. This property determines the
    % channel bandwidth and center frequency. The default is 0.
    ChannelNumber (1, 1) double {mustBeNonnegative, mustBeLessThanOrEqual(ChannelNumber, 15)} = 0

    %TransmitPower Transmission power, in Watts
    % Specify TransmitPower as non-negative scalar. The default is 1 Watts.
    TransmitPower (1, 1) double {mustBeNonnegative} = 1

    %Distance Link distance in meters
    % Specify Distance as a positive scalar, in meters. The default is 10.
    Distance  (1, 1) double {mustBePositive} = 10

    %MaxDopplerShift Maximum Doppler shift (Hz) 
    %   Specify the maximum Doppler shift for all channel paths in Hertz as
    %   a double precision, real, nonnegative scalar. The Doppler shift
    %   applies to all the paths of the channel. When you set the
    %   MaximumDopplerShift to 0, the channel remains static for the entire
    %   input. The default value of this property is 5 Hz.
    MaxDopplerShift  (1, 1) double {mustBeNonnegative} = 5

    LastPathThreshold (1, 1) double {mustBeNonnegative, mustBeLessThanOrEqual(LastPathThreshold, 1)} = 0.05

    %SampleRate Sample rate (Hz)
    %   Specify the sample rate of the input signal in Hz as a double
    %   precision, real, positive scalar. The default value of this
    %   property is 4.992 GHz.
    SampleRate (1, 1) double {mustBePositive} = 499.2*10*1e6

    %SampleDensity Number of time samples per half wavelength
    %   Number of samples of filter coefficient generation per half
    %   wavelength. The coefficient generation sampling rate is F_cg =
    %   MaximumDopplerShift * 2 * SampleDensity Setting SampleDensity = Inf
    %   sets F_cg = SamplingRate.
    SampleDensity  (1, 1) double {mustBePositive} = 1e5
    
    %ChannelFiltering Channel filtering
    %   Set this property to false to disable channel filtering. When this
    %   property is set to false, running this object will output channel
    %   path gains only. The object does not accept an input signal and
    %   produces no filtered output signal. The default value of this
    %   property is true.
    ChannelFiltering (1, 1) logical = true;
  end

  properties (Access = private, Nontunable)
    pChannelFilter
    pChannelConfig
    pNumClusters
    pClusterArrivalTimes
    pClusterEnergies
    pPathArrivalTimes
    pAbsolutePathArrivalTimes
    pPathAveragePowers
    pPathPhases
    pNakagamiM
    pProcessedSamples = 0;
    pPathGainSamplePeriod
    pCurrentPathGains
    pLastChannelRealizationIdx = 0;
  end

  methods
    function obj = uwbChannel(type, LOS, varargin)
      obj.Type = type;
      obj.HasLOS = LOS;
      setProperties(obj, nargin-2, varargin{:});
    end

    function set.SampleRate(obj, newSR)
      obj.SampleRate = newSR;
      obj.pChannelFilter.SampleRate = newSR; %#ok<MCSUP> 
    end
  end

  methods (Access=protected)

    function num = getNumInputsImpl(obj)
      num = 0 + obj.ChannelFiltering;
    end

    function setupImpl(obj, varargin)
      %% Environment parameterization:
      env = uwbChannelConfig(obj.Type, obj.HasLOS);
      obj.pChannelConfig = env;

      %% Clusterization:
      [obj.pNumClusters, obj.pClusterArrivalTimes, obj.pClusterEnergies] = ...
        helperClusterization(obj.Type, obj.HasLOS, env.AverageNumClusters, env.ClusterArrivalRate, env.ClusterShadowingDeviation, env.ClusterEnergyDecayConstant);

      %% Path modeling:
      [obj.pPathArrivalTimes, obj.pPathAveragePowers, obj.pPathPhases] = helperPathModeling(env, ...
        obj.pClusterArrivalTimes, obj.pClusterEnergies, obj.LastPathThreshold, obj.SampleRate);
      
      obj.pAbsolutePathArrivalTimes = obj.pPathArrivalTimes;
      for idx=1:obj.pNumClusters
        % convert relative (within cluster) path arrival times to absolute time instances
        obj.pAbsolutePathArrivalTimes{idx} = obj.pAbsolutePathArrivalTimes{idx} + obj.pClusterArrivalTimes(idx);
      end

      %% Nakagami M parameter
      obj.pNakagamiM = helperNakagamiParameters(env, obj.pPathArrivalTimes);

      %% Channel filter
      if obj.ChannelFiltering
        obj.pChannelFilter = comm.ChannelFilter(SampleRate = obj.SampleRate, PathDelays=cell2mat(obj.pAbsolutePathArrivalTimes)/1e9);
        obj.pChannelFilter.NormalizeChannelOutputs = false;
      end

      %% Period of channel realizations
      Fcg = obj.MaxDopplerShift * 2 * obj.SampleDensity;
      obj.pPathGainSamplePeriod = floor(obj.SampleRate/Fcg); % in samples

      %% Channel realization (initial, in case step length is too small)
      obj.pCurrentPathGains = helperUWBFadingRealization(obj.pPathAveragePowers, obj.pNakagamiM);
    end

    function varargout = stepImpl(obj, varargin)

      nextChannelRealizationIdx = obj.pLastChannelRealizationIdx + obj.pPathGainSamplePeriod;
      if obj.ChannelFiltering
        x = varargin{1};
        x = applyPropagationPlusAntennaEffects(obj, x);
        currLen = size(x, 1);
        % Filter first part of input with current gains. Possibly entire input.
        y = obj.pChannelFilter(x(1:min(currLen, nextChannelRealizationIdx-obj.pProcessedSamples)), cell2mat(obj.pCurrentPathGains)); % filter with so far current gains
      else
        currLen = obj.pPathGainSamplePeriod; % pretending there is an input
      end

      gains = {};
      
      % If channel gains change within this input, then get new gains and
      % filter remaining input part(s)
      while nextChannelRealizationIdx-obj.pProcessedSamples <= currLen
        obj.pCurrentPathGains = helperUWBFadingRealization(obj.pPathAveragePowers, obj.pNakagamiM);
        obj.pCurrentPathGains = cellfun(@(a, phi) a.*exp(1i*phi), obj.pCurrentPathGains, obj.pPathPhases, 'UniformOutput', false);  % Eq. (15)
        gains = [gains; obj.pCurrentPathGains]; %#ok<AGROW> 

        obj.pLastChannelRealizationIdx = nextChannelRealizationIdx;
        nextChannelRealizationIdx = obj.pLastChannelRealizationIdx + obj.pPathGainSamplePeriod;

        if obj.ChannelFiltering
          offset = obj.pLastChannelRealizationIdx - obj.pProcessedSamples;
          y = [y; obj.pChannelFilter(x(1+offset:min(currLen, nextChannelRealizationIdx-obj.pProcessedSamples)), cell2mat(obj.pCurrentPathGains))]; %#ok<AGROW> % filter with new gains
        end
      end

      obj.pProcessedSamples = obj.pProcessedSamples + currLen;
      if obj.ChannelFiltering
        varargout{1} = y;
        varargout{2} = gains;
      else
        varargout{1} = gains;
      end
    end

    function y = applyPropagationPlusAntennaEffects(obj, x)
      % Distance-dependent path loss
      y = x * sqrt(obj.TransmitPower);
      y = helperDistancePathLoss(y, obj.pChannelConfig.ReferencePathLoss, obj.Distance, obj.pChannelConfig.PathLossExponent, obj.pChannelConfig.ShadowingDeviation);

      % Frequency-dependent path loss
      if any(obj.ChannelNumber == [4 11])
        bw = 1331.2e6;
      elseif obj.ChannelNumber == 7 
        bw = 1081.6e6;
      elseif obj.ChannelNumber == 15
        bw = 1354.97e6;
      else
        bw = 499.2e6;
      end
      allFc = [499.2 3494.4 3993.6 4492.8 3993.6 6489.6 6988.8 6489.6 7488.0 7987.2 8486.4 7987.2 8985.6 9484.8 9984.0 9484.8]*1e6;
      Fc = allFc(obj.ChannelNumber + 1); % 1st channel is channel 0.
      y = helperFrequencyPathLoss(y, Fc, bw, obj.pChannelConfig.FrequencyExponent);

      % Antenna effects
      y = y/2;                                           % presence of people ("antenna attenuation factor"), see Sec II.B.4 in [1]
      y = y * 10^(-obj.pChannelConfig.AntennaLoss/10);   % apply antenna loss (convert from dB to W)
    end
       
    function resetImpl(obj)
      obj.pProcessedSamples = 0;
      if obj.ChannelFiltering
        reset(obj.pChannelFilter);
      end
      obj.pLastChannelRealizationIdx = 0;
      obj.pCurrentPathGains = helperUWBFadingRealization(obj.pPathAveragePowers, obj.pNakagamiM);
    end

    function releaseImpl(obj)
      if obj.ChannelFiltering
        release(obj.pChannelFilter);
      end
    end

    function s = infoImpl(obj)
      s.ChannelConfig             = obj.pChannelConfig;
      s.NumClusters               = obj.pNumClusters;
      s.ClusterArrivalTimes       = obj.pClusterArrivalTimes;
      s.ClusterEnergies           = obj.pClusterEnergies;
      s.PathArrivalTimes          = obj.pPathArrivalTimes;
      s.AbsolutePathArrivalTimes  = obj.pAbsolutePathArrivalTimes;
      s.PathAveragePowers         = obj.pPathArrivalTimes; 
      s.pPathPhases               = obj.pPathPhases;
      s.NakagamiM                 = obj.pNakagamiM;
      s.PathGainSamplePeriod      = obj.pPathGainSamplePeriod;
    end

    function s = saveObjectImpl(obj)
      s = saveObjectImpl@matlab.System(obj);
      if isLocked(obj)
        % save private properties
        s.pChannelFilter              = obj.pChannelFilter;
        s.pChannelConfig              = obj.pChannelConfig;
        s.pNumClusters                = obj.pNumClusters;
        s.pClusterArrivalTimes        = obj.pClusterArrivalTimes;
        s.pClusterEnergies            = obj.pClusterEnergies;
        s.pPathArrivalTimes           = obj.pPathArrivalTimes;
        s.pAbsolutePathArrivalTimes   = obj.pAbsolutePathArrivalTimes;
        s.pPathAveragePowers          = obj.pPathAveragePowers;
        s.pPathPhases                 = obj.pPathPhases;
        s.pNakagamiM                  = obj.pNakagamiM;
        s.pProcessedSamples           = obj.pProcessedSamples;
        s.pPathGainSamplePeriod       = obj.pPathGainSamplePeriod;
        s.pCurrentPathGains           = obj.pCurrentPathGains;
        s.pLastChannelRealizationIdx  = obj.pLastChannelRealizationIdx;
      end
    end

    function loadObjectImpl(obj, s, wasLocked)
      if wasLocked
        obj.pChannelFilter              = s.pChannelFilter;
        obj.pChannelConfig              = s.pChannelConfig;
        obj.pNumClusters                = s.pNumClusters;
        obj.pClusterArrivalTimes        = s.pClusterArrivalTimes;
        obj.pClusterEnergies            = s.pClusterEnergies;
        obj.pPathArrivalTimes           = s.pPathArrivalTimes;
        obj.pAbsolutePathArrivalTimes   = s.pAbsolutePathArrivalTimes;
        obj.pPathAveragePowers          = s.pPathAveragePowers;
        obj.pPathPhases                 = s.pPathPhases;
        obj.pNakagamiM                  = s.pNakagamiM;
        obj.pProcessedSamples           = s.pProcessedSamples;
        obj.pPathGainSamplePeriod       = s.pPathGainSamplePeriod;
        obj.pCurrentPathGains           = s.pCurrentPathGains;
        obj.pLastChannelRealizationIdx  = s.pLastChannelRealizationIdx;
      end
    end
  end

end

