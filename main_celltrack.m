% Working Log:
% main_celltrackin will be the general all-in-one console for the whole project. 
% Adding output argument: fg for CellTrajectory Function.
% Binlong Li    25 June 2011    07:51AM

% Parameter Setting Section
close all; 
% method = 'MEAN';
method = 'MoG';
isSliding = 'OFF';
% Recording 
debugRecord = 0;

switch isSliding
    case 'OFF'
        if strcmp(method, 'MoG')
            nd = 4;        
        else
            nd = 1;
        end
        for id = 8
            [fg srcdirImg filenamesImg] = CellTrajectory(id, nd, method, debugRecord);
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
isVis = 1;  isSpec = 0;
fgVideo = pPro_celltrack(fg, isVis, isSpec);

% Dynamics Checking Section
[degreeVideo combineImage vecBatch] = dynamicsVideo(fgVideo);

% Result Visualization Section
nframes = size(fg, ndims(fg));
fig = figure(1);
for t = 1 : nframes
    subplot(2, 3, 1); imread([srcdirImg filenamesImg{t}]);
    title(['Origin Frame ' num2str(t)]);
    subplot(2, 3, 2); imshow(fg(:, :, t));
    title('bkgd Sub Res');
    subplot(2, 3, 3); imshow(fgVideo(:, :, t));
    title('Median Filter Res');
    subplot(2, 3, 4); imshow(combineImage(:, :, t));
    title('Combine Images');
    subplot(2, 3, 5); vec = vecBatch{t};
    plot(vec(:, 1), vec(:, 2), 'ro');    axis([1 size(fg(:, :, 1), 2) 1 size(fg(:, :, 1), 1)]);
    title('Region Centroids Locations');
    subplot(2, 3, 6);
end
    
    