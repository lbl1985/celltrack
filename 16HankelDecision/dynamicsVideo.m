% Working Log:
% Intermediate function between main_celltrack and dynamicsCheck.
% Binlong Li    25 June 2011    11:11AM
function varargout = dynamicsVideo(fgVideo)
nframes = size(fgVideo, ndims(fgVideo));
degreeVideo = zeros(nframes, 1);
combineImage = zeros(size(fgVideo));
vecBatch = cell(nframes, 1);
STATSBatch = cell(nframes, 1);
for i = 2 : nframes - 1
    [degreeVideo(i) combineImage(:, :, i) vecBatch{i} STATSBatch{i}] = dynamicsCheck(fgVideo, i);
end
varargout{1} = degreeVideo;
varargout{2} = combineImage; 
varargout{3} = vecBatch;
varargout{4} = STATSBatch;