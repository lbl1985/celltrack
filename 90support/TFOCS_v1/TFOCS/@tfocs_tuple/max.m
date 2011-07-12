function z = max( x, y )

% MAX   Maximum, z = max(x,y)

if isa(x,'tfocs_tuple')
    z = x;
    if isa(y,'tfocs_tuple')
        z.value_ = cellfun( @max, x.value_, y.value_, 'UniformOutput', false );
    elseif isscalar(y)
        z.value_ = cellfun( @max, x.value_, {y}, 'UniformOutput', false );
    else 
        z.value_ = cellfun( @max, x.value_, {y}, 'UniformOutput', false );
    end
else
    z = y;
    if isscalar(x)
        z.value_ = cellfun( @max, {x}, y.value_, 'UniformOutput', false );
    else 
        z.value_ = cellfun( @max, {x}, y.value_, 'UniformOutput', false );
    end
end

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
