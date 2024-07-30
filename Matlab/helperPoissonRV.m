function x = helperPoissonRV(lambda)
%helperPoissonRV Generate Poisson random variable
% P = helperPoissonRV(LAMBDA) returns the Poisson random variable P, given
% the Poisson parameter LAMBDA.

%   Copyright 2022 The MathWorks, Inc.

    x = 0;
    p = 0;
    whileFlag = true;
    while (whileFlag)
      p = p - log(rand());
      if (p > lambda)
        whileFlag = false;
      else
        x = x + 1;
      end
    end
end
