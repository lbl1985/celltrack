clear all; close all; clc;
workingpath = which('main_celltrack.m');
workingpath = workingpath(1:strfind(workingpath, 'main_celltrack.m') - 1);
projectAddPath(workingpath, 'celltrack');

datapath = fullfile(workingpath, '01database', 'vivo');
[datapath videoName n] = rfdatabase(datapath, [], '.avi');

for id = [1 4 6:11 13:17]
% for id = 7    
    vt = cellCountClip(datapath, videoName{id});
    vt.read_Video();
    vt.bkgd_subtraction_MoG();
    vt.bkgd_subtraction_rpca();

    vt.saveData();
    clear vt
end