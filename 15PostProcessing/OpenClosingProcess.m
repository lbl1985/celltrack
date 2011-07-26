% Log:
% Start Working at OpenClosing Post Processing
% Binlong Li    12:45PM     30 June 2011
function fgOpenClosing = OpenClosingProcess(fgVideo)
% fgVideo is Video Mat data with gray images.
% Input:    fgVideo
% Output:   After Processing Video
% Binlong Li    12:58PM     30 June 2011
nframes = size(fgVideo, 3);
fgOpenClosing = uint8(zeros(size(fgVideo)));
% parameters Setting Section
se = strel('ball', 5, 5);
for i = 1 : nframes
    tfg = fgVideo(:, :, i);
    tfg_dilate = imdilate(tfg, se);
    tfg_erode = imerode(tfg_dilate, se);
    fgOpenClosing(:, :, i) = uint8(tfg_erode);
end
    