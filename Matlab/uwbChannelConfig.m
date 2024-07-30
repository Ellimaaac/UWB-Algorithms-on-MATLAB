classdef uwbChannelConfig < comm.internal.ConfigBase
%UWBCHANNELCONFIG Configuration for propagation environment of UWB channel model
%   CFG = uwbChannelConfig(TYPE, HasLOS) creates a configuration object for a
%   IEEE 802.15.4a/z UWB Channel Model. TYPE can be one of 'Residential' |
%   'Indoor office' | 'Outdoor' | 'Open outdoor' | 'Industrial'. HasLOS is a
%   boolean indicating whether a line-of-sight component exists between
%   transmitter and receiver. For 'Open outdoor' environments, HasLOS must be
%   false.
%
%   uwbChannelConfig properties:
%
%   Type                        - Environment type ('Residential', 'Indoor office', 'Outdoor', 'Open outdoor', 'Industrial'
%   HasLOS                      - Boolean indicating presence of line-of-sight component
%   ReferencePathLoss           - Path loss (in dB) at 1 m distance
%   PathLossExponent            - Path loss exponent
%   ShadowingDeviation          - Standard deviation of shadowing
%   AntennaLoss                 - Antenna loss
%   FrequencyExponent           - Frequency dependence of path loss
%   AverageNumClusters          - Mean number of clusters
%   ClusterArrivalRate          - Inter-cluster arrival rate
%   PathArrivalRate1            - First (ray) arrival rate for mixed Poisson model
%   PathArrivalRate2            - Second (ray) arrival rate for mixed Poisson model
%   MixtureProbability          - Mixture probability for mixed Poisson model
%   ClusterEnergyDecayConstant  - Inter-cluster exponential decay constant
%   PathDecaySlope              - Slope of intra-cluster exponential decay constant
%   PathDecayOffset             - Offset of intra-cluster exponential decay constant
%   ClusterShadowingDeviation   - Standard deviation of cluster shadowing
%   PDPIncreaseFactor           - Increase rate of alternative power delay profile
%   PDPDecayFactor              - Decay rate of alternative power delay profile (at later times)
%   FirstPathAttenuation        - Attenuation of 1st component in alternative power delay profile
%   NakagamiMeanOffset          - Offset of Nakagami m factor mean
%   NakagamiMeanSlope           - Slope of Nakagami m factor mean
%   NakagamiDeviationOffset     - Offset of Nakagami m factor variance
%   NakagamiDeviationSlope      - Slope of Nakagami m factor variance
%   FirstPathNakagami           - Nakagami m factor of first (strong) component
%
%   See also uwbChannel.

%   Copyright 2022 The MathWorks, Inc.

  properties
    %Type Environment type
    % Specify Type as one of 'Residential' | 'Indoor office' | 'Outdoor' |
    % 'Open outdoor' | 'Industrial'. This property determines parameters
    % as well as the mode of operation for the UWB Channel. 
    Type (1,:) char {mustBeMember(Type,{'Indoor office', 'Industrial'})} = 'Indoor office';

    %HasLOS Flag indicating presence of a line-of-sight (HasLOS) component
    % Specify HasLOS as a scalar logical. This flag indicates the presence of
    % a line-of-sight component between the transmitter and the receiver.
    HasLOS (1,1) logical = true;

    %ReferencePathLoss Path loss at 1 m distance
    % ReferencePathLoss is the path loss PL_0 (i.e.,  ratio of received to
    % transmitted power), specified in dB, at a 1m reference distance.
    ReferencePathLoss

    %PathLossExponent Path loss exponent
    % PathLossExponent is the path loss exponent (n), which determines the rate at which
    % received power decays as a function of distance.
    PathLossExponent

    %ShadowingDeviation Standard deviation of shadowing
    % ShadowingDeviation is the standard deviation (sigma_S, in dB) of a zero-mean Gaussian distributed
    % random variable (S), which expresses shadowing, i.e., large-scale
    % fading.
    ShadowingDeviation

    %AntennaLoss Antenna loss
    % AntennaLoss is the signal power loss due to antennas (Aant), specified in dB.
    AntennaLoss

    %FrequencyExponent Frequency dependence of path loss
    % FrequencyExponent is the exponent (kappa) that determines the rate at
    % which received power decays as a function of frequency. The values
    % are specified in dB/octave. This property does not apply when Type is
    % 'Open outdoor'.
    FrequencyExponent

    %AverageNumClusters Mean number of clusters
    % AverageNumClusters is the mean number of clusters (Lbar), in which rays are grouped.
    AverageNumClusters

    %ClusterArrivalRate Inter-cluster arrival rate
    % ClusterArrivalRate is the arrival rate (Lambda) of clusters (i.e.,
    % groups of rays), which follow a Poisson process. The value expresses
    % the number of arrivals with 1 ns. This property does not apply when
    % HasLOS is false and Type is either 'Indoor office' or 'Industrial'.
    ClusterArrivalRate

    %PathArrivalRate1 - First (ray) arrival rate for mixed Poisson model
    % PathArrivalRate1 is one of the two arrival rates of rays within a
    % cluster (lambda1), which follow a Poisson process. PathArrivalRate1
    % is weighted by MixtureProbability. The value expresses the number of
    % arrivals with 1 ns. This property does not apply when Type is
    % 'Industrial' or when Type is 'Indoor office' and HasLOS is false.
    PathArrivalRate1

    %PathArrivalRate2 - Second (ray) arrival rate for mixed Poisson model
    % PathArrivalRate2 is the other arrival rate of rays within a cluster
    % (lambda2), which follow a Poisson process. PathArrivalRate2 is
    % weighted by the complement of the mixture probability,
    % 1-MixtureProbability. The value expresses the number of arrivals with
    % 1 ns.
    PathArrivalRate2

    %MixtureProbability Mixture probability for mixed Poisson model
    % MixtureProbability is a mixture probability (beta) that specifies the
    % relative weight of the two different ray arrival rates (within a
    % cluster) PathArrivalRate1 and PathArrivalRate2. Values must be
    % contained in [0 1].
    MixtureProbability

    %ClusterEnergyDecayConstant Inter-cluster exponential decay constant
    % ClusterEnergyDecayConstant is a constant (Gamma) determining the rate
    % of exponential decay of the cluster integrated energy as a function
    % of the cluster arrival time. The value is specified in ns. This
    % property does not apply when HasLOS is false and Type is either
    % 'Indoor office' or 'Industrial'.
    ClusterEnergyDecayConstant

    %PathDecaySlope Slope of intra-cluster exponential decay constant
    % PathDecaySlope (k_gamma) proportionally affects gamma_l as a function
    % of the cluster arrival time. gamma_l is a constant determining the
    % rate of exponential decay of a ray's power as a function of the ray
    % arrival time.This property does not apply when HasLOS is false and
    % Type is either 'Indoor office' or 'Industrial'.
    PathDecaySlope

    %PathDecayOffset Offset of intra-cluster exponential decay constant
    % PathDecayOffset is the y-intercept value (gamma_0, in ns) of the
    % function relating gamma_l with the cluster arrival time. gamma_l is a
    % constant determining the rate of exponential decay of a ray's power
    % as a function of the ray arrival time. This property does not apply
    % when HasLOS is false and Type is either 'Indoor office' or
    % 'Industrial'.
    PathDecayOffset

    %ClusterShadowingDeviation Standard deviation of cluster shadowing
    % ClusterShadowingDeviation is the standard deviation (sigma_cluster in
    % dB) of a normally distributed random variable (Mcluster), which
    % expresses cluster shadowing, i.e., temporal variations from the
    % average cluster power. This property applies when Type is
    % 'Residential' or when Type is 'Industrial' and HasLOS is true.
    ClusterShadowingDeviation

    %PDPIncreaseFactor Increase rate of alternative power delay profile
    % PDPIncreaseFactor (gamma_rise) determines how quickly the alternative
    % power delay profile (PDP) rises. This alternative model is used when
    % HasLOS is false and Type is 'Indoor office' or 'Industrial'.
    PDPIncreaseFactor

    %PDPDecayFactor Decay rate of alternative power delay profile (at later times)
    % PDPDecayFactor (gamma_1) determines how quickly the alternative power
    % delay profile (PDP) decays. This alternative model is used when
    % HasLOS is false and Type is 'Indoor office' or 'Industrial'.
    PDPDecayFactor

    %FirstPathAttenuation Attenuation of 1st component in alternative power delay profile
    % FirstPathAttenuation is the attenuation (chi) of the first multi-path
    % component in the alternative delay profile (PDP). This alternative
    % model is used when HasLOS is false and Type is 'Indoor office' or
    % 'Industrial'.
    FirstPathAttenuation

    %NakagamiMeanOffset Offset of Nakagami m factor mean
    % NakagamiMeanOffset is the y-intercept value (m0, in dB) of the function relating the mean
    % value of the Nakagami m factor with the delay of a multipath
    % component.
    NakagamiMeanOffset

    %NakagamiMeanSlope Slope of Nakagami m factor mean
    % NakagamiMeanSlope is the slope (k_m) of the function relating the mean value of the
    % Nakagami m factor with the delay of a multipath component.
    NakagamiMeanSlope

    %NakagamiDeviationOffset Offset of Nakagami m factor variance
    % NakagamiDeviationOffset is the y-intercept value (in dB) of the function relating the
    % standard deviation of the Nakagami m factor with the delay of a
    % multipath component.
    NakagamiDeviationOffset

    %NakagamiDeviationSlope Slope of Nakagami m factor variance
    % NakagamiDeviationSlope is the slope of the function relating the standard deviation of
    % the Nakagami m factor with the delay of a multipath component.
    NakagamiDeviationSlope

    %FirstPathNakagami Nakagami m factor of first (strong) component
    % FirstPathNakagami is the Nakagami factor (m_0tilde) of the first component of each cluster (which
    % are modeled differently than the rest). This property applies when
    % Type is 'Open outdoor' or when Type is 'Industrial' and HasLOS is true.
    FirstPathNakagami
  end

  properties (Access = protected)
    Initializing  = true;
  end
  
  methods
    function obj = uwbChannelConfig(type, HasLOS)
%   CFG = uwbChannelConfig(TYPE, HasLOS) creates a configuration object for a
%   IEEE 802.15.4a/z UWB Channel Model. TYPE can be one of 'Indoor office' | 'Industrial'. 
%   HasLOS is a boolean indicating whether a line-of-sight component exists between
%   transmitter and receiver. For 'Open outdoor' environments, HasLOS must be false.
      arguments
        type (1,:) char {mustBeMember(type,{'Indoor office','Industrial'})}
        HasLOS (1,1) logical
      end

      narginchk(2, 2);

      obj.Type = type;
      obj.HasLOS = HasLOS;

      obj.Initializing = false; % Otherwise, a false error may be thrown for HasLOS & Outdoor Environment

      obj = updateModelParameters(obj);
    end

    function obj = updateModelParameters(obj)
      switch obj.Type
        case 'Indoor office'
          obj = setupIndoorOfficeEnvironment(obj);
        case 'Industrial'
          obj = setupIndustrialEnvironment(obj);
      end
    end

    
    function obj = setupIndoorOfficeEnvironment(obj)
      if obj.HasLOS
        obj.ReferencePathLoss           = 35.4;
        obj.PathLossExponent            = 1.63;
        obj.ShadowingDeviation          = 1.9;
        obj.AntennaLoss                 = 3;
        obj.FrequencyExponent           = 0.03;
        obj.AverageNumClusters          = 5.4;
        obj.ClusterArrivalRate          = 0.016;
        obj.PathArrivalRate1            = 0.19;
        obj.PathArrivalRate2            = 2.97;
        obj.MixtureProbability          = 0.0184;
        obj.ClusterEnergyDecayConstant  = 14.6;
        obj.PathDecaySlope              = 0;
        obj.PathDecayOffset             = 6.4;
        obj.ClusterShadowingDeviation   = nan;
        obj.PDPIncreaseFactor           = nan;
        obj.PDPDecayFactor              = nan;
        obj.FirstPathAttenuation        = nan;
        obj.NakagamiMeanOffset          = 0.42;
        obj.NakagamiMeanSlope           = 0;
        obj.NakagamiDeviationOffset     = 0.31;
        obj.NakagamiDeviationSlope      = 0;
        obj.FirstPathNakagami           = nan;
      else % NLOS
        obj.ReferencePathLoss           = 57.9;
        obj.PathLossExponent            = 3.07;
        obj.ShadowingDeviation          = 3.9;
        obj.AntennaLoss                 = 3;
        obj.FrequencyExponent           = 0.71;
        obj.AverageNumClusters          = 1;
        obj.ClusterArrivalRate          = nan;
        obj.PathArrivalRate1            = nan;
        obj.PathArrivalRate2            = nan;
        obj.MixtureProbability          = nan;
        obj.ClusterEnergyDecayConstant  = nan;
        obj.PathDecaySlope              = nan;
        obj.PathDecayOffset             = nan;
        obj.ClusterShadowingDeviation   = nan;
        obj.PDPIncreaseFactor           = 15.21;
        obj.PDPDecayFactor              = 11.84;
        obj.FirstPathAttenuation        = 0.86;
        obj.NakagamiMeanOffset          = 0.5;
        obj.NakagamiMeanSlope           = 0;
        obj.NakagamiDeviationOffset     = 0.25;
        obj.NakagamiDeviationSlope      = 0;
        obj.FirstPathNakagami           = nan;
      end
    end

    
  
    function obj = setupIndustrialEnvironment(obj)
      if obj.HasLOS
        obj.ReferencePathLoss           = 56.7;
        obj.PathLossExponent            = 1.2;
        obj.ShadowingDeviation          = 6;
        obj.AntennaLoss                 = 3;
        obj.FrequencyExponent           = -1.103;
        obj.AverageNumClusters          = 4.75;
        obj.ClusterArrivalRate          = 0.0709;
        obj.PathArrivalRate1            = 0; % Report doesn't define lambdas & MixtureProbability, but are needed for power computation
        obj.PathArrivalRate2            = 0; % Report doesn't define lambdas & MixtureProbability, but are needed for power computation
        obj.MixtureProbability          = 0; % Report doesn't define lambdas & MixtureProbability, but are needed for power computation
        obj.ClusterEnergyDecayConstant  = 13.47;
        obj.PathDecaySlope              = 0.926;
        obj.PathDecayOffset             = 0.651;
        obj.ClusterShadowingDeviation   = 4.32;
        obj.PDPIncreaseFactor           = nan;
        obj.PDPDecayFactor              = nan;
        obj.FirstPathAttenuation        = nan;
        obj.NakagamiMeanOffset          = 0.36;
        obj.NakagamiMeanSlope           = 0;
        obj.NakagamiDeviationOffset     = 1.13;
        obj.NakagamiDeviationSlope      = 0;
        obj.FirstPathNakagami           = 12.99;
      else % NLOS
        obj.ReferencePathLoss           = 56.7;
        obj.PathLossExponent            = 2.15;
        obj.ShadowingDeviation          = 6;
        obj.AntennaLoss                 = 3;
        obj.FrequencyExponent           = -1.427;
        obj.AverageNumClusters          = 1;
        obj.ClusterArrivalRate          = nan;
        obj.PathArrivalRate1            = nan;
        obj.PathArrivalRate2            = nan;
        obj.MixtureProbability          = nan;
        obj.ClusterEnergyDecayConstant  = nan;
        obj.PathDecaySlope              = nan;
        obj.PathDecayOffset             = nan;
        obj.ClusterShadowingDeviation   = nan;
        obj.PDPIncreaseFactor           = 17.35;
        obj.PDPDecayFactor              = 85.36;
        obj.FirstPathAttenuation        = 1;
        obj.NakagamiMeanOffset          = 0.3;
        obj.NakagamiMeanSlope           = 0;
        obj.NakagamiDeviationOffset     = 1.15;
        obj.NakagamiDeviationSlope      = 0;
        obj.FirstPathNakagami           = nan;
      end
    end

    function obj = set.Type(obj, val)
      obj.Type = val;

      if ~obj.Initializing %#ok<MCSUP> 
        updateModelParameters(obj);
      end
    end

    function obj = set.HasLOS(obj, val)
      obj.HasLOS = val;

      if ~obj.Initializing %#ok<MCSUP> 
        updateModelParameters(obj);
      end
    end
  end


  methods (Access=protected)
    function flag = isInactiveProperty(obj, prop)
      % Controls the conditional display of properties
      flag = false;
      
      if any(strcmp(prop, {'PDPIncreaseFactor', 'PDPDecayFactor', 'FirstPathAttenuation'}))
        flag = obj.HasLOS || ~any(strcmp(obj.Type, {'Indoor office', 'Industrial'}));
      end

      if strcmp(prop, 'FirstPathNakagami')
        flag = ~(strcmp(obj.Type, 'Industrial') && obj.HasLOS);
      end

      if strcmp(prop, 'ClusterShadowingDeviation')
        flag = ~((strcmp(obj.Type, 'Industrial') && obj.HasLOS) || strcmp(obj.Type, 'Indoor office'));
      end

      if any(strcmp(prop, {'PathArrivalRate1', 'PathArrivalRate2', 'MixtureProbability'}))
        flag = (strcmp(obj.Type, 'Indoor office') && ~obj.HasLOS) || strcmp(obj.Type, 'Industrial');
      end

      if any(strcmp(prop, {'ClusterArrivalRate', 'ClusterEnergyDecayConstant', 'PathDecaySlope', 'PathDecayOffset'}))
        flag =  ~obj.HasLOS && any(strcmp(obj.Type, {'Indoor office', 'Industrial'}));
      end
      
    end
  end
end

