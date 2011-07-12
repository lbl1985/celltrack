function mat = images2var(srcdir, filenames, resizeRatio)
totalFrameNum = length(filenames);
img = imread([srcdir filenames{1}]);
siz = size(img);
% SIAM_bkgdSubtraction require vectorized gray images.
numrows = ceil(siz(1) * resizeRatio);
numcols = ceil(siz(2) * resizeRatio);
mat = zeros(numrows * numcols, siz(end));

for frameNum = 1 : totalFrameNum 
    img = imread([srcdir filenames{frameNum}]);
    img_gray = rgb2gray(img);
    img_gray = imresize(img_gray, [numrows numcols]);
    mat(:, frameNum) = img_gray(:);    
end
    