function v = tfocs_size( x )

% SIZE   TFOCS-friendly size operator.

v = { @packSVD, m, n };

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
