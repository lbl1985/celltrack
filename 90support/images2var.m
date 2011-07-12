function mat = images2var(srcdir, filenames)
mat = [];
totalFrameNum = length(filenames);
img = imread([srcdir filenames{1}]);
nd = ndims(img);
for frameNum = 1 : totalFrameNum 
    img = imread([srcdir filenames{frameNum}]);
    mat = cat(nd + 1, mat, img);
end
    