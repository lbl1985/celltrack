clear
if ispc 
    datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\batchRun_object';
else
    datapath = '/Users/herbert19lee/Documents/MATLAB/work/celltrack/Results/vivo/batchRun_object';
end
[datapath videoName n] = rfdatabase(datapath, [], '.mat');
for i = 1 : n
    idName = videoName{i}(7 : end - 4);
    display(['i = ' num2str(i) '    ' idName]);
    load(fullfile(datapath, videoName{i}));
    vt = 
end