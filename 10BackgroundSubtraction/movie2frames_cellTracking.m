% Writer Log
% In order to implement the window combination background subtraction. As
% pre-processing step need to add another modeF (Function mode)  for
% movie2frames_cellTracking function. 
% For default, the movie2frame_cellTracking should just be normally convert
% all frames in the video into .jpg videos. 
% For window_combine, save the images as the mean of several images, the
% number of images is defined as input papramenter window_size.
% Binlong Li    22 June 2011    01:07PM
% 
% In order to connect with function CellTrajectory, need to output
% savingDir
% Binlong Li    22 June 2011    
% Combine several image with mean operation.
% Binlong LI    23 June 2011    12:14PM
function varargout = movie2frames_cellTracking(filename, nd, varargin)
% Change the movie into .jpg frames.
% The save file will be saved in the path with movie name
% Files name will be: movie name + Frame#
% Since I may need to duplicate the frames by 2
%
% for method window_combine, 
% Need nargin == 4. 
% varargin{1} is the name of method.
% varargin{2} is the window size;
% Such as: 
% varargin{1} = 'window_combine';  
% varargin{2} = 3
% Example:
% movie2frames('singleCameraOutput2.wmv');
olderpath = pwd;    %nd = 2;
movie = mmread(filename);
nFrame = movie.nrFramesTotal;
nDigtal = ceil(log10(nFrame * nd));

if nargin  == 2
    outputDir = fullfile(olderpath, filename(1:end-4));
    mkdir(outputDir); cd(outputDir);
    for k = 0 : nd - 1
        for i = 1 : nFrame
            I = movie.frames(i).cdata;
            imwrite(I, [filename(1:end-4) '_' int2str2(i + k * nFrame,nDigtal) '.jpg']);
        end
    end
elseif nargin == 4
    method = varargin{1};
    switch method
        case 'window_combine'
            outputDir = fullfile(olderpath, [filename(1:end-4) 'window_combine']);
            mkdir(outputDir); cd(outputDir);
            winSize = varargin{2};
            I = movie.frames(1).cdata;
            ndim = ndims(I);
            for k = 0 : nd - 1
                for t = 1 : nFrame -(winSize - 1)
%                     Icombine = [];
                    Icombine = uint8(zeros(size(I)));
                    for i = 0 : winSize - 1
                        I = movie.frames(t + i).cdata;
                        Icombine = Icombine + I;
                    end
%                     Imean = uint8(mean(Icombine, ndim + 1));
                    % If the values combine exceed 255, it will
                    % automatically switched back to 255.
                    Imean = uint8(Icombine);
                    imwrite(Imean, [filename(1:end-4) '_' int2str2(t + k * nFrame,nDigtal) '.jpg']);
                end
            end
    end
end

varargout{1} = outputDir;
cd (olderpath);