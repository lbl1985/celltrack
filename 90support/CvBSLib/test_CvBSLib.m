clear;close all;
% videoFullFileName = 'd:/research/data/bal/bldgcam1.avi';
videoFullFileName = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking';
[videoPath,videoFileName,videoFileExt,versn] = fileparts(videoFullFileName);

% read the first frame of the video
[video,audio] = mmread(videoFullFileName,[1],[],false,true);
nFramesTotal = abs(video.nrFramesTotal);
frameWidth  = video.width; frameHeight = video.height;

startFrame = 1;

for k=startFrame:nFramesTotal
    % get the nextframe
    [video,audio] = mmread(videoFullFileName,[k],[],false,true);
    nextFrame = video.frames(1).cdata; originalFrame = nextFrame;
    
    if k==startFrame
        % initialize background subtraction
        h=mexCvBSLib(nextFrame);%Initialize
        mexCvBSLib(nextFrame,h,[0.01 5*5 0 0.5]);%set parameters
    end
    
    fgMask=mexCvBSLib(nextFrame,h);
    
    figure(1);
    subplot(1,2,1);imshow(nextFrame);
    subplot(1,2,2);imshow(fgMask);
    title(sprintf('Frame:%d',k));
    
    
end

mexCvBSLib(h);
