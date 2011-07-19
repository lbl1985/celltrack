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
    command = ['gTruth_temp = cellCountGroundTruth(v' idName '.videoPath, v' idName '.videoName);'];
    eval(command);
    
    %; user input
    command = ['gTruth_' idName ' = gTruth_temp']; eval(command);
    save(fullfile(gTruth_temp.videoPath, gTruth_temp.resultDataPathCompensation, ...
        ['groundTruth_' gTruth_temp.videoName(1:end - 5) '.mat']), ['gTruth_' idName ]);
end