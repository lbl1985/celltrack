function saveResultsTextFile(obj, bkgdThreshold, atLeastShownUpThreshold, datasetName, id, percent)
savingPath = fullfile(getProjectBaseFolder, 'Results', 'textResults');
checkFolder(savingPath);

fileName = ['bkgdTh_' num2str(bkgdThreshold) '_showTh_' ...
    num2str(atLeastShownUpThreshold) '.txt'];
fid = fopen(fullfile(savingPath, fileName), 'a');
fprintf(fid, ['TestSet: ' datasetName '\tFile Id: ' num2str(id) '\n'...
    'File Name: ' obj.videoName ...
    '\tPercentage: ' num2str(percent) '\n']);

nDB = length(obj.DB);
ndigital = floor(log(nDB)/log(10) + 1);
for i = 1 : nDB
    str = ['\tCell Id: ' num2str2(i, ndigital) '\t\tFrom:\t' ...
        num2str2(obj.DB{i}.timeIDX(1), 4) '\t\tTo:\t' ...
        num2str2(obj.DB{i}.timeIDX(end), 4) '\n'];
    fprintf(fid, str);
end
fclose(fid);