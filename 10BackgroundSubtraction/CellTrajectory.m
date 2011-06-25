% Working Log:
% --> Adding another Background subtraction method:  Mean value of the whole
% sequence as background.
% ----> Need to add another switch between MoG and Mean method.
% Binlong Li    21 June 2011    12:04PM
% Switch the project arichitecher, all the functions will be called from
% function main_celltrack.m in the root folder.
% As a sub-supporting function CellTrajectory need to adding output
% opinions
% Binlong Li    25 June 2011    07:49AM
% Add output options about  original Image folder path and filenames
% Binlong Li    25 June 2011    03:46PM
function varargout = CellTrajectory(id, nd, method, varargin)
%% Saving movie into frames
workingPath = pwd;
% id = 4;
% number of duplicate
% nd = 6;
% datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking';
% videoName = {'3tubes_010flow_g10.avi', '3tubes_020flow_g20.avi', ...
%     '3tubes_020flow_g20_focusbottom.avi', '18mm_2x_e3_015speed_focusbottom2.avi', ...
%     '18mm_2x_e3_015speed_focustop.avi', '18mm_2x_e3_020speed.avi', ...
% '18mm_2x_e4_015speed.avi', '18mm_2x_e4_020speed.avi', 'cells_g15_5x_test1.avi', 'cells_g15_5x_test3.avi'};

datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\vivo';
datapath = folderUniverse(datapath, 'PC');

[datapath videoName n] = rfdatabase(datapath, [], '.avi');

cd(datapath);
movie2frames_cellTracking(videoName{id}, nd);
cd(workingPath);

% Image Processing Preparations
numDigits = 4;

% if the input is very huge resize it
kResizeRatio = 1;

% CameraId = 1;
% Camera_dir = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\3tubes_010flow_g10';
Camera_dir = fullfile(datapath, videoName{id}(1:end-4));

[srcdirImg filenamesImg nframes] = rfdatabase(Camera_dir, [], '.jpg');
filename = filenamesImg{1}(1:end - 7);

img_color = imread([srcdirImg filenamesImg{1}]);
% nFramesTotal = abs(video{1}.nrFramesTotal);
[frameHeight frameWidth depth]= size(img_color);
frameHeight = frameHeight*kResizeRatio; frameWidth = frameWidth*kResizeRatio;


switch method
    case 'MoG'
        
        %% MoG Background Subtraction
        debugRecord = varin2out(varargin);
%         debugRecord = 1; 
        T = 300;
        fAlphaT = 1/T;    fTb = 3 * 3;
        videoPostName = ['windowCombineDebug_MoG_fAlphaT' num2str(T) '_fTb' num2str(fTb) '_trial3'];
        resVivoDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\window_combine_debug';
        
        if debugRecord
            moviefile = fullfile(resVivoDataPath, [videoName{id}(1:end - 4) videoPostName]); 
            framerate = 5; aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
        end
        
        startFrame = 1;
        endFrame = nframes;
        fg = zeros(frameHeight, frameWidth, endFrame - startFrame + 1);
        lastLoopFrameNum = (endFrame - startFrame + 1) * (nd -1) / nd;
        for t=startFrame:endFrame
            
            % get the nextframe
            img_color = imread([srcdirImg filenamesImg{t}]);
            %     img = rgb2gray(img_color);
            img = img_color;
            
            if t==startFrame
                % initialize background subtraction
                h=mexCvBSLib(img);%Initialize
                mexCvBSLib(img,h,[fAlphaT fTb 0 0.5]);%set parameters
            end
            
            fgMask=mexCvBSLib(img,h);
            
            figure(1);
            subplot(1,2,1);imshow(img);
            subplot(1,2,2);imshow(fgMask);
            fgMask = medfilt2(fgMask, [5 5]);
            title(sprintf('Frame:%d',t));
            fg(:, :, t - startFrame + 1) = fgMask;
            
            % only record the last loop
            if debugRecord && t > lastLoopFrameNum
                frame = getframe(gcf);
                aviobj = addframe(aviobj, frame);
            end
            
        end
        
        % save(['Camera' num2str(CameraId) 'bgSub.mat'], 'fg');
        fg = fg(:, :, endFrame - endFrame/nd + 1 : endFrame);
        varargout{1} = fg;  varargout{2} = srcdirImg; varargout{3} = filenamesImg;
%         save(fullfile(resVivoDataPath, [filename videoPostName '_bgSub.mat']), 'fg');
%         save([filename 'bgSub.mat'], 'fg');
        mexCvBSLib(h);
        
        if debugRecord
            aviobj = close(aviobj);
        end
        
        close all;
        
    case 'MEAN'
        %% MEAN Background Subtraction
        % Parameter Setting Section
        threshold = 10;
        debugRecord = 1; 
        videoPostName = ['_windowCombineDebug2_threshold' num2str(threshold)];
        resVivoDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\window_combine_debug';
        
        if debugRecord
            moviefile = fullfile(resVivoDataPath, [videoName{id}(1:end - 4) videoPostName]); 
            framerate = 5; aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
        end
        
        startFrame = 1;
        endFrame = nframes;
        fg = uint8(zeros(frameHeight, frameWidth, 3, endFrame - startFrame + 1));
        
%         img_color = imread([srcdirImage filenamesImg{1}]);
        video_color = [];
        for t = startFrame : endFrame            
            img_color = imread([srcdirImg filenamesImg{t}]);            
            nd = ndims(img_color); 
            video_color = cat(nd + 1, video_color, img_color);            
        end
        
        meanBackGround = mean(video_color, nd+1);
        for t = startFrame : endFrame            
            img_color = imread([srcdirImg filenamesImg{t}]);            
            tempfg = uint8(abs(double(img_color) - meanBackGround));
            tempfg(tempfg>threshold) = 255;
            fg(:, :, :, t - startFrame + 1) = tempfg;
            figure(1); 
            subplot(1, 2, 1); imshow(uint8(img_color), 'border', 'tight');  
            title(['Frame ' num2str(t)]);
            subplot(1, 2, 2); imshow(fg(:, :, :, t - startFrame + 1), 'border', 'tight');
            pause(1/11);
            if debugRecord
                frame = getframe(gcf);
                aviobj = addframe(aviobj, frame);
            end
        end
        
        if debugRecord
            aviobj = close(aviobj);
        end
        
        save(fullfile(resVivoDataPath, [filename 'WindowCombine_Mean_bgSub.mat']), 'fg');
        close all;
end
        %% Batch Run
        % load 3tubes_010flow_g10_bgSub.mat
        % id = 4;
        % load ([videoName{id}(1:end-4) '_bgSub.mat']);
        % nframe = endFrame / nd;   nSeg = zeros(nframe, 1);
        % PixelThreshold = 2000;
        % record = 0;
        % if record
        %     moviefile = [videoName{id}(1:end - 4) '_FT1.avi']; framerate = 5;
        %     aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
        % end
        % for t = 1 : nframe
        % % for t = 58
        %     figure(1); I = fg(:, :, t); imshow(I, 'border', 'tight');
        %     Ifilt = medfilt2(I); Ifilt = medfilt2(Ifilt);
        %     figure(2); imshow(Ifilt, 'border', 'tight');
        %     STATS = regionprops(Ifilt>0);
        %     nSeg(t) = length(STATS);
        %     if nSeg(t) ~= 0
        %         a = structField2Vector(STATS, 'Area');
        %         if nSeg(t) < 10 && sum(a) < PixelThreshold;
        %             display(['Frame ' num2str(t)]);
        %             ColorSet = varycolor(nSeg(t));
        %             for i = 1 : length(STATS)
        %                 figure(2); hold on;
        %                 rectangle('Position', STATS(i).BoundingBox, 'EdgeColor', ColorSet(i, :), 'LineWidth', 4);
        %                 hold off;
        %             end
        %         end
        %     end
        %     if record
        %         frame = getframe(gcf);
        %         aviobj = addframe(aviobj, frame);
        %     end
        % end
        %
        % if record
        %     aviobj = close(aviobj);
        % end
        %
        % figure(3); plot(1:nframe, nSeg);
        
        %% Seperate Run
        % nframe = 250;   nSeg = zeros(nframe, 1);
        % t = 59;
        % figure(1); I = fg(:, :, t); imshow(I, 'border', 'tight');
        % Ifilt = medfilt2(I); Ifilt = medfilt2(Ifilt);
        % figure(2); imshow(Ifilt, 'border', 'tight');
        % STATS = regionprops(Ifilt>0);
        % nSeg(t) = length(STATS);
        % ColorSet = varycolor(nSeg(t));
        % for i = 1 : length(STATS)
        %     figure(2); rectangle('Position', STATS(i).BoundingBox, 'EdgeColor', ColorSet(i, :));
        % end