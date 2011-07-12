%{
    Via smoothing, TFOCS can solve a Linear Program (LP) in standard form:

(P)     min c'x s.t. x >= 0, Ax=b


    This extends to SDP as well (see example_SDP.m )
%}

% Add TFOCS to your path.

randn('state',9243); rand('state',234324');

N = 5000;
M = round(N/2);
x = randn(N,1)+10;
A = sprand(M,N,.01);
c = randn(N,1);
b = A*x;
if issparse(A)
    normA   = normest(A);
else
    normA = norm(A);
end

fileName = fullfile('reference_solutions','LP');
if exist([fileName,'.mat'],'file')
    load(fileName);
    fprintf('Loaded problem from %s\n', fileName );
else
    cvx_begin
        variable x(N)
        minimize( c'*x )
        subject to
            x >= 0
            A*x == b
    cvx_end
    x_cvx = x;
    save(fullfile(pwd,fileName),'x_cvx');
    fprintf('Saved data to file %s\n', fileName);
end

%% solve in TFOCS

opts = [];
opts.errFcn        = {@(f,d,x) norm( x - x_cvx )/norm(x_cvx )};  % optional
% opts.errFcn{end+1} =  @(f,d,x) norm( A*x - b )/norm(b );  % optional
opts.restart = 2000;
opts.continuation = true;
x0   = [];
z0   = [];
mu = 1e-3;

opts.stopCrit   = 4;
opts.tol        = 1e-4;
contOpts        = [];       % options for "continuation" settings
%   (to see possible options, type "continuation()" )
%    By changing the options, you can get much better results sometimes,
%    but here we use default choices for simplicity.
% contOpts.accel  = false;
% contOpts.betaTol    = 10;
% contOpts.finalTol = 1e-10;

opts.normA      = normA; % this will help with scaling
[x,out,optsOut] = solver_sLP(c,A,b, mu, x0, z0, opts, contOpts);

%% plot
figure(2);
semilogy( out.err(:,1) );

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
