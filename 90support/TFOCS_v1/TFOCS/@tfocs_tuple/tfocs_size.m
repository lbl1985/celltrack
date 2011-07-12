function v = tfocs_size( x )

v = { @tfocs_tuple, cellfun( @size, x.value_, 'UniformOutput', false ) };

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
