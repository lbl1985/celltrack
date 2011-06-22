% Working Log:
% Comparing the results between MoG and Mean Background Subtraction
% Binlong Li    22 June 2011    8:58AM

% Pre Preparation.
close all;

% Parameters Setting Section
% id Number correspoinding to order of videoName from rfdatabase.
id = 8;
% Record Tuner
record = 1;
% File Folder Settings sub section    
datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\vivo';
resVivoDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\data';
recordVideoPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\BGCompare';

% File Name Extraction Section
% datapath = 'C:\Users\lbl1985\Documents\MATLAB\work\database\celltracking\vivo';
datapath = folderUniverse(datapath, 'PC');

[datapath videoName n] = rfdatabase(datapath, [], '.avi');

Camera_dir = fullfile(datapath, videoName{id}(1:end-4));

[srcdirImg filenamesImg nframes] = rfdatabase(Camera_dir, [], '.jpg');
filename = filenamesImg{1}(1:end - 7);

% Record Preparation
if record
    moviefile = fullfile(recordVideoPath, [videoName{id}(1:end - 4) '_BGComparation.avi']); 
    framerate = 5; aviobj = avifile(moviefile, 'fps', framerate', 'compression', 'none');
end

% Read out Fore Ground Information
% resVivoDataPath = 'C:\Users\lbl1985\Documents\MATLAB\work\celltrack\Results\vivo\data';
load(fullfile(resVivoDataPath, [filename 'bgSub.mat']));
fg_MoG = fg;
load(fullfile(resVivoDataPath, [filename 'Mean_bgSub.mat']));
fg_Mean = fg; clear fg;
% Image Extraction Section
startFrame = 1;
endFrame = nframes;

% Comparing Visualization Section
for t = startFrame : endFrame
    img_color = imread([srcdirImg filenamesImg{t}]);
    figure(1);
    subplot(2, 2, 1); imshow(uint8(img_color)); title(['Frame ' num2str(t) ' -- Original Image']);
    subplot(2, 2, 2); imshow(uint8(fg_MoG(:, :, t))); title('MoG BG Subtraction');
    subplot(2, 2, 3); imshow(uint8(img_color)); title(['Frame ' num2str(t) ' -- Original Image']);
    subplot(2, 2, 4); imshow(uint8(fg_Mean(:, :, :, t)));   title('Mean BG Subtraction');
    
    % Record Option sub-Section
    if record
        frame = getframe(gcf);
        aviobj = addframe(aviobj, frame);
    end
end

% Record Option sub-Section Close up.
if record
    aviobj = close(aviobj);
end

