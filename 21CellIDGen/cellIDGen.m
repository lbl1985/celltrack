function varargout = cellIDGen(degreeVideo, STATSBatch)
ID = 0;
nframes = length(degreeVideo);
% if degreeVideo is not zero, we consider it as cell showing up at that
% frame.
isCell = degreeVideo > 0;
for t = 1 : nframes
    if isCell(t)
        Bounding = structField2Vector(STATSBatch{t}, 'Centroid');
%         cellBounding = 
        if ~isCell(t - 1)
            ID = ID + 1;
        end
    end
end

varargout{1} = cellID; 
% [cellID cellBounding]= 