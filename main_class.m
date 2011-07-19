clear all; close all; clc;
workingpath = which('main_celltrack.m');
workingpath = workingpath(1:strfind(workingpath, 'main_celltrack.m') - 1);
projectAddPath(workingpath, 'celltrack');

datapath = fullfile(workingpath, '01database', 'vivo');
[datapath videoName n] = rfdatabase(datapath, [], '.avi');

% bkgd subtraction section
% for id = [1 4 6:11 13:17]
% % for id = 7    
%     vt = cellCountClip(datapath, videoName{id});
%     vt.read_Video();
%     vt.bkgd_subtraction_MoG();
%     vt.bkgd_subtraction_rpca();
% 
%     vt.saveData();
%     clear vt
% end

%% cellCount Section
clear
if ispc 
    datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object';
else
    datapath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/batchRun_object';
end
combinedImagePath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/combinedImage';
[datapath videoName n] = rfdatabase(datapath, [], '.mat');
for i = 1 : n
    idName = videoName{i}(7 : end - 4);
    display([idName 'i = ' num2str(i)]);
    load(fullfile(datapath, videoName{i}));
    command = ['vt = v' idName '; clear v' idName ';'];
    eval(command);
    vt.medianFilter();
    blobDetector = detectBlob(vt.fg_rpca_median);
    blobDetector.blobDetectionVideo();
    blobDetector.saveVideoCombinedImage(fullfile(combinedImagePath, [idName '.jpg']));  
    saver1 = videoSaver(['video' idName '_increase.avi'], 11);
    saver1.save(blobDetector.centroidTrajectoryIncrease);
    clear saver1
end
%% 
clear
load video_15.mat
v15.medianFilter();
blobDetector = detectBlob(v15.fg_rpca_median);
blobDetector.blobDetectionVideo();
imshow(sum(blobDetector.centroidTrajectory, 3))

    