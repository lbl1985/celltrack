function op = linop_vec( sz )

%OP = LINOP_VEC( SZ )
%    Constructs a TFOCS-compatible linear operator that reduces a matrix
%    variable to a vector version using column-major order.
%    This is equivalent to X(:)
%    The transpose operator will reshape a vector into a matrix.
%
%    The input SZ should of the form [M,N] where [M,N] describe the
%    size of the matrix variable.  The ouput vector will be of 
%    length M*N.  If SZ is a single entry, then M = N is assumed.

if numel(sz) > 2, error('must supply a 2-entry vector'); end
if numel(sz) == 1, sz = [sz(1),sz(1)]; end

% Switch conventions of the size variable:
sz = { [sz(1),sz(2)], [sz(1)*sz(2),1] };
 
op = @(x,mode)linop_handles_vec( sz, x, mode );

function y = linop_handles_vec(sz, x, mode )
switch mode,
    case 0, y = sz;
    case 1, y = x(:);
    case 2, 
        MN = sz{1}; M = MN(1); N = MN(2);
        y = reshape( x, M, N );
        
end