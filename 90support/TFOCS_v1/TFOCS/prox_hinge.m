function op = prox_hinge( q , r)

%PROX_HINGE    Hinge-loss function.
%    OP = PROX_HINGE( q , r ) implements the nonsmooth function
%        OP(X) = q * sum( max( r - x, 0 ) ).
%    Q is optional; if omitted, Q=1 is assumed. But if Q is supplied,
%    then it must be a positive real scalar.
%    R is also optional; if omitted, R = 1 is assumed. R may be any real scalar.
%
% See also PROX_HINGEDUAL

if nargin < 2
	r = 1;
elseif ~isnumeric( r ) || ~isreal( r ) || numel( r ) ~= 1
	error( 'Argument must be real scalar.' );
end
if nargin < 1
	q = 1;
elseif ~isnumeric( q ) || ~isreal( q ) || numel( q ) ~= 1 || q <= 0,
	error( 'Argument must be positive.' );
end

op = tfocs_prox( @hinge, @prox_hinge );

function v = hinge(x)
    v = q*sum( max( r - x(:), 0 ) );
end

%   PROX_F( Y, t ) = argmin_X  F(X) + 1/(2*t)*|| X - Y ||^2
function x = prox_hinge(x,t)  
    tq = t * q;
    x = r + (x-r).*( x > r ) + (x + tq - r).*( x < r - tq );
end
%{
    in the q = r = t = 1 case, the prox is:
prox(x) = {     x, if x > 1
                1, if x <= 1, and x > 0
                x + q, if x <= 0
%}


end

% Added Feb, 2011

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
