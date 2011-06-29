% Working Log:
% main_celltrackin will be the general all-in-one console for the whole project. 
% Adding output argument: fg for CellTrajectory Function.
% Binlong Li    25 June 2011    07:51AM

% Pre-preparation Section
% extract the location for working main function
close all; 
workingpath = which('main_celltrack.m');
workingpath = workingpath(1:strfind(workingpath, 'main_celltrack.m') - 1);
addpath(genpath(pwd));

% Parameter Setting Section
% method = 'MEAN';
method = 'MoG';
isSliding = 'OFF';
% Recording 
debugRecord = 0;
datapath = fullfile(workingpath, 'vivo');

switch isSliding
    case 'OFF'
        if strcmp(method, 'MoG')
            nd = 4;        
        else
            nd = 1;
        end
        
        % parameter setting section
        T = 300;            fTb = 3 * 3;
        videoPostName = ['windowCombineDebug_MoG_fAlphaT' num2str(T) '_fTb' num2str(fTb) '_reorg_trial1'];
        resVivoDataPath = fullfile(workingpath, '\Results\vivo\window_combine_debug\');
        filevar = [{datapath} {videoPostName} {resVivoDataPath}];
        for id = 8
            [fg srcdirImg filenamesImg] = CellTrajectory(id, nd, method, filevar, debugRecord, T, fTb);
        end
        
    case 'ON'
        if strcmp(method, 'MoG')
            nd = 4;        
        else
            nd = 1;
        end
        for id = 8
            CellTrajectory_WindowCombine(id, nd, method);
        end
end

% Post Processing, median filter and close-opening operations.
isVis = 0;  isSpec = 0;
fgVideo = pPro_celltrack(fg, isVis, isSpec);

% Dynamics Checking Section
[degreeVideo combineImage vecBatch STATSBatch] = dynamicsVideo(fgVideo);

% Cell Number Gen Section
cellID= cellIDGen(degreeVideo, STATSBatch);

%% Result Visualization Section
isRecord = 1;
if ~isRecord
    recordFileName = [];
else
    recordFileName = fullfile(workingpath, '\Results\vivo\bkgd_with_dynamics', ...
        '15_bkgd_with_dynamics_reorg_trial1.avi');
end
ideaShow_celltrack('bkgd_with_dynamics', isRecord, recordFileName, fg, srcdirImg, filenamesImg, fgVideo, combineImage, STATSBatch, cellID);
    