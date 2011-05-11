function varargout = movie2frames_cellTracking(filename, nd, varargin)
% Change the movie into .jpg frames.
% The save file will be saved in the path with movie name
% Files name will be: movie name + Frame#
% Since I may need to duplicate the frames by 2
% Example:
% movie2frames('singleCameraOutput2.wmv');
olderpath = pwd;    %nd = 2;
movie = mmread(filename);
nFrame = movie.nrFramesTotal;
nDigtal = ceil(log10(nFrame * nd));
mkdir(filename(1:end-4)); cd(filename(1:end-4));
for k = 0 : nd - 1
    for i = 1 : nFrame
        I = movie.frames(i).cdata;
        imwrite(I, [filename(1:end-4) '_' int2str2(i + k * nFrame,nDigtal) '.jpg']);
    end
end

cd (olderpath);