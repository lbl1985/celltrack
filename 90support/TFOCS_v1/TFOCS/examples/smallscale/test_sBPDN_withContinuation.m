%{
    Tests basis pursuit de-noising

    min_x ||x||_1
s.t.
    || A(x) - b || <= eps

The solvers solve a regularized version, using
    ||x||_1 + mu/2*||x-x_0||_2^2

in this file, we will use continuation to eliminate
the effect of the "mu" term.

see also test_sBPDN.m

%}

% Before running this, please add the TFOCS base directory to your path

% Try to load the problem from disk
fileName = fullfile('reference_solutions','basispursuit_problem1_noisy');
randn('state',34324);
rand('state',34324);
N = 1024;
M = round(N/2);
K = round(M/5);
A = randn(M,N);
myAwgn = @(x,snr) x + ...
        10^( (10*log10(sum(abs(x(:)).^2)/length(x(:))) - snr)/20 )*randn(size(x));
if exist([fileName,'.mat'],'file')
    load(fileName);
    fprintf('Loaded problem from %s\n', fileName );
else
    
    % Generate a new problem
    x = zeros(N,1);
    T = randsample(N,K);
    x(T) = randn(K,1);

    b_original = A*x;
    snr = 30;  % SNR in dB
    b   = myAwgn(b_original,snr);
    EPS = norm(b-b_original);
    x_original = x;
    
    mu = .01*norm(x,Inf);
    x0 = zeros(N,1);

    % get reference via CVX
    tic
    cvx_begin
        cvx_precision best
        variable xcvx(N,1)
        minimize norm(xcvx,1)
        subject to
            norm(A*xcvx - b ) <= EPS
    cvx_end
    time_IPM = toc;
    x_ref = xcvx;
    obj_ref = norm(x_ref,1);
    
    save(fileName,'x_ref','b','x_original','mu',...
        'EPS','b_original','obj_ref','x0','time_IPM','snr');
    fprintf('Saved data to file %s\n', fileName);
    
end


[M,N]           = size(A);
K               = nnz(x_original);
norm_x_ref      = norm(x_ref);
norm_x_orig     = norm(x_original);
er_ref          = @(x) norm(x-x_ref)/norm_x_ref;
er_signal       = @(x) norm(x-x_original)/norm_x_orig;
resid           = @(x) norm(A*x-b)/norm(b);  % change if b is noisy

fprintf('\tA is %d x %d, original signal has %d nonzeros\n', M, N, K );
fprintf('\tl1-norm solution and original signal differ by %.2e (mu = %.2e)\n', ...
    norm(x_ref - x_original)/norm(x_original),mu );

%% Call the TFOCS solver
er              = er_ref;  % error with reference solution (from IPM)
opts = [];
opts.restart    = 500;
opts.errFcn     = { @(f,dual,primal) er(primal) };
opts.maxIts     = 1000;
opts.countOps   = true;
z0  = [];   % we don't have a good guess for the dual
tic;

% -- with continuation, the old-fashioned way:
% solver = @(mu,x0,z0,opts) solver_sBPDN( A, b, EPS, mu, x0, z0, opts );
% contOpts        = [];
% % contOpts.maxIts = 1;
% [ x, out, optsOut ] = continuation( solver, mu, x0, z0, opts,contOpts );

% -- with continuation, the new way:
opts.continuation   = true;
[ x, out, optsOut ] = solver_sBPDN( A, b, EPS, mu, x0, z0, opts);



time_TFOCS = toc;

fprintf('Solution has %d nonzeros.  Error vs. IPM solution is %.2e\n',...
    nnz(x), er(x) );

% TODO: solver_sBPDN cannot handle the extra input. Change this!!

% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
