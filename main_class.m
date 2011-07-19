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
[datapath videoName n] = rfdatabase(...
    'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object', ...
    [], '.mat');
for i = 1 : n
    idName = videoName{i}(16 : end - 4);
    display(idName);
    load(fullfile(datapath, videoName{i}));
    command = ['vt = v' idName];
    eval(command);
    vt.medianFilter();
    blobDetector = detectBlob(v15.fg_rpca_median);
    blobDetector.blobDetectionVideo();
    figure(1); 
    imshow(sum(blobDetector.centroidTrajectory, 3))
    title(idName);
end
%% 
clear
load video_15.mat
v15.medianFilter();
blobDetector = detectBlob(v15.fg_rpca_median);
blobDetector.blobDetectionVideo();
imshow(sum(blobDetector.centroidTrajectory, 3))
    