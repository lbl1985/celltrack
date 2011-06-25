function pPro_celltrack(fg, isVis)

nframes = size(fg, ndims(fg));
%% 
if isVis
    close all; 
    startShowFrame = 44;    endShowFrame = 50;
    for i = startShowFrame : endShowFrame
        imshow(uint8(fg(:, :, i)));
        title(['Frame ' int2str(i)]);
        pause(1/11);        
    end
end