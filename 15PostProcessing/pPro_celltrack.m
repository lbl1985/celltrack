function varargout = pPro_celltrack(fg, isVis, isSpec)

nframes = size(fg, ndims(fg));
if isVis
    display('fg Visualization');
    visSubFun(fg, isSpec);
end

% Median Filter
fgVideo = zeros(size(fg));
for i = 1 : nframes
    tfg = fg(:, :, i);
    tfg = medfilt2(tfg, [3 3]);
    fgVideo(:, :, i) = tfg;
end
if isVis
    display('fgVideo Visualization');
    visSubFun(fgVideo, isSpec);
end


openClosingVideo = OpenClosingProcess(fgVideo);
varargout{1} = fgVideo;
varargout{2} = openClosingVideo;

% closingVideo = logic(fgVideo);
% se90 = strel('diamond', 3, 90);     se0 = strel('diamond', 3, 0);
% for i = 1 : nframes
%     tfg = fgVideo(:, :, i);
    




function visSubFun(fg, isSpec)

nframes = size(fg, ndims(fg));
close all;
if isSpec
    startShowFrame = 44;    endShowFrame = 50;
else
    startShowFrame = 1;     endShowFrame = nframes;
end

for i = startShowFrame : endShowFrame
    tfg = fg(:, :, i);
    imshow(uint8(tfg));
    title(['Frame ' int2str(i)]);
    pause(1/11);
end
