clear all; close all; clc;
workingpath = which('main_celltrack.m');
workingpath = workingpath(1:strfind(workingpath, 'main_celltrack.m') - 1);
projectAddPath(workingpath, 'celltrack');

% ------ Changing dataset HERE ------
% datasetName = 'mouse2_o1';
datasetName = 'mouse2_o2';
% datasetName = 'retro';
% datasetName = 'tail_vein';
% ------------------------------------

datapath = fullfile(workingpath, '01database', datasetName);
[datapath videoName n] = rfdatabase(datapath, [], '.tif');

% bkgd subtraction section
for id = 2 : n
% for id = 7    
    vt = cellCountClip(datapath, videoName{id});
    vt.resultVideoPathCompensation = fullfile(getProjectBaseFolder, 'Results', datasetName, 'batRun_object');
    checkFolder(vt.resultVideoPathCompensation);
    vt.ratio = 1;
    vt.read_Video();
    vt.bkgd_subtraction_MoG();
    vt.bkgd_subtraction_rpca();

    vt.saveData();
    clear vt
end

%% cellCount Section: centroid Trajectory Increamental Video
clear; close all;
baseFolder = getProjectBaseFolder();

% ------ Changing dataset HERE ------
% datasetName = 'mouse2_o1';
datasetName = 'mouse2_o2';
% datasetName = 'retro';
% datasetName = 'tail_vein';
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
isVisWithOrig = 1;
for i = 11
    idName = videoName{i}(7 : end - 4);
    display([idName 'i = ' num2str(i)]);
    load(fullfile(datapath, videoName{i}));
    command = ['vt = v' idName '; clear v' idName ';'];
    eval(command);
    vt.coverNoiseCloud();
    vt.medianFilter();
    vt.medianFilter2();
    blobDetector = detectBlob(vt.fg_rpca_median);
    blobDetector.blobDetectionVideo();
    
    trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);
    trackBlobsObj.OpenClosingProcess();
    trackBlobsObj.blobTrackingFunc();

    trackBlobsObj.DBMergeLocation();
    trackBlobsObj.DBMergeLocation();
    % TODO Dynamics
    trackBlobsObj.DBMergeDynamics();
    trackBlobsObj.dbCleanUp();
    trackBlobsObj.DBSortByFrame();
    
    if isVisWithOrig == 0        
        trackBlobsObj.playTrackingBlobs();
        trackBlobsObj.videoName = ['video' idName '_WithTraj.avi'];
        trackBlobsObj.saveTrackingBlobs();
    else
        trackBlobsObj.playTrackingBlobsWithOrig(vt.origVideo);        
        trackBlobsObj.videoName = ['video' idName '_WithTraj_withOrig.avi'];
        trackBlobsObj.saveTrackingBlobsWithOrig(vt.origVideo);
    end
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