% Log:
% Start Working at OpenClosing Post Processing
% Binlong Li    12:45PM     30 June 2011
function fgOpenClosing = OpenClosingProcess(fgVideo)
% fgVideo is Video Mat data with gray images.
% Input:    fgVideo
% Output:   After Processing Video
% Binlong Li    12:58PM     30 June 2011
nframes = size(fgVideo, 3);
fgOpenClosing = unit8(zeros(size(fgVideo)));
% parameters Setting Section
se = strel('ball', 5, 5);
for i = 1 : nframes
    tfg = fgVideo(:, :, i);
    figure(1); subplot(1, 3, 1); imshow(uint8(tfg));    title('orig Image');
    tfg_dilate = imdilate(tfg, se);
    subplot(1, 3, 2); imshow(uint8(tfg_dilate)); title('fg dilate');
    tfg_erode = imerode(tfg_dilate, se);
    subplot(1, 3, 3); imshow(uint8(tfg_erode)); title('fg erode');
    fgOpenClosing(:, :, i) = uint8(tfg_erod);
end
    