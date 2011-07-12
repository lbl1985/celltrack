function mat = images2var(srcdir, filenames)
totalFrameNum = length(filenames);
img = imread([srcdir filenames{1}]);
siz = size(img);
% SIAM_bkgdSubtraction require vectorized gray images.
mat = zeros(siz(1) * siz(2), siz(end));

for frameNum = 1 : totalFrameNum 
    img = imread([srcdir filenames{frameNum}]);
    img_gray = rgb2gray(img);
    mat(:, frameNum) = img_gray(:);    
end
    