clear;close all;
%% Parameters
sequencePath = 'C:\Users\Caglayan\research\data\pets2003\testing\camera3';
imageTag = 'Frame';
imageExt = 'jpg';
numDigits = 4;
% form the image name format
imageNameFormat = ['%s/%s%0' num2str(numDigits) 'd.%s'];

% if the input is very huge resize it
kResizeRatio = 1;

% read the first frame of the video
imageFullFileName = sprintf(imageNameFormat,sequencePath,imageTag,1,imageExt);

CameraId = 1;
dataset_dir = 'C:\Users\lbl1985\Documents\MATLAB\work\database\PETS2001\DATASET3\TESTING\';
% Camera_dir = fullfile(dataset_dir, ['CAMERA' num2str(CameraId) '_JPEGS_Backup']);
Camera_dir = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\3tubes_010flow_g10';

% I = saveImages_asMat(Camera1_dir, '.jpg', 1590, 1710, pwd);
% [srcdirImg filenamesImg nframes] = rfdatabase(Camera_dir, 'frame', '.jpg');
[srcdirImg filenamesImg nframes] = rfdatabase(Camera_dir, [], '.jpg');
filename = filenamesImg{1}(1:end - 7);


img_color = imread([srcdirImg filenamesImg{1}]);
% nFramesTotal = abs(video{1}.nrFramesTotal);
[frameHeight frameWidth depth]= size(img_color);
frameHeight = frameHeight*kResizeRatio; frameWidth = frameWidth*kResizeRatio; 

startFrame = 1;
endFrame = nframes;
fg = zeros(frameHeight, frameWidth, endFrame - startFrame + 1);
for t=startFrame:endFrame
    
    % get the nextframe
    imageFullFileName = sprintf(imageNameFormat,sequencePath,imageTag,t,imageExt);
    img_color = imread([srcdirImg filenamesImg{t}]);        
%     img = rgb2gray(img_color);
    img = img_color;
    
    if t==startFrame
        % initialize background subtraction
        h=mexCvBSLib(img);%Initialize
        mexCvBSLib(img,h,[1/300 4*4 0 0.5]);%set parameters
    end
    
    fgMask=mexCvBSLib(img,h);
    
    figure(1);
    subplot(1,2,1);imshow(img);
    subplot(1,2,2);imshow(fgMask);
    fgMask = medfilt2(fgMask, [5 5]);
    title(sprintf('Frame:%d',t));
    fg(:, :, t - startFrame + 1) = fgMask;
    
end

% save(['Camera' num2str(CameraId) 'bgSub.mat'], 'fg');
save([filename 'bgSub.mat'], 'fg');
mexCvBSLib(h);
