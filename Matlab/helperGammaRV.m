function g = helperGammaRV(k, theta)
%helperGammaRV Generate Gamma-distributed random variable
% G = helperGammaRV(K, THETA) returns the Gamma-distributed random variable G, given
% the shape parameter K and the scale parameter THETA, as per the method
% described in: https://en.wikipedia.org/wiki/Gamma_distribution#Generating_gamma-distributed_random_variables

%   Copyright 2022 The MathWorks, Inc.

%% 1. Create Gamma(1, 1) r.v. (x floor(k) times)
% Gamma(1, 1) is an exponential random variable with rate 1, use inverse transform method:
g11 = -log(rand(1, floor(k)));

%% 2. Create a Gamma(floor(k), 1) r.v
gN1 = sum(g11);

%% 3. Create a Gamma(mod(k, 1), 1) r.v
delta = mod(k, 1);
eta = inf;  % Init values ensuring that WHILE loop starts
ksi = 0;
while eta > ksi^(delta-1)*exp(-ksi)
  % Generate U, V, W as uniform r.v.
  U = rand;
  V = rand;
  W = rand;
  if U < exp(1)/(exp(1)+delta)
    ksi = V^(1/delta);
    eta = W*ksi^(delta-1);
  else
    ksi = 1 - log(V);
    eta = W*exp(-ksi);
  end
end
% ksi is now distributed as Gamma(delta, 1). 

%% 4. Create a Gamma(k, theta) r.v
% combine above results
g = theta*(ksi + gN1);

end
