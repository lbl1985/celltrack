function op = prox_l2( q )

%PROX_L2    L2 norm.
%    OP = PROX_L2( q ) implements the nonsmooth function
%        OP(X) = q * norm(X,'fro').
%    Q is optional; if omitted, Q=1 is assumed. But if Q is supplied,
%    then it must be a positive real scalar.
%    If Q is a vector or matrix of the same size and dimensions as X,
%       then this uses an experimental code to compute the proximity operator.

% Feb '11, allowing for q to be a vector
%       This is complicated, so not for certain
%       A safer method is to use a linear operator to scale the variables

if nargin == 0,
	q = 1;
% elseif ~isnumeric( q ) || ~isreal( q ) || numel( q ) ~= 1 || q <= 0,
elseif ~isnumeric( q ) || ~isreal( q ) ||  any( q < 0 ) || all(q==0)
	error( 'Argument must be positive.' );
end
if isscalar(q)
    op = @(varargin)prox_l2_q( q, varargin{:} );
else
    op = @(varargin)prox_l2_vector( q, varargin{:} );
end

function [ v, x ] = prox_l2_q( q, x, t )
if nargin < 2,
	error( 'Not enough arguments.' );
end
v = sqrt( tfocs_normsq( x ) ); 
if nargin == 3,
	s = 1 - 1 ./ max( v / ( t * q ), 1 ); 
   
	x = x * s;
	v = v * s; % version A
elseif nargout == 2,
	error( 'This function is not differentiable.' );
end
v = q * v; % version A


% --------- experimental code -----------------------
function [ v, x ] = prox_l2_vector( q, x, t )
if nargin < 2,
	error( 'Not enough arguments.' );
end
v = sqrt( tfocs_normsq( q.*x ) ); % version B
if nargin == 3,
%{
   we need to solve for a scalar variable s = ||q.*x|| 
      (where x is the unknown solution)
    
   we have a fixed point equation:
        s = f(s) := norm( q.*x_k ) where x_k = x_0/( 1 + t*q/s )
   
   to solve this, we'll use Matlab's "fzero" to find the zero
    of the function F(s) = f(s) - s
    
   Clearly, we need s >= 0, since it is ||q.*x||
    
   If q is a scalar, we can solve explicitly: s = q*(norm(x0) - t)
    
%}
    
    xk = @(s) x./( 1 + t*q/s );
    f = @(s) norm( q.*xk(s) );
    F = @(s) f(s) - s;
    [s,sVal] = fzero( F, 1 );
    if abs( sVal ) > 1e-4
        error('cannot find a zero'); 
    end
    if s <= 0
        x = 0*x;
    else
        x = xk(s);
    end
    v = sqrt( tfocs_normsq( q.*x ) ); % version B
elseif nargout == 2,
	error( 'This function is not differentiable.' );
end

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
