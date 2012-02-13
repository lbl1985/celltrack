testBedLocation = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\01database\test';
[~, foldernames, n] =  folderList(testBedLocation);
isShow = 0;

for bkgdThreshold = 75 %75 : 5 : 90
    for atLeastShownUpThreshold = 1 %1 : 3
        for i = 1 
            testFolder = foldernames{i};
            batchExp_sub(testFolder, testBedLocation, bkgdThreshold, atLeastShownUpThreshold, isShow);
        end
    end
end