function op = linop_compose( varargin )

%OP = LINOP_COMPOSE( OP1, OP2, ..., OPN )
%    Constructs a TFOCS-compatible linear operator from the composition of
%    two or more linear operators and/or matrices. That is,
%       OP(x,1) = OP1(OP2(...(OPN(x,1),...,1),1)
%       OP(x,2) = OPN(...(OP2(OP1(x,2),2)...,2)
%    If matrices are supplied, they must be real; to include complex
%    matrices, convert them first to linear operators using LINOP_MATRIX.

if nargin == 0,
    error( 'Not enough input arguments.' );
end
sz = { [], [] };
for k = 1 : nargin,
    tL = varargin{k};
    if isempty(tL) || ~isa(tL,'function_handle') && ~isnumeric(tL) || ndims(tL) > 2,
        error( 'Arguments must be linear operators, scalars, or matrices.' );
    elseif isnumeric(tL),
        if ~isreal(tL),
            error( 'S or scalar arguments must be real.' );
        elseif numel(tL) == 1,
            tL = linop_scale( tL );
        else
            tL = linop_matrix( tL );
        end
        varargin{k} = tL;
    end
    try
        tsz = tL([],0);
    catch
        error( 'Arguments must be linear operators, scalars, or matrices.' );
    end
    if isempty(tsz)     % i.e. output of linop_identity is []
        tsz = { [], [] };
    end
    if isnumeric(tsz),
        tsz = { [tsz(2),1], [tsz(1),1] };
    end
%     if ~isempty(sz{1}) && ~isempty(tsz{2}) && ~isequal(tsz{2},tsz{1}),
% SRB: I think the above was a typo.  Changing:
    if ~isempty(sz{1}) && ~isempty(tsz{2}) && ~isequal(tsz{2},sz{1}),
        error( 'Incompatible dimensions in linear operator composition.' );
    end
    if ~isempty(tsz{1}),
        sz{1} = tsz{1};
    end
    if isempty(sz{2}),
        sz{2} = tsz{2};
    end
end
if nargin == 1,
    op = varargin{1};
else
    op = @(x,mode)linop_compose_impl( varargin, sz, x, mode );
end

function y = linop_compose_impl( ops, sz, y, mode )
switch mode,
    case 0,
        y = sz;
    case 1,
        for k = numel(ops) : -1 : 1,
            y = ops{k}( y, 1 );
        end
    case 2,
        for k = 1 : numel(ops),
            y = ops{k}( y, 2 );
        end
end

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
