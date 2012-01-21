function batchExp_sub(datasetName, workingpath, bkgdThreshold, atLeastShownUpThreshold, isShow)
% workingpath = getProjectBaseFolder;
% projectAddPath(workingpath, 'celltrack');

% ------ Changing dataset HERE ------
% datasetName = 'mouse2_o1_10_14';
% datasetName = 'mouse2_o2_10_14';
% datasetName = 'retro_10_14';
% datasetName = 'tail_vein_10_14';
% datasetName = 'mouse2o1';
% datasetName = 'mouse1_injection1';
%  datasetName = 'test';
% ------------------------------------
datapath = fullfile(workingpath, datasetName);
[datapath videoName n_video] = rfdatabase(datapath, [], '.tif');

% bkgd subtraction section
for id = 1 : n_video
% for id = 7    
    vt = cellCountClip(datapath, videoName{id});
    % Now, it's not compensation any more. It's the absolut path.
    vt.resultVideoPathCompensation = fullfile(getProjectBaseFolder, 'Results', 'batchExp', datasetName, 'batchRun_object');
    savingVideoPathAbsolute = vt.resultVideoPathCompensation;
    checkFolder(vt.resultVideoPathCompensation);
    vt.ratio = 1;
    vt.read_Video();
    % This version is much faster than loop. 0.009501s v.s. 0.665266s
    orig_avg = mean(vt.origVideo, 3);
    vt.storeOrigVideo = vt.origVideo;
    
    vt.origVideo = bsxfun(@minus, vt.origVideo, uint8(orig_avg));
    vt.origVideo = vt.origVideo>= bkgdThreshold;
    vt.origVideo = uint8(vt.origVideo) * 255;  
    
    vt.nFrame = 1000;
%     vt.bkgd_subtraction_MoG();
 %   vt.bkgd_subtraction_rpca();

    vt.saveData();
    clear vt
end

 %% cellCount Section: centroid Trajectory Increamental Video
baseFolder = getProjectBaseFolder();

% ------ Changing dataset HERE ------
% datasetName = 'mouse2_o1_10_14';
% datasetName = 'mouse2o1';
% datasetName = 'mouse2_o2';
% datasetName = 'retro';
% datasetName = 'tail_vein';
% datasetName = 'mouse1_injection1';
% datasetName = 'test';
% ------------------------------------

% Direct use the path before to deal with.
% datapath = fullfile(baseFolder, 'Results', 'batchExp', datasetName, 'batchRun_object');
datapath = savingVideoPathAbsolute;

% if ispc 
%     datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object';
% else
%     datapath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/batchRun_object';
% end
% combinedImagePath = fullfile(baseFolder, 'Results', 'vivo', 'combinedImage');
% combinedImagePath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/combinedImage';
[datapath videoName n_var] = rfdatabase(datapath, [], '.mat');

% As the error message, the number of variable should be equal to number of
% videos.
if ~isequal(n_var, n_video)
    error('n_var should be equal to n_video');
end
isVisWithOrig = 1;

for i = 1 : n_var
    idName = videoName{i}(7 : end - 4);
    display([idName 'i = ' num2str(i)]);
    load(fullfile(datapath, videoName{i}));
    command = ['vt = v' idName '; clear v' idName ';'];
    eval(command);
    vt.playType = 'orig'; %'mog'; %'rpca'
%     vt.resultVideoPathCompensation = ['../../Results/' datasetName '/batchRun_object/'];
    resultVideoPath = fullfile(getProjectBaseFolder, 'Results', datasetName, ...
        'video\');
    checkFolder(resultVideoPath);
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
%     figure(1); playM_asVideo(trackBlobsObj.fgAfterClosing.Data);
    
    trackBlobsObj.blobTrackingFunc();

    % Merge by Location
    trackBlobsObj.DBMergeLocation();
    trackBlobsObj.DBMergeLocation();    
    % TODO Dynamics    
    trackBlobsObj.dbCleanUp(atLeastShownUpThreshold);
    % Merge by Dynamics
%     trackBlobsObj.DBMergeDynamics();
    trackBlobsObj.DBMergeDynamics2();
    
    trackBlobsObj.DBSortByFrame();
    
    if isShow == 1
        if isVisWithOrig == 0        
            trackBlobsObj.playTrackingBlobs();
            trackBlobsObj.videoName = ['video' idName '_TrajOnly_Time_' ...
                datestr(now, 'HH_MM_mmm_dd_yy') '.avi'];
            trackBlobsObj.saveTrackingBlobs();
        else
            trackBlobsObj.playTrackingBlobsWithOrig(vt.storeOrigVideo);        
            trackBlobsObj.videoName = fullfile(resultVideoPath, ...
                ['video' idName '_Time_' datestr(now, 'HH_MM_mmm_dd_yy') '.avi']);
            trackBlobsObj.saveTrackingBlobsWithOrig(vt.storeOrigVideo);
        end
    end
%     trackBlobsObj.playTrackingBlobs();
%     trackBlobsObj.videoName = ['video' idName '_WithTraj.avi'];
%     trackBlobsObj.saveTrackingBlobs();
%     blobDetector.saveVideoCombinedImage(fullfile(combinedImagePath, [idName '.jpg']));  
%     saver1 = videoSaver(['video' idName '_increase.avi'], 11);
%     saver1.save(blobDetector.centroidTrajectoryIncrease);
%     clear saver1
end