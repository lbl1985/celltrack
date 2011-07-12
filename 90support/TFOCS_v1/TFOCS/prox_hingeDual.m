function op = prox_hingeDual( q , r)

%PROX_HINGEDUAL    Dual function of the Hinge-loss function.
%    OP = PROX_HINGEDUAL( q , r ) implements the nonsmooth function
%        that is dual to the Hinge-loss function f, where 
%        f(x) = q * sum( max( r - x, 0 ) ).
%    Q is optional; if omitted, Q=1 is assumed. But if Q is supplied,
%    then it must be a positive real scalar.
%    R is also optional; if omitted, R = 1 is assumed. R may be any real scalar.
%
%   There is a simple form for the dual and its proximity operator.
%   In the case q = r = 1, the dual is:
%       f^*(y) = { +y, if y >= -1 and y <= 0
%                { +Inf, otherwise
%
% See also PROX_HINGE

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

op = tfocs_prox( @hingeDual, @prox_hingeDual );

function v = hingeDual(x)
    feasible = ( x >= -q & x <= 0 );
    v = sum( x*r.*( feasible ) + Inf.*( ~feasible ) );
end

%   PROX_F( Y, t ) = argmin_X  F(X) + 1/(2*t)*|| X - Y ||^2
function x = prox_hingeDual(x,t)  
    x = max( min( x - t*r, 0), -q );
end



end

% Added Feb, 2011

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
