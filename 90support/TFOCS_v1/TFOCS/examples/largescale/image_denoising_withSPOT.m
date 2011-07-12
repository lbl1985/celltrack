%{
    Tests total-variation problem and l1 analysis
        on a large-scale example

    min_x   alpha*||x||_TV + beta*||Wx||_1
s.t.
    || A(x) - b || <= eps

where W is a wavelet operator.

    Also demonstrates how to use SPOT with TFOCS.
    To install SPOT, please visit:
    http://www.cs.ubc.ca/labs/scl/spot/

    We use SPOT to call WaveLab and CurveLab,
    which may need to be installed separately.
    Please contact the TFOCS and/or SPOT authors if you need help.

    Also, SPOT v1.0 has a typo in its curvelet code:
        after adding SPOT to your path, edit this file
            edit spotbox-1.0p/opCurvelet
        and change all instances of "fdct_c2v" and "fdct_v2c"
        to "spot.utils.fdct_c2v" and "spot.utils.fdct_v2c", resp.

%}

% Setting up the various packages (change this for your computer):
addpath ~/Dropbox/TFOCS/
addpath ~/Documents/MATLAB/spotbox-1.0p/
addpath ~/Documents/MATLAB/CurveLab-2.1.2/fdct_wrapping_cpp/mex/

myAwgn = @(x,snr) x +10^( (10*log10(sum(abs(x(:)).^2)/length(x(:))) - snr)/20 )*...
    randn(size(x));
%% Load an image and take noisy measurements


n1 = 256;
n2 = 256;
N = n1*n2;
x = phantom(n1);

% Signal-to-noise ratio, in dB
snr = 5;


x_original = x;
mat = @(x) reshape(x,n1,n2);
% vec = @(x) x(:);

% Add noise:
randn('state',245); rand('state',245);
x_noisy = myAwgn( x_original, snr);

maxI    = max(vec(x_original)); % max pixel value
PSNR    = @(x) 20*log10(maxI*sqrt(N)/norm(vec(x)-vec(x_original) ) );

% Take measurements
b   = vec(x_noisy);
b_original = vec(x_original);
EPS = .8*norm(b-b_original);

figure(2); imshow( [x_original, x_noisy] ); drawnow;
M=N;
fprintf('Denoising problem, %d x %d, signal has SNR %d dB\n',M, N, round(snr) );

%% Call the TFOCS solver

mu              = 5;
er              = @(x) norm(x(:)-x_original(:))/norm(x_original(:));
opts = [];
opts.errFcn     = @(f,dual,primal) er(primal);
opts.maxIts     = 100;
opts.printEvery = 20;
opts.tol        = 1e-4;

x0 = x_noisy;
z0  = [];   % we don't have a good guess for the dual

% build operators:
A           = linop_handles([N,N], @(x)x, @(x) x );
normA2      = 1;
W_wavelet   = linop_spot( opWavelet(n1,n2,'Daubechies') );
W_curvelet  = linop_spot( opCurvelet(n1,n2) );
W_tv        = linop_TV( [n1,n2] );
normWavelet      = linop_normest( W_wavelet );
normCurvelet     = linop_normest( W_curvelet );
normTV           = linop_TV( [n1,n2], [], 'norm' );

contOpts            = [];
contOpts.maxIts     = 4;

%% -- First, solve just via wavelet --
clc; disp('WAVELETS');
x_wavelets = solver_sBPDN_W( A, W_wavelet, b, EPS, mu, ...
    x0(:), z0, opts, contOpts);

%% -- Second, solve just via curvelets --
opts_copy = opts;
opts_copy.maxIts = 15;
clc; disp('CURVELETS');
x_curvelets = solver_sBPDN_W( A, W_curvelet, b, EPS, mu, x0(:), z0, opts_copy);

%% -- Third, solve just via TV --
clc; disp('TV');
x_tv = solver_sBPDN_W( A, W_tv, b, EPS, mu, x0(:), z0, opts, contOpts);

%% -- Fourth, combine wavelets and tv --
alpha   = 1*normTV;
beta    = .5;
normW12     = normTV^2;
normW22     = normWavelet^2;

% x =solver_sBPDN_WW( A, alpha, W_tv, beta, ...
%       W_wavelet, b, EPS, mu,vec(x0), z0, opts, contOpts);

W1  = linop_compose(W_tv,1/normTV);
W2  = W_wavelet;
% Or, we can get fancy and also add box-constraints
%   (since we have a priori knowledge that the pixels values
%    are in the rnage [0,1] ).
prox       = { prox_l2( EPS ), ...
               proj_linf( alpha ),...
               proj_linf( beta ), ...
               proj_Rplus , ...
               proj_Rplus};

affine     = { A, -b; W1, 0; W2, 0 ; 1, 0; -speye(n1*n2), maxI*ones(n1*n2,1) };

x_wavelets_tv = tfocs_SCD( [], affine, prox, mu, x0(:), z0, opts, contOpts );
%% Plot everything
figure(1); clf;
splot = @(n) subplot(2,3,n);

splot(1);
imshow(x_original);
title(sprintf('Noiseless image,\nPSNR %.1f dB', Inf ));

splot(2);
imshow(x_noisy);
title(sprintf('Noisy image,\nPSNR %.1f dB', PSNR(x_noisy) ));

splot(3);
imshow(mat(x_curvelets));
title(sprintf('Curvelet regularization,\nPSNR %.1f dB', PSNR(x_curvelets) ));

splot(4);
imshow(mat(x_wavelets));
title(sprintf('Wavelet regularization,\nPSNR %.1f dB', PSNR(x_wavelets) ));

splot(5);
imshow(mat(x_tv));
title(sprintf('TV regularization,\nPSNR %.1f dB', PSNR(x_tv) ));

splot(6);
imshow(mat(x_wavelets_tv));
title(sprintf('Wavelet + TV,\nPSNR %.1f dB', PSNR(x_wavelets_tv) ));

%% Bonus: movie
figure(2); clf; plotNow();
opts.errFcn = {@(f,d,p) er(p), @(f,d,p) plotNow( mat(p) ) };
x_tv = solver_sBPDN_W( A, W_tv, b, EPS, .1*mu, vec(x0), z0, opts);
title('THAT''S ALL FOLKS');
%%
% TFOCS v1.0c by Stephen Becker, Emmanuel Candes, and Michael Grant.
% Copyright 2011 California Institute of Technology and CVX Research.
% See the file TFOCS/license.{txt,pdf} for full license information.
