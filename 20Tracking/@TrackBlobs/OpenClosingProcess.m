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
se = strel('ball', 5, 5);
for i = 1 : nframes
    tfg = obj.fg.Data(:, :, i);
    tfg_dilate = imdilate(tfg, se);
    tfg_erode = imerode(tfg_dilate, se);
    fgOpenClosing(:, :, i) = uint8(tfg_erode);
end
obj.fgAfterClosing = videoVar(fgOpenClosing);