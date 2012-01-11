% Log:
% Start Working at OpenClosing Post Processing
% Binlong Li    12:45PM     30 June 2011
% function fgOpenClosing = OpenClosingProcess(fgVideo)
function OpenClosingProcess(obj)
% fgVideo is Video Mat data with gray images.
% Input:    fgVideo
% Output:   After Processing Video
% Binlong Li    12:58PM     30 June 2011
nframes = size(obj.fg.Data, 3);
fgOpenClosing = uint8(zeros(size(obj.fg.Data)));
% parameters Setting Section
se_dil = strel('ball', 5, 5);
se_ero = strel('ball', 3, 3);
for i = 1 : nframes
    tfg = obj.fg.Data(:, :, i);
    tfg_dilate = imdilate(tfg, se_dil);
%     tfg_erode = tfg_dilate;
    tfg_erode = imerode(tfg_dilate, se_ero);
    tfg_erode(tfg_erode <= 128) = 0;
    fgOpenClosing(:, :, i) = uint8(tfg_erode);
end
obj.fgAfterClosing = videoVar(fgOpenClosing);