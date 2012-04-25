function drawAllSetInOneImage(setDataPath, img)
% Input:
%   setDataPath:    where the processed data saving folder
%   img:            artery image data
% Example:
% DataPath =
% 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\Data';
% img =
% imread('C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\wl.tif');
% drawAllSetInOneImage(DataPath, img);
[srcdir, filenames, n] = rfdatabase(setDataPath, [], '.mat');
trackBlobObjBatch = cell(n, 1);
for i = 1 : n
    tmpLOAD = load(fullfile(srcdir, filenames{i}));
    trackBlobObjBatch{i} = tmpLOAD.trackBlobsObj;
end

drawAllTrajInOneImage(trackBlobObjBatch, img);
end