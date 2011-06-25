% Working Log:
% Intermediate function between main_celltrack and dynamicsCheck.
% Binlong Li    25 June 2011    11:11AM
function degreeVideo = dynamicsVideo(fgVideo)
nframes = size(fgVideo, ndims(fgVideo));
degreeVideo = zeros(nframes, 1);
for i = 2 : nframes - 1
    degreeVideo(i) = dynamicsCheck(fgVideo, i);
end