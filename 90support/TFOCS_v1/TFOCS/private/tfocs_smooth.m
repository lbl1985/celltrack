function op = tfocs_smooth( fcn )
% OP = TFOCS_SMOOTH(FCN)
%   is a wrapper designed to facilitate users writing their own
%   smooth functions.
%
%   To use this, please see the file SMOOTH_HUBER as an example
%
%   The basic layout of a file like SMOOTH_HUBER is as follows:
%
%       function op = smooth_huber(mu)
%       op = tfocs_smooth( @huber_impl )
%
%         function [f,g] = huber_impl(x)
%           ... this function calculates the function, f,
%               and the gradient, g, of x ...
%         end
%       end
%
%   Note: in the above template, the "end" statements are very important.
%
%
%   Also, users may wish to test their smooth function
%   with the script TEST_SMOOTH
%
%   See also smooth_huber, test_smooth, private/tfocs_smooth


op = @fcn_impl;

function [ v, g ] = fcn_impl(x, t )
  if nargin == 2,
      error( 'Proximity minimization not supported by this function.' );
  end
  if nargout == 2
      [v,g] = fcn(x);
  else
      v = fcn(x);
  end
end

end

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.