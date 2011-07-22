function updateQueryBlob(obj, qualifyId)
%UPDATEQUERYBLOB Summary of this function goes here
%   Detailed explanation goes here
trajId = length(obj.trajArrInVideo) + 1;
for j = 1 : length(qualifyId)
    tmpTraj = trajectory(trajId, obj.blobsInNextFrame.frameBlobs(qualifyId(j)));
    if trajId == 1
        obj.trajArrInVideo = tmpTraj;
    else
        obj.trajArrInVideo(trajId) = tmpTraj;
    end
    obj.updateTmpTrajArr('blob', trajId);
end

