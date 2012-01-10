% clear all; close all; clc;
% workingpath = which('main_celltrack.m');
% workingpath = workingpath(1:strfind(workingpath, 'main_celltrack.m') - 1);
% projectAddPath(workingpath, 'celltrack');
% 
% % ------ Changing dataset HERE ------
% % datasetName = 'mouse2_o1_10_14';
% % datasetName = 'mouse2_o2_10_14';
% % datasetName = 'retro_10_14';
% % datasetName = 'tail_vein_10_14';
% % datasetName = 'mouse2o1';
% % datasetName = 'mouse1_injection1';
%  datasetName = 'test';
% % ------------------------------------
% datapath = fullfile(workingpath, '01database', datasetName);
% [datapath videoName n] = rfdatabase(datapath, [], '.tif');
% 
% % bkgd subtraction section
% for id = 3
% % for id = 7    
%     vt = cellCountClip(datapath, videoName{id});
%     vt.resultVideoPathCompensation = fullfile('..', '..', 'Results', datasetName, 'batchRun_object');
%     checkFolder(vt.resultVideoPathCompensation);
%     vt.ratio = 1;
%     vt.read_Video();
%     
%     % averaging
% %     tic
% %         for m=1:125
% %             for p=1:125
% %                 orig_avg(m,p) = mean(vt.origVideo(m,p,:));
% %             end
% %         end
%     % This version is much faster than loop. 0.009501s v.s. 0.665266s
%     orig_avg = mean(vt.origVideo, 3);
% %     toc    
% %     tic
% %     for q=1:1000
% %         vt.origVideo(:,:,q)=vt.origVideo(:,:,q)-uint8(orig_avg);
% %         for x=1:125
% %             for y=1:125
% %                 if vt.origVideo(x,y,q)>=75
% %                     vt.origVideo(x,y,q)=255;
% %                 else
% %                     vt.origVideo(x,y,q)=0;
% %                 end
% %             end
% %         end
% %     end
%     vt.storeOrigVideo = vt.origVideo;
%     
%     vt.origVideo = bsxfun(@minus, vt.origVideo, uint8(orig_avg));
%     vt.origVideo = vt.origVideo>= 75;
%     vt.origVideo = uint8(vt.origVideo) * 255;   
%     
% %     toc
%    % vt.origVideo = uint8(vmouse2_inj2_26.foreGround_MoG);
%     vt.nFrame = 1000;
% %     vt.bkgd_subtraction_MoG();
%  %   vt.bkgd_subtraction_rpca();
% 
%     vt.saveData();
%     clear vt
% end

 %% cellCount Section: centroid Trajectory Increamental Video
clear; close all;
baseFolder = getProjectBaseFolder();

% ------ Changing dataset HERE ------
% datasetName = 'mouse2_o1_10_14';
% datasetName = 'mouse2o1';
% datasetName = 'mouse2_o2';
% datasetName = 'retro';
% datasetName = 'tail_vein';
% datasetName = 'mouse1_injection1';
datasetName = 'test';
% ------------------------------------

datapath = fullfile(baseFolder, 'Results', datasetName, 'batchRun_object');
% if ispc 
%     datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object';
% else
%     datapath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/batchRun_object';
% end
% combinedImagePath = fullfile(baseFolder, 'Results', 'vivo', 'combinedImage');
% combinedImagePath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/combinedImage';
[datapath videoName n] = rfdatabase(datapath, [], '.mat');
for i = 1
    idName = videoName{i}(7 : end - 4);
    display([idName 'i = ' num2str(i)]);
    load(fullfile(datapath, videoName{i}));
    command = ['vt = v' idName '; clear v' idName ';'];
    eval(command);
    vt.playType = 'orig'; %'mog'; %'rpca'
    vt.resultVideoPathCompensation = ['../../Results/' datasetName '/batchRun_object/'];
%     vt.coverNoiseCloud();
%   vt.medianFilter();
%  vt.medianFilter2();

    if strcmp(vt.playType, 'rpca');
%         vt.fg_rpca_median = vt.foreGround_RPCA;
        blobDetector = detectBlob(vt.fg_rpca_median);
    elseif strcmp(vt.playType, 'mog');
        vt.fg_mog_median = vt.foreGround_MoG;
        blobDetector = detectBlob(vt.fg_mog_median);
    else
        vt.fg_mog_median = vt.origVideo;
        vt.medianFilter();
        blobDetector = detectBlob(vt.fg_mog_median);
    end
    blobDetector.blobDetectionVideo();
    
    % blobDetector.inputVideoData is the bkgd subtraction result after
    % medianFilter.
    trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
    trackBlobsObj.OpenClosingProcess();
    trackBlobsObj.blobTrackingFunc();

    trackBlobsObj.DBMergeLocation();
    trackBlobsObj.DBMergeLocation();
    % TODO Dynamics
    trackBlobsObj.DBMergeDynamics();
    trackBlobsObj.dbCleanUp();
    trackBlobsObj.DBSortByFrame();
    trackBlobsObj.playTrackingBlobs();
    trackBlobsObj.videoName = ['video' idName '_WithTraj.avi'];
    trackBlobsObj.saveTrackingBlobs();
    trackBlobsObj.saveTrackingBlobs;
%     blobDetector.saveVideoCombinedImage(fullfile(combinedImagePath, [idName '.jpg']));  
%     saver1 = videoSaver(['video' idName '_increase.avi'], 11);
%     saver1.save(blobDetector.centroidTrajectoryIncrease);
%     clear saver1
end
%% centroidTrajectory Combine Section
% clear
% load video_15.mat
% v15.medianFilter();
% blobDetector = detectBlob(v15.fg_rpca_median);
% blobDetector.blobDetectionVideo();
% imshow(sum(blobDetector.centroidTrajectory, 3))

%% centroidTrajectory with Ground Truth
% function centroidTrajectoryIncrease_saveAsVideo(obj)
% clear; close all;
% groundTruthStructure;
% if ispc 
%     datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object';
% else
%     datapath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/batchRun_object';
% end
% 
% [datapath videoName n] = rfdatabase(datapath, [], '.mat');
% centroidTrajectoryWithGroundTruthSavingPath = ...
%     'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\trajectoryWithCellNum';
% for i = 1 : n
%     idName = videoName{i}(7 : end - 4);
%     display([idName 'i = ' num2str(i)]);
%     
%     load(fullfile(datapath, videoName{i}));
%     command = ['vt = v' idName '; clear v' idName ';'];
%     eval(command);
%     vt.medianFilter();
%     blobDetector = detectBlob(vt.fg_rpca_median);
%     blobDetector.blobDetectionVideo();
%     
%     command = ['gt = gt_' idName ';'];  eval(command);
%     filename = fullfile(centroidTrajectoryWithGroundTruthSavingPath, [idName '_bkgdComparsion.avi']);
%     saver1 = centroidTrajectoryWithGroundTruthVideoSaver(filename, 11);
%     mog = vt.foreGround_MoG;    mog(mog > 0.1) = 255; 
%     rpca = vt.fg_rpca_median;   rpca(rpca > 0.1) = 255;
%     saver1.saveWithGroundOnCaption([mog vt.origVideo rpca], gt);
% %     saver1.saveWithGroundOnCaption([vt.origVideo vt.foreGround_MoG blobDetector.centroidTrajectoryIncrease(:, :, 1:250)], gt);
% end